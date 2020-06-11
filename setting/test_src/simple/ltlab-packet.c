#include <stdio.h>
#include <string.h>

//#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>

#include <assert.h>

enum
{
	STX = 0x02,
	ETX = 0x03,
	DLE = 0x10,
};

/*	Packet format
 *	| STX | LID | DID | CMD | DATA_L | DATA_H | CHKSUM | ETX |
 *
 *	Byte index: LSB first
 *	bitfield: LSB first
 *	by jay 2020-05-29 17:30:40	*/
typedef union PACKET_U
{
#define PACKET_INIT 		\
	{						\
		._byte = { 0x0 },	\
	}

	uint8_t		_byte[ 6 ];
	uint16_t	_short[ 3 ];

	struct
	{
		uint8_t loopId;
		uint8_t deviceId;
		uint8_t command;

		union
		{
			uint8_t data[ 2 ];
			uint16_t data_short;

			union
			{
				/*	DEV_STATUS for Detector	*/
				struct
				{
					uint16_t	value	: 10;
					uint16_t	period	: 3;
					uint16_t	type	: 3;
				};
				/*	SCAN LOOP	*/
				struct
				{
					uint8_t		start;
					uint8_t		end;
				};
			};
		} __attribute__ (( packed));
		uint8_t chksum;
	};
} __attribute__ (( packed)) PACKET;

typedef union PACKET_DLE_U
{
/*	MAX_LEN = max DLE inserted condition( LID to DATA_H are all STX, ETX or DLE ) + STX + ETX	*/
#define PACKET_DLE_MAX_LEN	( ( ( sizeof( PACKET ) - 1 ) * 2 ) + 2 )
#define PACKET_DLE_INIT 	\
	{						\
		.len = 0,			\
		.stx = STX,			\
	}

	struct
	{
		uint8_t		len;

		union
		{
			uint8_t		_byte[ PACKET_DLE_MAX_LEN ];
			uint16_t	_short[ PACKET_DLE_MAX_LEN / 2 ];

			struct
			{
				uint8_t		stx;
				uint8_t		data[ PACKET_DLE_MAX_LEN - 1 ];
			};
		};
	};
} __attribute__ (( packed)) PACKET_DLE;

bool generatePacket( PACKET * const pPacket, PACKET_DLE * const pPacket_dle )
{
	uint8_t		sum = 0;
	uint32_t	dle_idx = 0;

	assert( ( pPacket != NULL ) && ( pPacket_dle != NULL ) );

	pPacket_dle->stx = STX;
	dle_idx++;

	/*	DLE Injection	*/
	for( int i = 0 ; i < ( sizeof( PACKET ) - 1 ) ; i++ )
	{
		printf( "%d: 0x%02x => ", i, pPacket->_byte[ i ] );

		switch( pPacket->_byte[ i ] )
		{
			case STX: printf( "STX\t" ); break;
			case ETX: printf( "ETX\t" ); break;
			case DLE: printf( "DLE\t" ); break;
			default: printf( "\t" ); break;
		}
		if( ( pPacket->_byte[ i ] == STX )
				|| ( pPacket->_byte[ i ] == ETX )
				|| ( pPacket->_byte[ i ] == DLE ) )
		{
			pPacket_dle->_byte[ dle_idx ] = DLE;
			printf( "0x%02x ", pPacket_dle->_byte[ dle_idx ] );
			dle_idx++;
		}
		pPacket_dle->_byte[ dle_idx ] = pPacket->_byte[ i ];
		sum += pPacket->_byte[ i ];
		printf( "0x%02x\n", pPacket_dle->_byte[ dle_idx ] );
		dle_idx++;
	}

	/*	Generate checksum	*/
	pPacket->chksum = ~sum + 1;	//	2's complement
	pPacket_dle->_byte[ dle_idx++ ] = pPacket->chksum & 0xFF;

	printf( "DLE Injection: len %d sum: %d 0x%02x\n",
			dle_idx, sum, sum );
	printf( "CHKSUM: chksum( %d ) + sum( %d ) = %d ( 0x%02x )\n",
			pPacket->chksum, sum, pPacket->chksum + sum, ( pPacket->chksum + sum ) & 0xFF );

	/*	Add ETX to tailing	*/
	pPacket_dle->_byte[ dle_idx++ ] = ETX;
	pPacket_dle->len = dle_idx;
	printf( "FINAL: len %d idx %d\n", pPacket_dle->len, dle_idx );

	for( int i = 0 ; i < pPacket_dle->len ; i++ )
	{
		uint8_t *pData = ( pPacket_dle->_byte ) + i;
		printf( "%2d: data: 0x%02x", i, *pData );

		switch( *pData )
		{
			//case STX: printf( " -> STX\n" ); break;
			//case ETX: printf( " -> ETX\n" ); break;
			case DLE: printf( " ==> DLE\n" ); break;
			default: printf( "\n" ); break;
		}
	}
	return true;
}

bool parsePacket( PACKET * const pPacket, PACKET_DLE * const pPacket_dle )
{
	uint8_t *pData = NULL;
	uint8_t		sum = 0;
	uint32_t	idx = 0;
	bool	dle_skiped = false;

	assert( ( pPacket != NULL ) && ( pPacket_dle != NULL ) );
	assert( ( pPacket_dle->stx == STX ) && ( pPacket_dle->len > 0 ) );

	pData = ( pPacket_dle->_byte );
	/*	STX		*/
	if( *pData != STX ) return false;
	if( *( pData + ( pPacket_dle->len - 1 ) ) != ETX ) return false;

	printf( "PARSE Packet!!!!\n " );
	/*	Loop for LID to CHKSUM	*/
	for( int i = 1 ; i < ( pPacket_dle->len - 1 ) ; i++ )
	{
		//pData = ( pPacket_dle->_byte ) + i;
		pData++;
		printf( "%d: data: 0x%02x => ", i, *pData );

		switch( *pData )
		{
			case STX: printf( "STX\t" ); break;
			case ETX: printf( "ETX\t" ); break;
			case DLE: printf( "DLE\t" ); break;
			default: printf( "\t" ); break;
		}
		if( ( *pData == DLE ) && ( dle_skiped == false ) )
		{
			printf( "\n" );
			dle_skiped = true;
			continue;
		}
		pPacket->_byte[ idx ] = *pData;
		sum += *pData;
		printf( "0x%02x\n", pPacket->_byte[ idx ] );
		idx++;
		dle_skiped = false;
	}

	/*	Verify checksum		*/
	if( sum != 0x0 )
	{
		printf( "FAILED >>> CHKSUM: chksum( %d ) + sum( %d ) = %d ( 0x%02x ) is NOT Zero\n",
				pPacket->chksum, sum, pPacket->chksum + sum, ( pPacket->chksum + sum ) & 0xFF );
		return false;
	}

	/*	Verification	*/
	pData = ( pPacket->_byte );
	for( int i = 0 ; i < sizeof( PACKET ) ; i++ )
	{
		printf( "%2d: data: 0x%02x", i, *pData );

		switch( *pData )
		{
			case STX: printf( " -> STX\n" ); break;
			case ETX: printf( " -> ETX\n" ); break;
			case DLE: printf( " ==> DLE\n" ); break;
			default: printf( "\n" ); break;
		}
		pData++;
	}
	return true;
}

int main ()
{
	PACKET		packet = PACKET_INIT, packet_1;
	PACKET_DLE	packet_dle = PACKET_DLE_INIT;

	packet.loopId = 0x02;
	packet.deviceId = 0x01;
	packet.command = 0xC2;
#if 1
	packet.start = 0xC0;
	packet.end = 0x00;
#else
	packet.value = 0x04;
	packet.period = 0x05;
	packet.type = 0x03;
#endif

	generatePacket( &packet, &packet_dle );
	parsePacket( &packet_1, &packet_dle );

	//printf( "SIZE: PACKET %zd PACKET_DLE %zd\n", sizeof( PACKET ), sizeof( PACKET_DLE ) );

	return 0;
}
