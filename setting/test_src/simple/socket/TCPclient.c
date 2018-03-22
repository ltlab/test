#include "smart.h"

#define RCVBUFSIZE 	4096

void My_Memset(void *, unsigned char, unsigned int);
void My_Bzero(void *, unsigned int);

int main(int argc, char *argv[])
{
	int sock;
	struct sockaddr_in echoServAddr;
	char *servIP;
	char cBuff[RCVBUFSIZE];
	int iRet;
	fd_set fs_status;

	int portNum, timeout;

	unsigned long	totalSend = 0;
	unsigned long	totalRecv= 0;
	
	if( argc < 3 )
	{
		printf("Usage\n");
		printf("%s [ SERVER IP ] [ PORT NUMBER ] [ Timeout ]\n", argv[0]);   
		return -1;
	}
	else
	{
		servIP = argv[1];
		portNum = atoi( ( char* )argv[2] );
		if( argc > 3 )
		{
			timeout = atoi( ( char* )argv[3] );
		}
	}

	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(0 > sock)
	{
		printf("socket() failed\n");
		
		return 0;
	}

	My_Bzero(&echoServAddr, sizeof(echoServAddr));
	echoServAddr.sin_family = AF_INET;
	echoServAddr.sin_addr.s_addr = inet_addr(servIP);
	echoServAddr.sin_port = htons( portNum );

	iRet = connect(sock, (struct sockaddr *)&echoServAddr, sizeof(echoServAddr));
	if(0 > iRet)
	{
		close(sock);
		printf("connect() failed\n");

		return 0;
	}
	struct timeval timer; /* select timer */
	int timeoutCount = 0;
		
	while(1)
	{
		FD_ZERO(&fs_status);
		//FD_SET(0, &fs_status);
		FD_SET(sock, &fs_status);

		memset( cBuff, 0x0, RCVBUFSIZE );

		timer.tv_sec  = timeout / 1000;
		timer.tv_usec = ( timeout % 1000 ) * 1000;

		iRet = select(sock+1, &fs_status, 0, 0, &timer);
		if(0 > iRet)
		{
			write(sock, LOGOUT, sizeof(LOGOUT));
			perror("select() failed\n");

			break;
		}
		else if( iRet == 0 )	//	Timeout
		{
			memset( cBuff, ( rand() % 0xFF ), RCVBUFSIZE );
			write( sock, cBuff, RCVBUFSIZE );

			totalSend += RCVBUFSIZE;
			timeoutCount++;
		}
		else
		{
			if(1 == FD_ISSET(0, &fs_status))
			{
				timeoutCount = 0;

				iRet = read(0, cBuff, RCVBUFSIZE);
				if(CLTEND == cBuff[0])
				{
					write(sock, LOGOUT, sizeof(LOGOUT));
					printf("Log out\n");

					break;	
				}
				write(sock, cBuff, iRet);
				totalSend += iRet;

			}
		}

		if(1 == FD_ISSET(sock, &fs_status))
		{
			iRet = read(sock, cBuff, RCVBUFSIZE);
			if(1 > iRet)
			{
				printf("Server Down 1\n");
				break;	
			}
			if(0 == strcmp(ENDMSG, cBuff))
			{
				printf("Server Down 2\n");
				break;	
			}
			//printf("[Server: ");
			//fflush(stdout);
			//write(1, cBuff, iRet-1);
			//printf("]\n");

			totalRecv += iRet;
			if( iRet < RCVBUFSIZE )
			{
				//printf("[Server: %d: %s ]\n", iRet, cBuff );
				if( ( timeout * timeoutCount ) % 10000 == 0 )
				{
					printf("pid: %d | 1. Timeout: %d count: %d [Server: %d Bytes ] Total( Send: %ld kBytes, Recv %ld kBytes\n", \
							getpid(), timeout, timeoutCount, iRet, totalSend >> 10, totalRecv >> 10 );
				}
			}
			else
			{
				if( ( timeout * timeoutCount ) % 10000 == 0 )
				{
					printf("pid: %d | 2. Timeout: %d count: %d [Server: %d Bytes ] Total( Send: %ld kBytes, Recv %ld kBytes\n", \
							getpid(), timeout, timeoutCount, iRet, totalSend >> 10, totalRecv >> 10 );
				}
			}
		}
	}
	close(sock);
	return 0;
}

void My_Memset(void *vp, unsigned char ucPad, unsigned int uiSize)
{
	while(0 != uiSize)
	{
		*(unsigned char *)vp = ucPad;
		--uiSize;
		vp = (unsigned char *)vp + 1;
	}
	return;
}

void My_Bzero(void *vp, unsigned int uiSize)
{
	My_Memset(vp, 0x00, uiSize);
	return;
}

