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
 *	Byte index: LSB first
 *	bitfield: LSB first
 *	LT_PACKET: between CCU and DEVICE.
 *	| DID | CMD | DATA_L | DATA_H | CHKSUM |
 *	|<----- LT_PACKET_BODY ------>|
 *
 * PACKET: between MB and CCU.
 *	| STX | LID | DID | CMD | DATA_L | DATA_H | CHKSUM | ETX |
 *	            |<----- LT_PACKET_BODY ------>|
 *	by jay 2020-05-29 17:30:40	*/

typedef uint8_t Command;

typedef struct LT_PACKET_BODY_S {
  uint8_t device_id;
  Command command;

  union {
    uint8_t _byte[2];
    uint16_t _short;

    //uint16_t seq;  //	for Test
    struct {
      uint8_t mode;
      uint8_t reserved;
    } master;
    /*	DEV_STATUS for Detector	*/
    struct {
      uint16_t value : 10;
      uint16_t period : 3;
      uint16_t type : 3;
    } detector_status;
    /*	DEV_STATUS for Repeater */
    struct {
      uint16_t input : 4;
      uint16_t output : 4;
      uint16_t disconnect : 4;
      uint16_t reserved : 1;
      uint16_t type : 3;
    } repeater_status;
    /*  ACK */
    struct {
      uint8_t command;
      uint8_t reserved;
    } ack;
    /*	SCAN LOOP	*/
    struct {
      uint8_t start;
      uint8_t end;
    } loop;
    // VERSION version;
  } __attribute__((packed));
  uint16_t seq;  //	for Test
} __attribute__((packed)) LT_PACKET_BODY;

typedef struct LT_PACKET_S
{
	LT_PACKET_BODY	body;
	uint8_t			chksum;
} __attribute__ (( packed)) LT_PACKET;

/*	PACKET: between Manboard and CCU	*/
typedef union PACKET_U
{
#define PACKET_INIT 		\
	{						\
		._byte = { 0x0, },	\
	}

	uint8_t		_byte[ sizeof( LT_PACKET_BODY ) + 2 ];
	uint16_t	_short[ ( sizeof( LT_PACKET_BODY ) + 2 ) / sizeof( uint16_t ) ];

	struct
	{
		uint8_t			loopId;
		LT_PACKET_BODY	body;
		uint8_t			chksum;
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

	printf( "START--------------\n" );

	pPacket_dle->stx = STX;
	dle_idx++;

	/*	DLE Injection	*/
	for( int i = 0 ; i < ( sizeof( PACKET ) - 1 ) ; i++ )
	{
		printf( "%d: 0x%02x => ", i, pPacket->_byte[ i ] );

		switch( pPacket->_byte[ i ] )
		{
			case STX: printf( "STX in packet\t" ); break;
			case ETX: printf( "ETX in packet\t" ); break;
			case DLE: printf( "DLE in packet\t" ); break;
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
		printf( "0x%02x sum: %d %x\n", pPacket_dle->_byte[ dle_idx ], sum, sum );
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
	printf( "\nFINAL: len %d idx %d\n\n", pPacket_dle->len, dle_idx );

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
	printf( "END --------------\n" );
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
		printf( "%2d: data: 0x%02x => ", i, *pData );

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
			case STX: printf( " -> STX in packet\n" ); break;
			case ETX: printf( " -> ETX in packet\n" ); break;
			case DLE: printf( " -> DLE in packet\n" ); break;
			default: printf( "\n" ); break;
		}
		pData++;
	}
	printf( "END --------------\n" );
	return true;
}

int main ()
{
	PACKET		packet = PACKET_INIT, packet_1;
	PACKET_DLE	packet_dle = PACKET_DLE_INIT;

	packet.loopId = 0x02;
	packet.body.device_id = 0x10;
	packet.body.command = 0x03;
#if 0
	packet.body.loop.start = 0xC0;
	packet.body.loop.end = 0x00;
#else
	packet.body.detector_status.value = 0x04;
	packet.body.detector_status.period = 0x05;
	packet.body.detector_status.type = 0x03;
#endif

	for( uint16_t seq = 0xFF0A ; seq < 0xFF10 ; seq++ )
	{
		packet.body.seq = seq;
		generatePacket( &packet, &packet_dle );
		parsePacket( &packet_1, &packet_dle );

    printf("seq: 0x%04x v 0x%02x p 0x%02x t 0x%02x\n", packet.body.seq,
        packet.body.detector_status.value,
        packet.body.detector_status.period,
        packet.body.detector_status.type );
	}

	//printf( "SIZE: PACKET %zd PACKET_DLE %zd\n", sizeof( PACKET ), sizeof( PACKET_DLE ) );

	return 0;
}
