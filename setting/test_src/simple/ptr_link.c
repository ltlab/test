
#include <stdio.h>

void unused_func( void );

int main()
{
	unsigned int	a, i;
	unsigned int	*pA, *pB, *pC;	//	Pointer Test

	int unused_var;

	printf("a = (%p) \n", &a );
	printf("pA = (%p), %p \n", pA, &pA );
	printf("pB = (%p), %p \n", pB, &pB );
	printf("pC = (%p), %p \n", pC, &pC );
	
	pA = &a;
	pB = pA;
	pC = pB;
	//a();
	for( i = 0 ; i < 5 ; i++ )
	{
		a = i;
		printf("==================================================\n");
		printf("a = %d(%p) \n", a, &a );
		printf("pA = %d(%p), %p \n", *pA, pA, &pA );
		printf("pB = %d(%p), %p \n", *pB, pB, &pB );
		printf("pC = %d(%p), %p \n", *pC, pC, &pC );
	}
	return 0;
}
#if 1
void unused_func( void )
{
	return;
}
#endif

