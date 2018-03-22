/*
 * =====================================================================================
 *
 *       Filename:  byteswap.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2011년 07월 05일 14시 12분 33초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. Fritz Mehner (mn), mehner@fh-swf.de
 *        Company:  FH Südwestfalen, Iserlohn
 *
 * =====================================================================================
 */

#include	<stdio.h>

#include    <byteswap.h>

#define		HEX_TO_4218		( 1 )
#define		HEX_FROM_4218	( 2 )

static inline unsigned char nibble_to_4218( unsigned char x )
{
	return ( ( ( x & 0x7 ) << 1 ) | ( ( x & 0x8 ) >> 3 ) );
}

static inline unsigned char nibble_from_4218( unsigned char x )
{
	return ( ( ( x & 0xe ) >> 1 ) | ( ( x & 0x1 ) << 3 ) );
}

static inline unsigned char byte_to_4218( unsigned char x )
{
	return ( ( nibble_to_4218( x >> 4 ) << 4 ) | nibble_to_4218( x ) );
}

static inline unsigned char byte_from_4218( unsigned char x )
{
	return ( ( nibble_from_4218( x >> 4 ) << 4 ) | nibble_from_4218( x ) );
}

static inline unsigned char bswap_8_to_4218( unsigned char x )
{
	return ( nibble_to_4218( x >> 4 ) | ( nibble_to_4218( x ) << 4 ) );
}

static inline unsigned char bswap_8_from_4218( unsigned char x )
{
	return ( nibble_from_4218( x >> 4 ) | ( nibble_from_4218( x ) << 4 ) );
}

static inline unsigned int uint32_from_4218( unsigned int x )
{
	x =	byte_from_4218( (unsigned char)( (x >> 24) & 0xff ) ) << 24	|
		byte_from_4218( (unsigned char)( (x >> 16) & 0xff ) ) << 16	|
		byte_from_4218( (unsigned char)( (x >> 8 ) & 0xff ) ) << 8	|
		byte_from_4218( (unsigned char)( x & 0xff ) );

	return ( x );
}

static inline unsigned int uint32_to_4218( unsigned int x )
{
	x =	byte_to_4218( (unsigned char)( (x >> 24) & 0xff ) ) << 24	|
		byte_to_4218( (unsigned char)( (x >> 16) & 0xff ) ) << 16	|
		byte_to_4218( (unsigned char)( (x >> 8 ) & 0xff ) ) << 8	|
		byte_to_4218( (unsigned char)( x & 0xff ) );

	return ( x );
}


/*
   byte swap functions
*/
#if 0
static inline unsigned char bswap_8( unsigned char x )
{
	return ( ( x >> 4 ) | ( x << 4 ) );
}

static inline unsigned short bswap_16( unsigned short x )
{
	//return ( ( x >> 8 ) | ( x << 8 ) );
	return ( ( bswap_8( x & 0xff ) << 8 ) | ( bswap_8( x >> 8 ) ) );
}

static inline unsigned int bswap_32( unsigned int x )
{
	return ( ( bswap_16( x & 0xffff ) << 16 ) | ( bswap_16( x >> 16 ) ) );
}

static inline unsigned long long bswap_64( unsigned long long x )
{
	return ( ( ( unsigned long long )bswap_32( x & 0xffffffff ) << 32 ) | ( bswap_32( x >> 32 ) ) );
}
#endif

int main( void )
{
	unsigned int	x;
	int		i;

	//for( i = 0x12345678 ; i < 0x12345690 ; i++ )
	for( i = 0x12345678 ; i < 0x123456a0 ; i++ )
	{
		//printf( "i = 0x%08x ==> 0x%08x ==> 0x%08x\n", i, uint32_from_4218( i ), bswap_32( uint32_from_4218( i ) ) );
		//printf( "i = 0x%08x ==> 0x%08x ==> 0x%08x\n\n", i, uint32_to_4218( i ), bswap_32( uint32_to_4218( i ) ) );
		printf( "i = 0x%08x ==> 0x%08x ==> 0x%08x\n", i, uint32_from_4218( i ), bswap_32( i ) );
		printf( "i = 0x%08x ==> 0x%08x ==> 0x%08x\n\n", i, uint32_from_4218( i ), bswap_32( bswap_32( i ) ) );
	}

	return 0;
}

