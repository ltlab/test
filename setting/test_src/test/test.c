#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>

int generateString( char **ppStr )
{
	*ppStr = ( char * )malloc( strlen( "Test String" ) );

	if( *ppStr == NULL )
	{
		return -1;
	}

	strcpy( *ppStr, "Test String" );

	return 0;
}

int main( void )
{
	char *pStr = NULL;
	char n1, n2;
	unsigned short s1;

	generateString( & pStr );

	printf( "str: %s\n", pStr );

	if( pStr != NULL )
	{
		free( pStr );
	}

	n1 = 33;
	n2 = 104;
	s1 = ( n1 << 8 ) | ( n2 & 0xFF );

	printf( "n1: %d 0x%02x, n2: %d 0x%02x s1: %d 0x%04x\n", n1, n1, n2, n2, s1, s1 );

	return 0;
}
