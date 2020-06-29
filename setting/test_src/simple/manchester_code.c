#include "manchester_code.h"

#include <stdio.h>
#include <string.h>

//#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>

#include <assert.h>

/*	NOTE:
 *	*/
int manchesterEncoder( const uint8_t * const pData, MANCHESTER_DATA * const pEncodedData )
{
	assert( ( pData != NULL ) && ( pEncodedData != NULL ) );

	/*	NOTE:
	 *	*/
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

	MANCHESTER_DEBUG( *pData, *pEncodedData );

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
	MANCHESTER_DEBUG( *pData, *pEncodedData );

	return 0;
}

#ifdef __DEBUG_MANCHESTER_CODE__
void manchesterPrint( const uint8_t data, const MANCHESTER_DATA encodedData )
{
	printf( "[ %s : %d ] 0x%02x => 0x%04x | %02x %02x| ", __func__, __LINE__,
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
