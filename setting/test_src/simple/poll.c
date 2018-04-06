#include <stdio.h>
#include <unistd.h>
#include <sys/poll.h>

#include	<string.h>

#define TIMEOUT 5

int main (void)
{
	struct pollfd fds[2];
	int ret, i;

	char	buf[ 512 ] = { 0x0, };
	int		len = 0;
	int		end = 0;

	/* watch stdin for input */
	fds[0].fd = STDIN_FILENO;
	fds[0].events = POLLIN;

	/* watch stdout for ability to write */
	//fds[1].fd = STDOUT_FILENO;
	//fds[1].events = POLLOUT;

	while( end == 0 )
	{
		ret = poll(fds, 1, TIMEOUT * 1000);
		printf( "poll: ret: %d\n", ret );

		if (ret == -1) {
			perror ("poll");
			return 1;
		}
		else if (!ret) {
			printf ("%d seconds elapsed.\n", TIMEOUT);
			continue;
		}

		for( i = 0 ; i < ret ; i++ )
		{
			if (fds[0].revents & POLLIN)
			{
				printf ("[ %d ] stdin is readable\n", i );
				printf( "poll: ret: %d events: %08x revents: 0x%08x\n", ret, fds[ 0 ].events, fds[ 0 ].revents );
				len = read( fds[ 0 ].fd, buf, 512 );
				printf( "len: %d STDIN: %s", len, buf );

				len = write( STDOUT_FILENO, buf, strlen( buf ));
				printf( "len: %d STDOUT: %s", len, buf );

				if( strncmp( buf, "exit", 4 ) == 0 )
				{
					end = 1;
					break;
				}
				printf( "strcmp: %x\n", strncmp( buf, "exit", 4 ) );
				memset( buf, 0x0, sizeof( buf ) );
			}
			else if (fds[1].revents & POLLOUT)
			{
				printf ("[ %d ] stdout is writable\n", i );
				printf( "poll: ret: %d events: %08x revents: 0x%08x\n", ret, fds[ 1 ].events, fds[ 1 ].revents );
				len = write( fds[ 0 ].fd, buf, 512 );
				printf( "len: %d STDOUT: %s", len, buf );
			}
		}
		//usleep( 10 * 1000 );
	}

	return 0;

}

