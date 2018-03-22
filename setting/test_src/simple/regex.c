#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>
#include <regex.h>

#define MATCH_SIZE 100

int main(int argc, char *argv[])
{

	int ret;
	char pattern[128], str[128];

	int cflags = REG_EXTENDED;
	regex_t reg;

	if (argc != 3) {
		printf("Usage: %s regexp string\n", argv[0]);
		exit(1);
	}

	strcpy(pattern, argv[1]);
	strcpy(str, argv[2]);

	printf("regexp(%s),string(%s)\n", pattern, str);

	// reg compile
	ret = regcomp(&reg, pattern, cflags);
	if (ret != 0) {
		char errStr[128];
		regerror(ret, &reg, errStr, sizeof(errStr));
		printf("regcomp error(%s)\n", errStr);
		exit(1);
	}

	int eflags = 0, len;
	int offset = 0, cnt = 1;

	// pattern matching
	regmatch_t pmatch[ MATCH_SIZE ];
#if 1
//./regex "P([0-9]+Y)?([0-9]+M)?([0-9]+D)?T([0-9]+H)?([0-9]+M)?([0-9]+S)?" P2095Y2M31DT12H34M56S
	ret = regexec(&reg, str, MATCH_SIZE, &pmatch, eflags);
	if( ret == 0 )
	{
		int i;
		printf( "Match OK!!! str( %s ) pattern( %s )\n", str, pattern );

		for( i = 0 ; i < MATCH_SIZE ; i++ )
		{
			char matchStr[ 128 ] = {0x0, };

			if( pmatch[ i ].rm_so == -1 )
			{
				puts( "STOP!!!!\n" );
				break;
			}
			len = pmatch[ i ].rm_eo - pmatch[ i ].rm_so;
			strcpy( matchStr, str );
			matchStr[ pmatch[ i ].rm_eo ] = 0;
			//printf("matched string( %d: len %d ) \"%.*s\" offset: %d\n", i, len, pmatch[ i ].rm_so, pmatch[ i ].rm_eo );
			printf( "[ %d ] start: %d end: %d len: %d \"%s\" num: %d\n", i, pmatch[ i ].rm_so, pmatch[ i ].rm_eo, len, \
					matchStr + pmatch[ i ].rm_so, atoi( matchStr + pmatch[ i ].rm_so ) );
		}
	}
	else if( ret == REG_NOMATCH )
	{
		printf( "No Match str( %s ) pattern( %s )\n", str, pattern );
	}
	else
	{
		char msgBuf[ 256 ];
		regerror( ret, &reg, msgBuf, sizeof( msgBuf ) );
		fprintf( stderr, "regex match failed: %s\n", msgBuf );
	}
#else
	while( (ret = regexec(&reg, str+offset, MATCH_SIZE, &pmatch, eflags)) == 0)
	{
		len = pmatch[ cnt ].rm_eo - pmatch[ cnt ].rm_so;

		printf("matched string(%d:%.*s)\n",	cnt, len, str+offset+pmatch[ cnt ].rm_so);

		offset += pmatch[ cnt ].rm_eo;
		cnt++;
	}
#endif
	regfree(&reg);

	return 0;
}
