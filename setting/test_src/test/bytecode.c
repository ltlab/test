/*
 * =====================================================================================
 *
 *       Filename:  hello.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  08/20/2010 12:50:22 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Huh Jae-Yeong (), < jaeyeong.huh@dongbu.com elechole@gmail.com >
 *        Company:  Dongbu Hitek Semiconductor Business
 *
 * =====================================================================================
 */

#include	<stdio.h>

int main( void )
{
	unsigned int x = 0x12345678;
	unsigned int *pInt = &x;
	unsigned short *pShort = (unsigned short *)( &x );
	unsigned char *pChar = (unsigned char *)( &x );

	printf( "int x = 0x%X @ 0x%p\n", x, &x );
	printf( "pInt = 0x%X @ 0x%p\n", *pInt, pInt );
	printf( "pShort = 0x%X, @ 0x%p\n", *pShort, pShort );
	printf( "pShort + 1 = 0x%X, @ 0x%p\n", *(pShort + 1), (pShort + 1) );
	printf( "pChar = 0x%X, @ 0x%p\n", *pChar, pChar );
	printf( "pChar + 1 = 0x%X, @ 0x%p\n", *(pChar + 1), (pChar + 1) );
	printf( "pChar + 2 = 0x%X, @ 0x%p\n", *(pChar + 2), (pChar + 2) );
	printf( "pChar + 3 = 0x%X, @ 0x%p\n", *(pChar + 3), (pChar + 3) );
	return 0;
}

