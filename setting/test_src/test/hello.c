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
#include	<time.h>
//#include	<sys/timeb.h>

#include    <stdarg.h>

#define	__DEBUG__

#ifdef	__DEBUG__
	#define	DPRINTF( fmt, args... )	printf( "[%s:%d]: " fmt, __FUNCTION__, __LINE__, ##args )
	#define	SYSPRINTF( fmt, module, args... ) \
		printf( "[%s:%5d]:" RED_BOLD "[" #module"]" ENDCOLOR fmt, __FUNCTION__, __LINE__, ##args )

	#define	TEST_PRINTF( COL, fmt, args... ) \
		printf( COL "[%s:%5d]: " fmt ENDCOLOR, __FUNCTION__, __LINE__, ##args )
		//traceOut( COL "[%s:%5d]: " fmt ENDCOLOR, __FUNCTION__, __LINE__, ##args )
#else
	#define	DPRINTF
	#define	SYSPRINTF( fmt, module, args... )
	#define	TEST_PRINTF( COL, fmt, args... )
#endif

//void traceOut( const char* COL, const char* fmt, ...)
void traceOut( const char* fmt, ...)
{
    va_list vargs;
    va_start( vargs, fmt );

    vfprintf( stdout, fmt, vargs );

    va_end( vargs );
}

#define	ALIGN( align, size )	( ( (size) + (align - 1) ) & ~(align - 1) )

static int var = 5;

//static const int & s_var = var;

int main( void )
{
	char szBuf[128];
	int i;
	time_t	t;

	time( &t );
	strftime( szBuf, sizeof( szBuf ), "%Y.%m.%d/%k:%M:%S", localtime( &t ) );
	printf( "TIME: %s\n", szBuf );

	printf( "Content-Type: text/plain;charset=us-en\n\n" );
	printf( "Hello World!!\n" );
	DPRINTF( "OH  %d\n", 90 );
	SYSPRINTF( "OH  %d\n", MEM, 88 );

	TEST_PRINTF( YELLOW_BOLD, "%s:  %d\n", "MEM", 88 );
	
	sprintf(szBuf,"echo -e \"d\\nu\\nn\\np\\n1\\n64\\n\\n\\nw\\n\" | fdisk %s", "/dev/sda1");
	printf("\n<<< formatHDD() |%s| >>>\n", szBuf);

	for( i = 0 ; i < 127 ; i++ )
	{
		printf( "ALIGN( 4, %d ) = %d\n", i, ALIGN( 4, i ) );

	}
	unsigned int u32tmp1, u32tmp2;
	int	base, size;

	base = 0x2000;
	size = 0x0;
	for( i = 0 ; i < 200 ; i++ )
	{
		base += 0x01000000;
		size += 0x10000;
		u32tmp1 = base + size;
		u32tmp2 = (unsigned int)base + (unsigned int)size;

		printf( "base( %d, 0x%08x ) size( %d, 0x%08x ) tmp( %d, 0x%08x ) cast( %d, 0x%08x )\n", \
				base, base, size, size, u32tmp1, u32tmp1, u32tmp2, u32tmp2 );

	}
    //printf( "var: %d s_var: %d\n", var, s_var );
    var = 4;
    //printf( "var: %d s_var: %d\n", var, s_var );

	return 0;
}

