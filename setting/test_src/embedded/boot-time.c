// Purpose of this utility is to timestamp each line coming over stdin
// USAGES:
//    tstamp.exe < /dev/ttyS0
//    <commands> | tstamp.exe
// 

#include	<stdio.h>
#include	<string.h>
#include	<sys/time.h>
#include	<sys/types.h>
#include	<fcntl.h>
#include	<termios.h>
#include	<unistd.h>

#undef		_TIME_DEBUG_
#undef		_DEBUG_

#ifdef _DEBUG_
#define debug(fmt, args...)		\
	do {	\
		printf("[%s:%d] %s(): "fmt, __FILE__, __LINE__, __func__, ##args);	\
	} while(0)
#else
#define debug(fmt, args...)
#endif

#define		TEST(x)		(!!(x))

#define		BAUDRATE		B115200
#define		MODEMDEVICE		"/dev/ttyS0"

#define		FALSE	0
#define		TRUE	1

typedef	struct timeval	TIMEVAL;

static inline TIMEVAL GetTime()
{
	TIMEVAL	tv;

	gettimeofday( &tv, NULL );
	//return( (float)( tv.tv_sec + tv.tv_usec / 1000000.0 ) );
	return( tv );
}

static inline int ElapsedTime( TIMEVAL *pNow, TIMEVAL *pPrev )
{
#ifdef	_TIME_DEBUG_
	printf( " prev_sec = %ld, prev_usec = %ld\n", \
			(long)pPrev->tv_sec, (long)pPrev->tv_usec );
	printf( " now_sec = %ld, now_usec = %ld\n", \
			(long)pNow->tv_sec, (long)pNow->tv_usec );
#endif	/*	_DEBUG_	*/
	if( pNow->tv_sec < pPrev->tv_sec )
	{
		printf( "ERROR: time_prev > time_now\n" );
		return( -1 );
	}

	if( pNow->tv_usec < pPrev->tv_usec )
	{
		pNow->tv_sec--;
		pNow->tv_usec = 1e6 - pPrev->tv_usec + pNow->tv_usec;
	}
	else
		pNow->tv_usec -= pPrev->tv_usec;
	pNow->tv_sec -= pPrev->tv_sec;

	return( 0 );
}

int main(int argc, char* argv[])
{
	int first = 1;
	TIMEVAL time, time_start, time_dt, time_now;
	char buf[255] = { 0x00 };
	int	fd, length;
	struct	termios	oldtio, newtio;

	fd = open( MODEMDEVICE, O_RDWR | O_NOCTTY );
	if( fd < 0 )
	{
		fprintf( stderr, " fd open Error\n" );
		return ( -1 );
	}
	debug( "fd = 0x%04x\n", fd );

	tcgetattr( fd, &oldtio );			/*	Save current serial port settiongs	*/
	bzero( &newtio, sizeof( newtio ) );	/*	clear struct for new port settings	*/

	newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD | HUPCL;
	//newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
	newtio.c_iflag = IGNCR | IGNPAR;
	//newtio.c_iflag = IGNPAR | ICRNL;
	newtio.c_oflag = 0;
	newtio.c_lflag = ICANON;

	newtio.c_cc[ VTIME ] = 0;
	newtio.c_cc[ VMIN ] = 0;

	tcflush( fd, TCIFLUSH );
	tcsetattr( fd, TCSANOW | TCSAFLUSH, &newtio );

	if(argc!=1) // as of now no arguments are allowed. print usage
	{
		printf("Timestamps each line coming over stdin\n"
				"\tUSAGES:\n"
				"\t\ttstamp.exe < /dev/ttyS0\n"
				"\t\t<commands> | tstamp.exe\n"
				"\t\tetc..\n");
		printf("Output is printed in the following format\n"
				"\tcolumn1 is elapsed time since first message"
				"\tcolumn2 is elapsed time since previous message\n"
				"\tcolumn3 is the message\n");

		close( fd );
		return 0;
	}
	printf("\tcolumn1 is elapsed time since first message\n"
			"\tcolumn2 is elapsed time since previous message\n"
			"\tcolumn3 is the message\n");

	debug( "Start...\n" );
#ifdef	_TIME_DEBUG_
	time = GetTime();
	sleep(1);
	time_dt = GetTime();
	if( ElapsedTime( &time_dt, &time ) < 0 )
	{
		printf( "ERROR: previous time > now\n" );
		return( -1 );
	}
	printf("--- %03ld.%06ld sec\n", (long)time_dt.tv_sec, (long)time_dt.tv_usec );
#endif	/*	_DEBUG_	*/

	while( 1 )
	{

		time = GetTime();

		if( ( length = read( fd, buf, 255 ) ) < 0 )
		{
			fprintf( stderr, "fd read Error\n" );
			return ( -1 );
		}
		if( first ) // if first time, notedown the time_start
		{
			first = 0;
			time = GetTime();
			time_start = time;
		}
		buf[ length - 1 ] = '\0';

#ifdef	_TIME_DEBUG_
		TIMEVAL	dbg_time_prev, dbg_time_now;

		dbg_time_prev = GetTime();
#endif	/*	_DEBUG_	*/

		time_now = GetTime();
		/*	time_dt = time_now - time	*/
		time_dt = time_now;
		if( ElapsedTime( &time_dt, &time ) < 0 )
		{
			printf( "ERROR: previous time > now\n" );
			return( -1 );
		}
		/*	time_now = time_now - time_start	*/
		if( ElapsedTime( &time_now, &time_start ) < 0 )
		{
			printf( "ERROR: previous time > now\n" );
			return( -1 );
		}
		printf( "[ %3ld.%06ld %3ld.%06ld ]: %s\n", \
				(long)time_now.tv_sec, (long)time_now.tv_usec, \
				(long)time_dt.tv_sec, (long)time_dt.tv_usec, buf );

#ifdef	_TIME_DEBUG_
		dbg_time_now = GetTime();
		ElapsedTime( &dbg_time_now, &dbg_time_prev );
		printf("--- %03ld.%06ld sec\n", \
				(long)dbg_time_now.tv_sec, (long)dbg_time_now.tv_usec );
#endif	/*	_DEBUG_	*/
	}
	tcsetattr( fd, TCSANOW | TCSAFLUSH, &oldtio );
	close( fd );

	return 0;
}

