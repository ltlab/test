#include    <stdio.h>

#define	EXP	( 1E+6 )

typedef struct
{
    unsigned char   a;
    union
    {
        struct
        {
            unsigned short  flag_1      :8;
            unsigned short  flag_2      :4;
            unsigned char   flag_3      :8;
            unsigned char   flag_4      :4;
        } flag;
        unsigned int   cal;
    } caled;
} TEST;

int main( void )
{
    TEST    test;

    test.a = 0xAF;
    test.caled.cal = 0x12345678;
    //test.caled.flag_H = 0xB;
    //test.caled.flag_L = 0xD;

    printf(" sizeof(test) = %d, sizeof(test.caled) = %d\n", sizeof( TEST ), sizeof( test.caled ) );
    printf(" test.a = 0x%x( %#x ), test.caled = 0x%x( %#x )\n",  \
            test.a, &test.a, test.caled, &test.caled );
    printf(" test.caled.cal = 0x%x( %#x ), test.caled.flag = 0x%x( %#x )\n",  \
            test.caled.cal, &test.caled.cal, test.caled.flag, &test.caled.flag );
    printf(" test.caled.flag.flag_1 = 0x%x( %#x ), test.caled.flag.flag_2 = 0x%x\n",  \
            test.caled.flag.flag_1, &test.caled.flag, test.caled.flag.flag_2 );
    printf(" test.caled.flag.flag_3 = 0x%x( %#x ), test.caled.flag.flag_4 = 0x%x\n",  \
            test.caled.flag.flag_3, &test.caled.flag, test.caled.flag.flag_4 );

	printf( "10E6 = %d\n", (int)EXP );
    return 0;

}
