#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include	<time.h>

int periodToSec( const char *period );

int main()
{
	//strptime( "P1Y3M27DT17H5M50S", "P%YY%mM%dDT%HH%MM%SS", &tm );

	char str_y[ 64 ] = "P1999Y3M27DT17H5M50S";
	char str_month[ 64 ] = "P3M27DT17H5M50S";
	char str_day[ 64 ] = "P27DT17H5M50S";
	char str_h[64] = "pt16h04m12s";
	char str_m[64] = "pt04m12s";
	char str_s[64] = "PT14S";

	//periodToSec( str_y );
	//periodToSec( str_month );
	periodToSec( str_day );
	periodToSec( str_h );
	periodToSec( str_m );
	periodToSec( str_s );

	return 0;
}

#define MIN_IN_SECS		( 60 )
#define	HOUR_IN_SECS	( 60 * MIN_IN_SECS )
#define	DAY_IN_SECS		( 24 * HOUR_IN_SECS )

int periodToSec( const char *period )
{
	struct tm tm;

	/*	TODO: Seperate Sting by "T"	*/
	char *pTmpPeriod = strdup( period );
	const char *pszDurationFormat[] = {
			//"P%YY%mM%dDT%HH%MM%SS",
			//"P%mM%dDT%HH%MM%SS",
			"P%dDT%HH%MM%SS",
			"PT%HH%MM%SS",
			"PT%MM%SS",
			"PT%SS" };

	//const char *pszDelims[] = { "Y", "M", "D","H", "M", "S" };	//	delims for Hour, Minute, Second
	//const char *pszDelims[] = { "H", "M", "S" };	//	delims for Hour, Minute, Second
	const char *pszDelims[] = { "D", "H", "M", "S" };	//	delims for Hour, Minute, Second
	char *pTmp;
	int i = 0;
	long periodSec = 0;

	while( pTmpPeriod[ i ] != '\0' )
	{
		pTmpPeriod[ i ] = toupper( pTmpPeriod[ i ] );
		i++;
	}
	char *pTmpUpperPeriod = strdup( pTmpPeriod );


	memset( &tm, 0, sizeof( struct tm ) );

	for( i = 0 ; i < ( sizeof( pszDelims ) / sizeof( char * ) ) ; i ++ )
	//for( i = 0 ; i < 4 ; i ++ )
	{
		char *pTmpDateStr =	NULL;
		char *pTmpTimeStr =	NULL;

		pTmpTimeStr = strpbrk( pTmpPeriod, "D" );

		printf( "delim[ %s ] str( %s %p ) => date( %s ) time( %s %p )\n", "D", \
				pTmpPeriod, pTmpPeriod, pTmpDateStr, pTmpTimeStr, pTmpTimeStr );

		pTmp = pTmpPeriod;
		strsep( &pTmp, pszDelims[ i ] );

		/*	delim has been found	*/
		if( pTmp != NULL )
		{
			//strptime( period, pszDurationFormat[ i ], &tm );
			strptime( pTmpUpperPeriod, pszDurationFormat[ i ], &tm );
			periodSec = ( tm.tm_mday * DAY_IN_SECS ) + ( tm.tm_hour * HOUR_IN_SECS ) + ( tm.tm_min * MIN_IN_SECS ) + tm.tm_sec;

			break;
		}
	}
	printf( "size: %d period( \"%s\" => \"%s\") => Hour: %d Min: %d Sec: %d ==> %d secs\n", sizeof( pszDelims ) / sizeof( char * ), \
			period, pTmpUpperPeriod, tm.tm_hour, tm.tm_min, tm.tm_sec, periodSec );

	free( pTmpPeriod );
	free( pTmpUpperPeriod );

	char buf[ 128 ];
	strftime( buf, sizeof( buf ), "%Y %m %d %H:%M:%S", &tm );
	puts( buf );

	return periodSec;
}

