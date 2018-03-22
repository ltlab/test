/*
 * =====================================================================================
 *
 *       Filename:  exp-golomb.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2016년 05월 20일 18시 49분 51초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include	<stdio.h>
#include	<stdint.h>

#include	<iostream>
#include	<bitset>

//using namespace std;

#define	__DEBUG_GET_UE__

int32_t H264_GET_SE( uint8_t  * bitstream, uint32_t  offset );
uint32_t H264_GET_UE( uint8_t  * bitstream, uint32_t  offset );

int main( void )
{
	//	1 010 011 00100 00101 00110 00111 0001000 0001001 0001010
	char	strStream[ 1024 ] = "1 010 011 00100 00101 00110 00111 0001000 0001001 0001010";
	uint8_t	bitstream[ 256 ] = { 0x0, };
	int32_t offset = 0;

	int byteOffset = 0;
	int bitLeft = 8;

	for( int idx = 0 ; strStream[ idx ] != '\0' ; idx++ )
	{
		if( strStream[ idx ] == ' ' ) continue;

		bitLeft--;

		bitstream[ byteOffset ] <<= 1;
		if( strStream[ idx ] == '1' )
		{
			bitstream[ byteOffset ] |= 0x01;
		}

		printf( "idx: %d %c | bitLeft: %d bitstream[ %d ]: 0x%02x\n", \
				idx, strStream[ idx ], bitLeft, byteOffset, bitstream[ byteOffset ] );
		if( bitLeft == 0 )
		{
			printf( "---------------------------------------------------------------------------\n" );
			byteOffset++;
			bitLeft = 8;
		}
	}

	offset = 0;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset++;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 3;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 3;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 5;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 5;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 5;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 5;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 7;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 7;

	H264_GET_UE( bitstream, offset );
	H264_GET_SE( bitstream, offset );
	offset += 7;

	return 0;
}

int32_t H264_GET_SE( uint8_t  * bitstream, uint32_t  offset )
{
	int32_t		value;
	uint32_t	codeNum = H264_GET_UE( bitstream, offset );

	if( codeNum & 0x01 )
	{
		value = ( codeNum + 1 ) >> 1;
	}
	else
	{
		value = -( codeNum >> 1 );
	}

	printf( "UE: %d( 0x%x ) SE: %d( 0x%x )\n", codeNum, codeNum, value, value );

	return value;
}

uint32_t H264_GET_UE( uint8_t  * bitstream, uint32_t  offset )
{
	int leadingZeroBits = -1;
	int bitValue;
	int byteOffset = offset >> 3;
	int bitLeft = 8 - ( offset & 0x07 );

#ifdef	__DEBUG_GET_UE__
	uint64_t	streamBits = 0x0;

	printf( "offset: %d byteOffset: %d bitLeft: %d\n", offset, byteOffset, bitLeft );
	printf( "================================================================================\n" );
#endif	//	__DEBUG_GET_UE__

	/*	Find first '1'	*/
	//for( bitValue = 0 ; bitValue != 0 ; leadingZeroBits++ )
	do
	{
		leadingZeroBits++;
		bitLeft--;

		bitValue = ( bitstream[ byteOffset ] >> bitLeft ) & 0x01;

#ifdef	__DEBUG_GET_UE__
		streamBits <<= 1;
		streamBits |= ( bitValue & 0x01 );

		printf( "leadingZeroBits: %d | byteOffset: %d bitLeft: %d bitValue: %d streamBits: 0x%16llx\n", \
				leadingZeroBits, byteOffset, bitLeft, bitValue, streamBits );
#endif	//	__DEBUG_GET_UE__

		if( bitLeft == 0 )
		{
			printf( "---------------------------------------------------------------------------\n" );
			byteOffset++;
			bitLeft = 8;
		}
	} while( bitValue == 0 );

	/*	get value for codeNum	*/
	uint32_t tailingValue = 0x0;
	for( int left = leadingZeroBits ; left > 0 ; left-- )
	{
		bitLeft--;

		bitValue = ( bitstream[ byteOffset ] >> bitLeft ) & 0x01;

		tailingValue <<= 1;
		tailingValue |= ( bitValue & 0x01 );

		printf( "left: %d | byteOffset: %d bitLeft: %d bitValue: %d tailingValue: 0x%16llx\n", \
				left, byteOffset, bitLeft, bitValue, tailingValue );

		if( bitLeft == 0 )
		{
			printf( "---------------------------------------------------------------------------\n" );
			byteOffset++;
			bitLeft = 8;
		}
	}

	uint32_t codeNum = ( 1 << leadingZeroBits ) - 1 + tailingValue;

#ifdef	__DEBUG_GET_UE__
	streamBits <<= leadingZeroBits;
	streamBits |= tailingValue;

	std::bitset< 16 > tmpBits( streamBits );

	std::cout
		<< "[ " << __func__ << " : " << __LINE__ << " ] "
		<< " streamBits: " << std::hex << streamBits << std::dec
		<< " " << tmpBits
		<< " leadingZeroBits: " << leadingZeroBits
		<< " tailingValue: " << std::hex << tailingValue << std::dec
		<< " codeNum: " << codeNum
		<< std::endl;

	printf( "FINAL: streamBits: 0x%16llx leadingZeroBits: %d tailingValue: 0x%08x codeNum: %d( 0x%08x )\n\n\n",
			streamBits, leadingZeroBits, tailingValue, codeNum, codeNum );
#endif	//	__DEBUG_GET_UE__

	return codeNum;
}
