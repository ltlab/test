/*
 * =====================================================================================
 *
 *       Filename:  getaddrinfo.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2015년 08월 12일 10시 22분 13초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include	<stdio.h>
#include	<netdb.h>
#include	<netinet/in.h>

int hostname_to_ip( char *hostname , char *ip );

int main( int argc, char **argv )
{
	hostname_to_ip( argv[ 1 ], NULL );
}


int hostname_to_ip( char *hostname , char *ip )
{
	struct addrinfo hints, *servinfo, *p;
	struct sockaddr_in *h;
	int rv;

	memset( &hints, 0x0, sizeof( hints ) );

	hints.ai_family = AF_UNSPEC; // use AF_INET6 to force IPv6
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags |= AI_CANONNAME;

	//if( (rv = getaddrinfo( hostname , "http" , &hints , &servinfo)) != 0) 
	if( ( rv = getaddrinfo( hostname, NULL, &hints, &servinfo ) ) != 0 )
	{
		fprintf( stderr, "getaddrinfo: %s\n", gai_strerror( rv ) );
		return -1;
	}

	char	addr[ 128 ] = { 0x0, };
	void	*pAddrInfo = NULL;

	// loop through all the results and connect to the first we can
	for( p = servinfo; p != NULL ; p = p->ai_next ) 
	{
		//inet_ntop( p->ai_family, p->ai_addr->sa_data, addr, 128 );

		switch( p->ai_family )
		{
			case	AF_INET:
				pAddrInfo = &( ( struct sockaddr_in * )p->ai_addr )->sin_addr;
				break;
			case	AF_INET6:
				pAddrInfo = &( ( struct sockaddr_in6 * )p->ai_addr )->sin6_addr;
				break;
		}
		inet_ntop( p->ai_family, pAddrInfo, addr, 128 );

		printf( "getaddrinfo() %p: IPv%d canonname: %s addr: %s\n", \
				p, ( p->ai_family == PF_INET6 ? 6 : 4 ), p->ai_canonname, addr );

		//h = (struct sockaddr_in *) p->ai_addr;
		//strcpy(ip , inet_ntoa( h->sin_addr ) );
	}

	freeaddrinfo( servinfo ); // all done with this structure
	return 0;
}


