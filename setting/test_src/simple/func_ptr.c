#include	<stdio.h>

typedef		void	(*pvFunc) (char *);

pvFunc	pFunc1(char *str)
{
	printf( " pFunc1... str = %s\n", str );
}

pvFunc	pFunc2(char *str)
{
	printf( " pFunc2... str = %s\n", str );
}

int main()
{
	pvFunc	pF;
	short	*ptr;
	long int	var = -0x12345678;

	pF = (pvFunc)pFunc1;

	pF("Fitst");
	printf( "&pF = %p, pF = %p\n", &pF, pF );
	printf( "&pFunc1 = %p, pFunc1 = %p\n", &pFunc1, pFunc1 );
	printf( "&pFunc2 = %p, pFunc2 = %p\n", &pFunc2, pFunc2 );

	pF = (pvFunc)pFunc2;
	pF("Second");
	printf( "&pF = %p, pF = %p\n", &pF, pF );
	printf( "&pFunc1 = %p, pFunc1 = %p\n", &pFunc1, pFunc1 );
	printf( "&pFunc2 = %p, pFunc2 = %p\n\n", &pFunc2, pFunc2 );

	printf("sizeof(char) = %d\n", sizeof(char)); 
	printf("sizeof(short) = %d\n", sizeof(short)); 
	printf("sizeof(int) = %d\n", sizeof(int)); 
	printf("sizeof(long) = %d\n", sizeof(long));
	printf("sizeof(long int) = %d\n", sizeof(long int));
	printf("sizeof(long long int) = %d\n", sizeof(long long int));
	printf("sizeof(float) = %d\n", sizeof(float));
	printf("sizeof(double) = %d\n", sizeof(double));
	printf("sizeof(long double) = %2d\n", sizeof(long double));

	ptr = (short *)(&var);
	printf(" &var = %p, var = %d(0x%08X)\n", &var, var, var );
	printf(" ptr = %p, *ptr = %d(0x%08X), ptr+1 = %p, *ptr+1 = %d(0x%08X)\n", ptr, *ptr, *ptr, ptr+1, *(ptr+1), *(ptr+1) );
	*ptr = (*(ptr+1) + 0x08)>>4;
	*(ptr+1) = 0;
	printf(" &var = %p, var = %d(0x%08X)\n", &var, var, var );
	printf(" ptr = %p, *ptr = %d(0x%08X), ptr+1 = %p, *ptr+1 = %d(0x%08X)\n", ptr, *ptr, *ptr, ptr+1, *(ptr+1), *(ptr+1) );
	signed long test = -2380000;
	signed short *ptr_test;
	unsigned short sh=100;
	ptr_test = (signed short *)(&test);
	printf("signed data = %ld(0x%08X), unsigned = %d(0x%08X)\n", test,test, sh,sh );
	printf("ptr_test = %p, *ptr_test = %d(0x%08x)\n", ptr_test, *ptr_test, *ptr_test );
	printf("signed data = %ld(0x%08X), unsigned = %d(0x%08X)\n", test,test, sh,sh );
	ptr_test++;
	printf("ptr_test = %p, *ptr_test = %d(0x%08x)\n", ptr_test, *ptr_test, *ptr_test );
	*ptr_test = (signed short)( (*ptr_test + 8) >> 4 );
	printf("@@@ptr_test = %p, *ptr_test = %d(0x%08x)\n", ptr_test, *ptr_test, *ptr_test );
	sh += (signed short)(*ptr_test);
	printf("ptr_test = %p, *ptr_test = %d(0x%08x)\n", ptr_test, *ptr_test, *ptr_test );
	printf("signed data = %ld(0x%08X), unsigned = %d(0x%08X)\n", test,test, sh,sh );

	unsigned int	integer = 0x84218421;
	unsigned short	short_int;

	short_int = (unsigned short)( ( integer >> 15 ) & 0xFFFF );

	printf( " int = 0x%08x, short= 0x%08x, short_int = 0x%08x\n", integer, (unsigned short)( integer >> 15 ), short_int );

	return 0;

}

