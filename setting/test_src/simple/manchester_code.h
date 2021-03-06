#ifndef _MANCHESTER_CODE_HPP_
#define _MANCHESTER_CODE_HPP_

#ifdef __cplusplus
 extern "C" {
#endif

#include <stdio.h>	//	size_t

//#include <stdint.h>
#include <inttypes.h>

#define MANCHESTER_ZERO		( 0b10 )
#define MANCHESTER_ONE		( 0b01 )

#define __DEBUG_MANCHESTER_CODE__

typedef union MANCHESTER_DATA_U
{
	uint8_t data[ 2 ];
	uint16_t data_short;
} MANCHESTER_DATA;

MANCHESTER_DATA manchesterEncoderChar( const uint8_t data );
uint8_t manchesterDecoderChar( const MANCHESTER_DATA encodedData );

size_t manchesterEncoderString( const uint8_t * const pData, MANCHESTER_DATA * const pEncodedData, const size_t len );
size_t manchesterDecoderString( uint8_t * const pData, const MANCHESTER_DATA * const pEncodedData, const size_t len );

#ifdef __DEBUG_MANCHESTER_CODE__

void manchesterPrint( const uint8_t data, const MANCHESTER_DATA encodedData );
#define MANCHESTER_DEBUG( fmt, args... )		\
     manchesterPrint( fmt, args )
     //printf( "[%16s:%4d P(%5d) T(%5d)]:|%16s|\t"fmt, __FUNCTION__, __LINE__, getpid(), gettid(), GetName().c_str(), ##args )
#else	//	__DEBUG_MANCHESTER_CODE__
#define MANCHESTER_DEBUG( fmt, args... )
#endif	//	__DEBUG_MANCHESTER_CODE__


#ifdef __cplusplus
}
#endif
#endif /* ifndef _MANCHESTER_CODE_HPP_ */
