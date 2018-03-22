/*
 * =====================================================================================
 *
 *       Filename:  arping.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014년 11월 03일 15시 45분 21초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include	<stdio.h>
#include	<stdlib.h>

#include	<string.h>
#include	<errno.h>

int main( void )
{
	int res = system( "arping -w 2 -D -s 0.0.0.0 -I eth0 192.168.10.232" );

	printf( "==================================\n" );

	if( res < 0 )
	{
		printf( "system() failed with errno( %d: %s )\n", errno, strerror( errno ) );
	}
	else
	{
		printf( "system(): %d with status: %d\n\n", res, WEXITSTATUS( res ) );
		printf( "WIFEXITED: %d WEXITSTATUS: %d\n", WIFEXITED( res ), WEXITSTATUS( res ) );
		printf( "WIFSIGNALED: %d WTERMSIG: %d\n", WIFSIGNALED( res ), WTERMSIG( res ) );
		printf( "WIFSTOPPED: %d WSTOPSIG: %d\n", WIFSTOPPED( res ), WSTOPSIG( res ) );
	}

	return 0;
}

