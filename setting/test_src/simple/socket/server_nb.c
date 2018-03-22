#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/select.h>
#include <errno.h>
#define BUF_SIZE 50

int make_socket(int port){
	int sock;
	int sockopt = 1;
	struct timeval timer;
	struct sockaddr_in serv_addr;

	sock = socket(AF_INET, SOCK_STREAM, 0);
	if(sock < 0){
		puts("socket create error");
		return -1;
	}

	if(setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, 
				(char*) &sockopt, sizeof(sockopt)) == -1){
		puts("error socket option : REUSEADDR");
		return -1;
	}

	if( fcntl(sock, F_SETFL, O_NONBLOCK) == -1 ){ /* Stratus VOS에서는 O_NDELAY */
		puts("error : listen socket nonblocking");
		return -1;
	}

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = htons(port);

	if( bind(sock, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) < 0 ){
		puts("bind error");
		return -1;
	}

	return sock;
}

int read_from_client(int fds, fd_set* active_fd_set){

	puts("read from client");

	char buffer[BUF_SIZE];
	char recv_buffer[100];

	int  offset=0;
	int  nBytes=0;

	memset(recv_buffer, 0x00, 100);

	/* 원하는 만큼 끊어읽기 위해서는 루프를 돌아야 한다 */
	while(offset < 70){ 

		memset(buffer, 0x00, BUF_SIZE);
		nBytes = read(fds, buffer, BUF_SIZE);

		if(nBytes == -1){
			/* 인터럽트나 소켓 버퍼에 데이터가 없다면 */
			if(errno == EINTR || errno == EAGAIN)
				continue;
			else if(errno == ECONNRESET ) /* TCP CONN RESET */
			{
				printf("[sds = %d] peer connect reset\n",fds);
				close(fds);
				FD_CLR(fds, active_fd_set);
				return -1;
			}
			else{
				printf("[sds = %d] read error\n",fds);
				close(fds);
				FD_CLR(fds, active_fd_set);
				return -1;
			}
		}else
			if(nBytes == 0){
				puts("EOF: socket");
				close(fds);
				FD_CLR(fds, active_fd_set);
				return -1;
			}

		/* 데이터 버퍼에 넣는 작업도 해줘야 한다*/
		printf("[sds = %d] %s\n",fds, buffer);

		memcpy(recv_buffer+offset, buffer, nBytes);
		offset += nBytes; 
	}

	printf("[sds = %d] total( offset: %d, nBytes: %d )\ndata: %s\n", fds, offset, nBytes, recv_buffer);
	return offset;

}

int main(int argc, char *argv[]){

	int i;
	int sock;
	fd_set active_fd_set, read_fd_set;

	struct timeval timer; /* select timer */
	int    ret_code;      /* result code  */ 
	int		portNum;

	if(argc != 2){
		printf("Usage\n");
		printf("%s [PORT NUMBER]\n", argv[0]);   
		return -1;
	}
	portNum = atoi( ( char* )argv[1] );

	sock = make_socket( portNum );
	if(sock < 0 ){
		return -1;
	}

	if(listen(sock, 1) < 0){
		puts("listen error");
		return -1;
	}

	FD_ZERO(&active_fd_set);
	FD_SET(sock, &active_fd_set);

	while(1){

		read_fd_set = active_fd_set;

		/* timeout 30 sec */
		timer.tv_sec  = 30;
		timer.tv_usec = 0;

		ret_code=select(FD_SETSIZE, &read_fd_set, 0, 0, &timer);
		if(ret_code == -1){
			puts("select() error : I don't know");
			return -1;
		}else
			if(ret_code == 0){
				puts("timeout! no I/O events");
				continue;
			}

		for(i=0;i<FD_SETSIZE;i++){
			if(FD_ISSET(i, &read_fd_set)){

				if(i == sock){
					int new;
					socklen_t   size;
					struct sockaddr_in client_addr;
					//struct sockaddr_storage client_addr;

					new = accept(sock, (struct sockaddr*)&client_addr, &size);

					/* 클라이언트 정상 연결 */
					if(new > 0){
						//puts("accept OK");
						//if(client_addr.ss_family == AF_INET)
						{
							printf("[Child %d] accept (ip:port) (%s:%d)\n\n", new
									, inet_ntoa( ((struct sockaddr_in*)&client_addr)->sin_addr)
									, ntohs( ((struct sockaddr_in*)&client_addr)->sin_port) );
						}

						if( fcntl(new, F_SETFL, O_NONBLOCK) == -1 ){
							puts("error : accept client socket nonblocking");
							return -1;
						}

						FD_SET(new, &active_fd_set);
						break;
					}

					if(new == -1){
						switch(errno){
							case EAGAIN:  /* 백로그 큐에 접속요청 없음 */
								continue;
							case EINTR:  /* 인터럽트 당함 */
								// 알아서 추가기능 구현
								continue;
							case ENOMEM: /* HEAP 메모리 없음 */
								puts("no memory for open a fd");
								break;
							case ENFILE: /* 파일디스크립트 한도 초과 */
								puts("max fd overflow");
								break; 
							default:
								puts("accept error!");
								break;
						}
					}

				}else{ /* from client */
					if(read_from_client(i, &active_fd_set) < 0){
						puts("read error");
						close(i);
						FD_CLR(i, &active_fd_set);
					}
				}
			}
		}/*LOOP END */
	}
	return 0;
}
