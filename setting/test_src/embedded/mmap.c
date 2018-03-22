/*
 * =====================================================================================
 *
 *       Filename:  mmap.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2010년 03월 02일 14시 20분 27초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. Fritz Mehner (mn), mehner@fh-swf.de
 *        Company:  FH Südwestfalen, Iserlohn
 *
 * =====================================================================================
 */

#include	<unistd.h>		//	open, close
#include	<stdio.h>
#include	<stdlib.h>
#include	<sys/mman.h>	//	mmap PROT_*
#include	<asm/fcntl.h>	//	O_RDWR......

//#define		REG_BASEADDR	0x48318010	//	OMAP GPTIMER1
//#define		REG_BASEADDR	0x00100000	//	OMAP GPTIMER1
#define		REG_BASEADDR	0xC0000000	//	OMAP GPTIMER1

int main( void )
{
	int				mmap_fd;
	unsigned int	*pBaseaddr = NULL;
	int				index;

	if( ( mmap_fd = open( "/dev/mem", O_RDWR | O_SYNC ) ) < 0 )
	{
		printf( "error in /dev/mem open\n" );
		exit( 0 );
	}

	pBaseaddr = mmap(	0,
						4 * 1024,
						PROT_WRITE | PROT_READ,
						MAP_SHARED,
						mmap_fd,
						REG_BASEADDR );

	if( (int)pBaseaddr < 0 )
	{
		close( mmap_fd );
		printf( "mmap error : %d\n", (int)pBaseaddr );
		return (-1);
	}
	//printf(" mmap_fd = 0x%08X\n", mmap_fd );
	//pBaseaddr = &mmap_fd;
	printf( "  Address\t0x00000000\t0x00000004\t0x00000008\t0x0000000C\n" );
	printf( "===========================================================================\n" );
	for( index = 0 ; index < 0x10 ; index++ )
	{
		if( ( index % 0x04 ) == 0 )
			printf( "%p :", pBaseaddr + index );
		printf( "\t%08X", *(pBaseaddr + index) );
		if( ( index % 0x04 ) == 3 )
			printf("\n");

		//printf( "RD: addr(%p) = 0x%08X\n", pBaseaddr + index, *(pBaseaddr + index) );
		//*(pBaseaddr + index) = index;
		//printf( "WR: addr(%p) = 0x%08X\n", pBaseaddr + index, *(pBaseaddr + index) );
	}
	munmap( pBaseaddr, 1 );
	close( mmap_fd );

	return 0;
}
