
#include <stdio.h>
#include <time.h>

void main()
{
	int i,j;
	clock_t t1,t2;
	int count=0;

	t1=clock();

	for (i = 0 ; i < 65536 ; i ++)
		for (j = 0 ; j < 50 ; j ++)
			;
	
	t2 = clock();
	
/*
	for (;;) {
	//	printf("기다리십시오. %d\n",count++);
		t2=clock();
		if (t2-t1 > 1*CLOCKS_PER_SEC) {
			break;
		}
	}
	
*/
	printf ("CLOCKS_PER_SEC = %ld\n" , CLOCKS_PER_SEC);
	printf("t1 = %ld , t2 = %ld , t2-t1 = %ld\n" , t1 , t2 , t2-t1);
	printf("끝났습니다.\n");
}
