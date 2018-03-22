#include    <stdio.h>

#define    TEST_DEFINE  1

#define    TEST_DEFINE  2

void nDigit( unsigned int i, int digit, unsigned char* ret )
{
    if( digit > 1 )
    {
        printf("1) i = %10d, digit = %d\n", i, digit );
        nDigit( i / 10, digit - 1, ret - 1 );
    }
    printf("2) i = %10d, digit = %d\n", i, digit );
    *ret = ( i % 10 );  
}

void fDigit( float i, int digit, unsigned char* ret )
{
    if( digit > 0 )
    {
        printf("11) i = %.4f, digit = %d\n", i, digit );
        fDigit( i * 10, digit - 1, ret + 1 );
    }
    printf("22) i = %.4f, digit = %d\n", i, digit );
    *ret = ((unsigned int)i % 10 );  
}



int main( void )
{
    unsigned int    num = 9584273;
    float           f_num;
    unsigned char   rgucData[ 16 ] = { 0 };
    int             digit;
    int             i;

#if defined( TEST_DEFINE )
    printf( "TEST DEFINE is defined!!!!, %d\n", TEST_DEFINE );
#else
    printf( "TEST DEFINE is NOT defined!!!!\n" );
#endif  /*  TEST_DEFINE */

    printf(" number= %d\n", num );

    digit = 6;
    nDigit( num, digit, (unsigned char *)(rgucData + digit - 1) );

    for( i = 0 ; i < 16 ; i++ )
    {
        printf( "Data[ %d ] = %10d\n", i, rgucData[ i ] );
    }
    f_num = 301.2483234;

    digit = 3;
    printf( " number = %.4f, digit = %d\n", f_num, digit );
    nDigit( (unsigned int)(f_num), digit, (unsigned char *)(rgucData + (digit - 1)) );

    for( i = 0 ; i < 16 ; i++ )
    {
        printf( "Data[ %d ] = %10d\n", i, rgucData[ i ] );
    }

    rgucData[ digit++ ] = 0xFF;
    //digit = 2;
    //fDigit( f_num, 3, rgucData );
    //for( i = 0 ; i < digit ; i++ )
    //    f_num = f_num * 10;
    printf( " number = %.4f, digit = %d\n", f_num * 100, digit );

    //nDigit( (unsigned int)(f_num), digit - 1, (unsigned char *)(rgucData + digit - 1 ) );
    nDigit( (unsigned int)(f_num * 100), 2, (unsigned char *)(rgucData + digit + 1 ) );
    for( i = 0 ; i < 16 ; i++ )
    {
        printf( "Data[ %d ] = %10d\n", i, rgucData[ i ] );
    }
    printf( " %s %s %s %d\n", __DATE__, __FILE__, __FUNCTION__, __LINE__ );
}

