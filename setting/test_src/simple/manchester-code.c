#include <stdio.h>
#include <string.h>

//#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>

#include <assert.h>

typedef union MANCHESTER_DATA_U
{
#define MANCHESTER_ZERO		( 0b10 )
#define MANCHESTER_ONE		( 0b01 )
	uint8_t data[ 2 ];
	uint16_t data_short;
} MANCHESTER_DATA;

int manchesterEncoder( const uint8_t * const pData, MANCHESTER_DATA * const pEncodedData )
{
	assert( ( pData != NULL ) && ( pEncodedData != NULL ) );

	pEncodedData->data_short = 0x0;
	for( int bitIdx = 7 ; bitIdx >= 0 ; bitIdx-- )
	{
		pEncodedData->data_short <<= 2;
		if( ( ( *pData >> bitIdx ) & 0x1 ) == 0x1 )
		{
			pEncodedData->data_short |= MANCHESTER_ONE;
		}
		else
		{
			pEncodedData->data_short |= MANCHESTER_ZERO;
		}
	}

	printf( "[ %s : %d ] 0x%02x => 0x%04x | %02x %02x| ", __func__, __LINE__,
			*pData, pEncodedData->data_short, pEncodedData->data[ 1 ], pEncodedData->data[ 0 ] );
	for( int bitIdx = 15 ; bitIdx >= 0 ; bitIdx-- )
	{
		printf( "%d", ( pEncodedData->data_short >> bitIdx ) & 0b1 );
		if( ( bitIdx % 4 ) == 0 ) printf( "  " );
	}
	printf( "\n" );

	return 0;
}

int manchesterDecoder( uint8_t * const pData, const MANCHESTER_DATA * const pEncodedData )
{
	assert( ( pData != NULL ) && ( pEncodedData != NULL ) );

	*pData = 0x0;
	for( int bitIdx = 7 ; bitIdx >= 0 ; bitIdx-- )
	{
		*pData <<= 1;
		if( ( ( pEncodedData->data_short >> ( bitIdx << 1 ) ) & 0b11 ) == MANCHESTER_ONE )
		{
			*pData |= 0b1;
		}
	}
	printf( "[ %s : %d ] 0x%02x <<= 0x%04x\n\n", __func__, __LINE__, *pData, pEncodedData->data_short );

	return 0;
}

int main ()
{
	MANCHESTER_DATA	encodedData = { .data_short = 0x0 };

	for( uint8_t i = 0x0 ; i < 0x10 ; i++ )
	{
		uint8_t data = i;
		manchesterEncoder( &data, &encodedData );
		manchesterDecoder( &data, &encodedData );
	}

	return 0;
}
