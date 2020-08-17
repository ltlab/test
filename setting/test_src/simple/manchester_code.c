#include "manchester_code.h"

#include <stdio.h>
#include <string.h>

//#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>

#include <assert.h>

MANCHESTER_DATA manchesterEncoderChar( const uint8_t data )
{
	MANCHESTER_DATA	encodedData = { .data_short = 0x0 };

	for( int bitIdx = 7 ; bitIdx >= 0 ; bitIdx-- )
	{
		encodedData.data_short <<= 2;
		if( ( ( data >> bitIdx ) & 0x1 ) == 0x1 )
		{
			encodedData.data_short |= MANCHESTER_ONE;
		}
		else
		{
			encodedData.data_short |= MANCHESTER_ZERO;
		}
	}

	MANCHESTER_DEBUG( data, encodedData );

	return encodedData;
}

uint8_t manchesterDecoderChar( const MANCHESTER_DATA encodedData )
{
	uint8_t data = 0x0;

	for( int bitIdx = 7 ; bitIdx >= 0 ; bitIdx-- )
	{
		data <<= 1;
		if( ( ( encodedData.data_short >> ( bitIdx << 1 ) ) & 0b11 ) == MANCHESTER_ONE )
		{
			data |= 0b1;
		}
	}
	MANCHESTER_DEBUG( data, encodedData );

	return data;
}

size_t manchesterEncoderString( const uint8_t * const pData, MANCHESTER_DATA * const pEncodedData, const size_t len )
{
	for( size_t i = 0 ; i < len ; i++ )
	{
		pEncodedData[ i ] = manchesterEncoderChar( pData[ i ] );
	}
	return len;
}

size_t manchesterDecoderString( uint8_t * const pData, const MANCHESTER_DATA * const pEncodedData, const size_t len )
{
	for( size_t i = 0 ; i < len ; i++ )
	{
		pData[ i ] = manchesterDecoderChar( pEncodedData[ i ] );
	}
	return len;
}

#ifdef __DEBUG_MANCHESTER_CODE__
void manchesterPrint( const uint8_t data, const MANCHESTER_DATA encodedData )
{
	printf( "[ %s : %d ] 0x%02x <=> 0x%04x | %02x %02x| ", __func__, __LINE__,
			data, encodedData.data_short, encodedData.data[ 1 ], encodedData.data[ 0 ] );
	for( int bitIdx = 15 ; bitIdx >= 0 ; bitIdx-- )
	{
		printf( "%d", ( encodedData.data_short >> bitIdx ) & 0b1 );
		if( ( bitIdx % 4 ) == 0 ) printf( "  " );
	}
	printf( "\n" );

	return ;
}
#endif	//	__DEBUG_MANCHESTER_CODE__

#define TEST_LEN	(16)

int main ()
{
	uint8_t data[ TEST_LEN ] = { 0x0 };
	MANCHESTER_DATA	encodedData[ TEST_LEN ];

	printf( "========= Character Test\n" );
	for( int i = 0x0 ; i < TEST_LEN ; i++ )
	{
		uint8_t data = i;
		MANCHESTER_DATA	encodedData = { .data_short = 0x0 };

		encodedData = manchesterEncoderChar( data );
		data = manchesterDecoderChar( encodedData );
	}

	printf( "========= String Test\n" );
	for( int i = 0 ; i < TEST_LEN ; i++ )
	{
		data[ i ] = i;
		encodedData[ i ].data_short = 0x0;
	}

	printf( "=========Encoding\n" );
	manchesterEncoderString( data, encodedData, TEST_LEN );
	memset( data, 0x55, TEST_LEN );
	printf( "=========Decoding\n" );
	manchesterDecoderString( data, encodedData, TEST_LEN );

	return 0;
}
