#include <stdio.h>
//#include <stdint.h>
#include <inttypes.h>

const int MAX_GROUP = 8;

//	Req + Response
const int Trr = 20;
const int Tslot = 1000 / 32;
//const int Tslot = 30;

int main ()
{
#if 1
	uint32_t int32 = 0x87654321;

	for( int i =0 ; i < sizeof( uint32_t ) ; i++ )
	{
		uint8_t int8 = ( int32 >> ( i << 3 ) ) & 0xFF;
		uint8_t *pInt8 = ( uint8_t * )( &int32 ) + i;
		printf( "%d: 0x%08X => 0x%2x ptr 0x%02x\n", i, int32 & ( 0xFF << ( i << 3 ) ), int8, *pInt8 );
	}
	return 0;
#endif
	uint32_t period, id, gid;

	period = 8000;

	for( gid = 0 ; gid < MAX_GROUP ; gid++ )
	{
		uint32_t init_delay = 0;

		for( id = gid ; id < 256 ; id += MAX_GROUP )
		{
			uint32_t delta = period -( id * Trr );
			init_delay = id * Trr;
			printf( " [%2d] gid %2d id: %3d period: %d delta: %d 1st: %d\n",
					id / MAX_GROUP, gid, id, period, delta,
					delta + init_delay + ( gid * 1000 ) + ( ( id / MAX_GROUP ) * Tslot ) );
		}
	}

	return 0;
}
