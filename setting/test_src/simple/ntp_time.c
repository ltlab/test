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

#define		BLACK			"\033[0;33m"
#define		RED				"\033[0;31m"
#define		GREEN			"\033[0;32m"
#define		YELLOW			"\033[0;33m"
#define		BLUE			"\033[0;34m"
#define		MAGENTA			"\033[0;35m"
#define		CYAN			"\033[0;36m"
#define		WHITE			"\033[0;37m"

#define		BLACK_BOLD		"\033[1;33m"
#define		RED_BOLD		"\033[1;31m"
#define		GREEN_BOLD		"\033[1;32m"
#define		YELLOW_BOLD		"\033[1;33m"
#define		BLUE_BOLD		"\033[1;34m"
#define		MAGENTA_BOLD	"\033[1;35m"
#define		CYAN_BOLD		"\033[1;36m"
#define		WHITE_BOLD		"\033[1;37m"

#define		ENDCOLOR		"\033[0m"

#include	<stdio.h>
#include	<time.h>	//	CLOCK_REALTIME	-lrt
#include	<sys/time.h>

#define	__DEBUG__

#ifdef	__DEBUG__
	#define	DPRINTF( fmt, args... )	printf( "[%s:%d]: " fmt, __FUNCTION__, __LINE__, ##args )
	#define	SYSPRINTF( fmt, args... ) \
		printf( RED_BOLD"[%s:%5d]:" fmt ENDCOLOR, __FUNCTION__, __LINE__, ##args )
#else
	#define	DPRINTF
	#define	SYSPRINTF( fmt, module, args... )
#endif

#define	ALIGN( align, size )	( ( (size) + (align - 1) ) & ~(align - 1) )

int main( void )
{
	struct timeval tv;
	struct timespec tp;
	unsigned long long int	ntp_time;
	unsigned int ntp_sec, ntp_frac;
	unsigned int unix_sec, unix_usec;
	unsigned long unix_nsec;

	printf( "Content-Type: text/plain;charset=us-en\n\n" );
	printf( "Hello World!!\n" );
	DPRINTF( "OH  %d\n", 90 );
	
	clock_getres( CLOCK_REALTIME, &tp );
	printf( "clock_getres():::: tv.sec: %d nsec: %d\n\n\n", tp.tv_sec, tp.tv_nsec );

	while( 1 )
	{
#if 0
		gettimeofday( &tv, NULL );
		printf( "gettimeofday():::: tv.sec: %d usec: %d\n", tv.tv_sec, tv.tv_usec );

		ntp_sec = tv.tv_sec + 0x83AA7E80;
		ntp_frac = tv.tv_usec * ( 1 << 6 ) * ( ( 1 << 26 ) / 1E6 );
		printf( "ntp:::: sec: %ld frac: %ld\n", ntp_sec, ntp_frac );

		unix_sec = ntp_sec - 0x83AA7E80;
		unix_usec = ntp_frac * ( 1E6 / ( 1 << 6 ) ) / ( ( 1 << 26 ) - 1 );
		printf( "unix time by ntp:::: sec: %ld usec: %ld\n", unix_sec, unix_usec );
		if( ( unix_sec != tv.tv_sec ) || ( unix_usec != tv.tv_usec ) )
		{
			//SYSPRINTF( "ntp_sec( %ld ) != unix_sec( %ld ): diff( %d )\n", \
			//		unix_sec, tv.tv_sec, ( tv.tv_sec - unix_sec ) );
			SYSPRINTF( "ntp_usec( %ld ) != unix_usec( %ld ): diff( %d )\n", \
					unix_usec, tv.tv_usec, ( tv.tv_usec - unix_usec ) );
		}
#else
		clock_gettime( CLOCK_REALTIME, &tp );
		printf( "clock_gettime():::: tv.sec: %d nsec: %d\n", tp.tv_sec, tp.tv_nsec );

		ntp_sec = tp.tv_sec + 0x83AA7E80;
		ntp_frac = tp.tv_nsec * ( 1 << 2 ) * ( ( 1 << 30 ) / 1E9 );
		printf( "ntp:::: sec: %ld frac: %ld\n", ntp_sec, ntp_frac );

		unix_sec = ntp_sec - 0x83AA7E80;
		unix_nsec = ntp_frac * ( 1E9 / ( 1 << 2 ) ) / ( ( 1 << 30 ) - 1 );
		printf( "unix time by ntp:::: sec: %ld nsec: %ld\n", unix_sec, unix_nsec );
		if( ( unix_sec != tp.tv_sec ) || ( unix_nsec != tp.tv_nsec ) )
		{
			//SYSPRINTF( "ntp_sec( %ld ) != unix_sec( %ld ): diff( %d )\n", \
			//		unix_sec, tv.tv_sec, ( tv.tv_sec - unix_sec ) );
			SYSPRINTF( "ntp_nsec( %ld ) != unix_nsec( %ld ): diff( %d )\n", \
					unix_nsec, tp.tv_nsec, ( tp.tv_nsec - unix_nsec ) );
		}
#endif
		usleep( 300 * 1000 );
	}

	return 0;
}

