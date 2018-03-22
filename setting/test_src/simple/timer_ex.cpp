#include <stdio.h>
#include <time.h>

int main(void) {
	time_t timer1, timer2;
	struct tm *t1, *t2;
	unsigned int i, j;

	timer1 = time(NULL);	//현재 시간을 초 단위로

	t1 = localtime(&timer1);
	
	for(i = 0; i < 65536; i++)
			for(j = 0; j < 65536; j++);

	timer2 = time(NULL);
	t2 = localtime(&timer2);


	printf("timer1 : %d 초\n", timer1);
	printf("timer2 : %d 초\n", timer2);
	printf("지연시간 : %d 초\n\n", timer2 - timer1);

	return 0;
}
	



		
