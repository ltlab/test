/*---------------------------------------*
 *                                       *
 *     TCP Multiple Connection           *
 *     (Pre-fork and Pipe Model)         *
 *                                       *
 *      Lee, Taeyoung                    *
 *      @se2n.com                        *
 *---------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>

#define LISTEN_BACKLOG  100
//#define LISTEN_BACKLOG  3
//#define MAX_CONN_POOL    3
#define MAX_CONN_POOL    LISTEN_BACKLOG
#define ON               1
#define OFF              0
#define MSG_SIZE		4096

#define PIPE_READ        0
#define PIPE_WRITE       1

int    sd_listener;

void    TCP_Process(int SD, int idx, int Pipe[2]);    //
int     TCP_SocketOption(int SD);

int     SetFDBlock(int SD, int isBlock);
void    MessageProc(int Pipe[MAX_CONN_POOL][2]);


/*------------------------------*
 *      Main Procedure          *
 *------------------------------*/
int 
main(int argc, char *argv[]){

	int        i;
	short      port;

	pid_t      pid;                      // process ID for Fork
	socklen_t  len_saddr;                // socket length
	struct     sockaddr_in saddr_s= {} ; // socket address structure

	int        pipes[MAX_CONN_POOL][2];  // PIPE array to get messages from child processes

	if(argc != 2){
		printf("Usage\n");
		printf("%s [PORT NUMBER]\n", argv[0]);   
		return -1;
	}

	/* 
	 * 1. socket descriptor 
	 */
	if( (sd_listener = socket(AF_INET, SOCK_STREAM, IPPROTO_IP) ) == -1){
		printf("[TCP Server] Failed : socket()\n");
		return -1;
	}

	if(TCP_SocketOption(sd_listener) == -1){
		printf("TCP_SocketOption() Failed \n");
		return -1;
	}


	/* 
	 * 2. bind
	 */
	port=(short) atoi((char*) argv[1]);

	saddr_s.sin_family = AF_INET;
	saddr_s.sin_addr.s_addr = INADDR_ANY;   /* 0.0.0.0*/
	saddr_s.sin_port = htons(port);
	if( bind(sd_listener, (struct sockaddr*)&saddr_s, sizeof(saddr_s)) == -1 ){
		perror("[TCP Server] Failed : bind()\n");
		printf("[TCP Server] Failed : bind()\n");
		return -1;
	}


	/*
	 * 3. listen
	 */
	printf("[TCP Server] Port : %d\n", ntohs(saddr_s.sin_port));
	listen(sd_listener, LISTEN_BACKLOG);

	/*
	 * pre-fork : Making child processes & giving pipe infomation.
	 */
	for(i=0; i<MAX_CONN_POOL; i++){

		// make a pipe set : (index) [0] read_end, [1] write_end
		if(pipe(pipes[i]) == -1){
			printf("pipe call error %d", i);
			return -1;
		}

		switch(pid=fork()){
			case 0:    // Child process
				TCP_Process(sd_listener, i, pipes[i]);
				exit(EXIT_SUCCESS);
				break;
			case -1:   // Fork failed
				printf("[TCP Server] : Fail : fork()\n");
				break;
			default:   // Parent process
				printf("[TCP Server] Making Child process %d\n", i);
				break;
		}
	}

	// Read Messages from child processes
	MessageProc(pipes);

	printf("\n- Program End -\n");

	return 0;
}

/*------------------------------*
 *      Message Procedure       *
 *------------------------------*/
void 
MessageProc(int pipes[MAX_CONN_POOL][2]){

	int    i;
	int    len_recv=0;
	char    buffer[MSG_SIZE], ch;
	fd_set    fds_read, master;

	// close write channel, only using read channel
	for(i=0;i<MAX_CONN_POOL;i++)
	{
		close(pipes[i][PIPE_WRITE]);
		pipes[i][PIPE_WRITE] = -1;
	}

	FD_ZERO(&master);
	FD_SET( 0, &master);	//	fd(0): stdin

	for(i=0;i<MAX_CONN_POOL;i++)
		FD_SET(pipes[i][PIPE_READ], &master);

	int fullCount[ MAX_CONN_POOL ] = { 0, };

	size_t	totalRecv[ MAX_CONN_POOL ] = { 0, };

	int		maxFd = 0;

	while(1){

		maxFd = 0;

		FD_ZERO(&master);
		FD_SET( 0, &master);	//	fd(0): stdin

		for(i=0;i<MAX_CONN_POOL;i++)
		{
			if( pipes[ i ][ PIPE_READ ] > 0 )
			{
				FD_SET(pipes[i][PIPE_READ], &master);
			}
			if( maxFd <= pipes[ i ][ PIPE_READ ] )
			{
				maxFd =  pipes[ i ][ PIPE_READ ];
			}
		}
		if( maxFd == 0 )
		{
			printf( "[%s:%d] BREAK!!! for END\n", __func__, __LINE__ );
			break;
		}

		fds_read=master;

		// Detecting Events from File Descripts
		//if(select(pipes[MAX_CONN_POOL-1][0]+1, &fds_read, NULL, NULL, NULL) < 0){
		if(select( maxFd + 1, &fds_read, NULL, NULL, NULL) < 0){
			perror("select() error \n");
			printf("select() error \n");
			return;
		}

		// Standard Input : File Descriptor 0 
		if(FD_ISSET(0, &fds_read)){
			printf("STD Input: ");
			read(0, &ch, 1);
			printf("%c\n", ch);
		}

		// Watching Event flag(fds_read) setting from file desciptor set
		for(i=0;i<MAX_CONN_POOL;i++){

			// is set a event flag on pipe[i][0] position? then read a message.
			if(FD_ISSET(pipes[i][0], &fds_read)){

				memset(buffer, 0x00, sizeof(buffer));

				//pipe 
				if( (len_recv=read(pipes[i][0], buffer, MSG_SIZE)) > 0 ){

					totalRecv[ i ] += len_recv;

					if( len_recv < MSG_SIZE )
					{
						//fullCount[ i ] = 0;
						//printf( "[ MSG From %d ] %d Bytes\n[ %s ]\n", i, len_recv, buffer );
						if( ( ++fullCount[ i ] % 1000 ) == 0 )
						{
							printf( "1. [ MSG From %d ] %d Bytes\n", i, len_recv );
						}
					}
					else
					{
						if( ( ++fullCount[ i ] % 1000 ) == 0 )
						{
							printf( "2. [ MSG From %d ] %d Bytes\n", i, len_recv );
						}
					}
				}else
					if( len_recv == 0 ) /* closed */
					{
						printf("PIpe closed %d\n", i);
						close(pipes[i][0]);
						pipes[i][0] = -1;
					}else
						if( len_recv == -1 )
						{
							printf("Recv error %d", i);
						}


			}
		}

		// wait for child processes's termination
		pid_t	pid = waitpid(-1, NULL, WNOHANG);
		//if(waitpid(-1, NULL, WNOHANG) == -1)
		if( pid == -1 )
		{
			printf( "[%s:%d] ERROR??? waitpid() : %d, errno: %d( %s )\n", __func__, __LINE__, pid, errno, strerror( errno ) );
			return;
		}
		else if( pid != 0 )
		{
			printf( "[%s:%d] waitpid() : %d\n", __func__, __LINE__, pid );
		}
	}

}

/*--------------------------------------*
 *          TCP Child Process           *
 *                                      *
 *   @ TCP Connection Accept            *
 *                                      *
 *  @ Read from a TCP session           *
 *  @ Send message to Parent Process    *
 *--------------------------------------*/
void 
TCP_Process(int sd, int idx, int p[2]){

	int    sd_client;
	int    len_recv;
	char   buffer[MSG_SIZE];       // small buffer

	socklen_t                  len_saddr;
	struct sockaddr_storage    saddr_c;

	int fullCount = 0;

	size_t	totalSend = 0;
	size_t	totalRecv = 0;

	int isRunning = 1;

	close(p[PIPE_READ]);
	p[PIPE_READ] = -1;

	while( isRunning > 0 )
	{

		printf("[%d] Waiting accept \n", idx);

		len_saddr    = sizeof(saddr_c);
		sd_client    = accept(sd, (struct sockaddr *)&saddr_c, &len_saddr);

		if(sd_client == -1){
			printf("[Child %d] Faild: accept()\n", idx);
			close(sd_client);
			continue;
		}

		if(saddr_c.ss_family == AF_INET){
			printf("[Child %d] accept (ip:port) (%s:%d)\n\n", idx
					, inet_ntoa( ((struct sockaddr_in*)&saddr_c)->sin_addr)
					, ntohs( ((struct sockaddr_in*)&saddr_c)->sin_port) );

		}

		while(1) {

			memset(buffer, 0x00, sizeof(buffer));   // clear Buffer 

			len_recv = recv(sd_client, buffer, sizeof(buffer), 0);
			if(len_recv == -1){ // Error
				printf("[Child %d] Failed: recv()\n", idx);
				break;
			}
			if(len_recv == 0){ // Connection closed
				printf("[Child %d] Session closed\n", idx);
				close(sd_client);
				//isRunning = 0;
				break;
			}

			totalRecv += len_recv;

			if( len_recv < MSG_SIZE )
			{
				//printf("[Child %d] RECV[%d]\n%s\n", idx, len_recv, buffer);
				//fullCount = 0;
				if( ( ++fullCount % 1000 ) == 0 )
				{
					printf("[Child idx:%d ] fullCount: %d, RECV[%d] totalSend: %ld kBytes totalRecv: %ld kBytes\n", \
							idx, fullCount, len_recv, totalSend >> 10, totalRecv >> 10 );
				}
			}
			else
			{
				if( ( ++fullCount % 1000 ) == 0 )
				{
					printf("[Child idx:%d ] fullCount: %d, RECV[%d] totalSend: %ld kBytes totalRecv: %ld kBytes\n", \
							idx, fullCount, len_recv, totalSend >> 10, totalRecv >> 10 );
				}
			}

			// write data to pipe for parent process
			write(p[1], buffer, len_recv);

			if(send(sd_client, buffer, len_recv, 0) == -1){
				printf("[Child %d] Fail : send() to socket(%d)", idx, sd_client);
				close(sd_client);
			}
			totalSend += len_recv;

			//sleep(1);

		} // packet recv loop

	}
	printf("[Child idx:%d: pid: %d ] fullCount: %d, RECV[%d] totalSend: %ld kBytes totalRecv: %ld kBytes\n", \
			idx, getpid(), fullCount, len_recv, totalSend >> 10, totalRecv >> 10 );

	printf("===============close\n");
}

int 
TCP_SocketOption(int sd){

	int sockopt = 1;

	if( setsockopt(sd, SOL_SOCKET, SO_REUSEADDR,
				&sockopt, sizeof(sockopt)) == -1){
		printf("[TCP Server] Fail : Re-USE setsockopt() Option\n");
		return -1;
	}

	sockopt = 1;
	if( setsockopt(sd, SOL_SOCKET, SO_KEEPALIVE,
				&sockopt, sizeof(sockopt)) == -1){
		printf("[TCP Server] Fail : KEEP ALIVE setsockopt()\n");
		return -1;
	}

	sockopt=65535;

	if( setsockopt(sd, SOL_SOCKET, SO_RCVBUF,
				&sockopt, sizeof(sockopt)) == -1){
		printf("[TCP Server] Fail : setsockoptt() Option\n");
		return -1;
	}

	return 0;
}

	int 
SetFDBlock(int sd, int isBlock)
{
	int flags;

	flags = fcntl(sd, F_GETFL, 0);
	if(isBlock == OFF)
		return fcntl(sd, F_SETFL, flags | O_NONBLOCK);
	else
		return fcntl(sd, F_SETFL, flags & (~O_NONBLOCK));
}
