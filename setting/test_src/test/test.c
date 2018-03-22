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

	generateString( & pStr );

	printf( "str: %s\n", pStr );

	if( pStr != NULL )
	{
		free( pStr );
	}
	return 0;
}
