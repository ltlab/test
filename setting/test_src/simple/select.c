#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/select.h>
#include	<fcntl.h>
#include	<errno.h>

#define BUF_SIZE 30

int main(int argc, char *argv[])
{
	fd_set reads, temps;
	int result, str_len;
	int fd, value;
	char buf[BUF_SIZE];
	char *pBuf = buf;
	struct timeval timeout;

	fd = fileno( stdin );

	value = fcntl( fd, F_GETFL, 0 );
	printf( "fd(%d) FL: 0x%08x\n", fd, value );
	//value |= O_NONBLOCK;
	//fcntl( fd, F_SETFL, value );
	if( value & O_NONBLOCK )
	{
		printf( "fd(%d) have NON_BLOCK\n", fd );
	}

	/*
	timeout.tv_sec=5;
	timeout.tv_usec=5000;
	*/

#if 1
	str_len = 0;
	while(1)
	{
		FD_ZERO(&reads);
		FD_SET( fd, &reads); // 0 is standard input(console)

		temps=reads;
		timeout.tv_sec=5;
		timeout.tv_usec=0;
		result=select( fd + 1, &temps, 0, 0, &timeout);
		if(result==-1)
		{
			if( errno == EAGAIN )
			{
				printf( "errno(%d) is EAGAIN\n", errno );
				continue;
			}
			printf("select() error!, errno(%d)\n", errno);
			break;
		}
		else if(result==0)
		{
			printf("Time-out!\n");
		}
		else 
		{
			if(FD_ISSET( fd, &temps)) 
			{
				int len;
				len=read( fd, pBuf, BUF_SIZE);
					str_len += len - 1;
				if( str_len < 5 )
				{
					pBuf += len - 1;
					//printf( "buf: %p pBuf: %p str_len: %d\n", buf, pBuf, str_len );
					continue;
				}
				else
				{
					//pBuf -= str_len;
					//printf( "buf: %p pBuf: %p str_len: %d\n", buf, pBuf, str_len );
					buf[ str_len ] = 0;
					printf("message from console: %s\n", buf);
					pBuf = buf;
					str_len = 0;
				}
			}
		}
	}
#endif
	close( fd );
	return 0;
}
