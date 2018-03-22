#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/select.h>

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
	int  nBytes=0;

	memset(buffer, 0x00, BUF_SIZE);
	nBytes = read(fds, buffer, BUF_SIZE);
	if(nBytes == -1){
		printf("[sds = %d]  read error\n",fds);
		return -1;
	}else
		if(nBytes == 0){
			puts("EOF: socket");
			close(fds);
			FD_CLR(fds, active_fd_set);
			return -1;
		}

	printf("[sds = %d] %s\n", fds, buffer);
	return nBytes;
}

int main(){

	int i;
	int sock;
	fd_set active_fd_set, read_fd_set;

	struct timeval timer; /* select timer */
	int    ret_code;      /* result code  */ 

	sock = make_socket(7654);
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

					new = accept(sock, (struct sockaddr*)&client_addr, &size);

					if(new < 0){
						puts("accept error");
						break;
					}

					FD_SET(new, &active_fd_set);
					puts("accept");

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
