#include <stdio.h>
#include <time.h>    /* defines 'extern long timezone' */
#include	<sys/time.h>	//	timeval, timezone

int main(int argc, char **argv)
{
	time_t lt, gt;
	struct tm tm_gmt;

	struct timeval	tv;
	struct timezone	tz;

	time_t	dstTime = 0;

	tzset();

	lt = time(NULL);

	gettimeofday( &tv, &tz );

	gmtime_r( &lt, &tm_gmt );

	/*	mktime() should be setting DST flag( tm_isdst )		*/
	gt = mktime( &tm_gmt );

	/*	gt is NOT UTC time. Applying DST		*/
	if( tm_gmt.tm_isdst == 1 )
	{
		dstTime = 60 * 60;

		gt += dstTime;
	}

	/*	gt is UTC Time!!!!!!		*/

	printf( "Time now is\t: %s %ld\t isDST: %d\n", ctime( &lt ), lt, tm_gmt.tm_isdst );
	printf( "Time GMT is\t: %s %ld\n", ctime( &gt ), gt );
	printf( "difftime(...) == %.3f, tzname: [ %s, %s ], timezone = %d, daylight: %d, dstTime: %d\n", \
			difftime(gt, lt), tzname[ 0 ], tzname[ 1 ], timezone, daylight, dstTime );

	gt = gt - timezone;

	if( tm_gmt.tm_isdst == 1 )
	{
		gt = gt - dstTime;
	}

	printf( "timezone == %d applied: %s\n", timezone, asctime( localtime( &gt ) ) );

	printf( "tv: %d %d, tz[ minuteswest: %d, dst: %d ]\n", tv.tv_sec, tv.tv_usec, tz.tz_minuteswest, tz.tz_dsttime );

			return 0;
}
