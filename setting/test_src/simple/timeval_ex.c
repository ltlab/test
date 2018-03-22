#include <stdio.h>
#include <sys/types.h>

int main()
{

	struct timeval t_start, t_end;	//select timeout
	long time_diff, sec, ms;
	int i, j;

	gettimeofday(&t_start, NULL);	//타이머 시작
	for (i = 0; i<65535; i++)
		for (j=0; j<10000; j++);

	gettimeofday(&t_end, NULL);	//타이머 종료
	
	time_diff = (1000000*(t_end.tv_sec - t_start.tv_sec)) + (t_end.tv_usec - t_start.tv_usec);
	sec = time_diff / 1000000;
	ms = (time_diff % 1000000) / 1000;

	printf("수행시간 : %ld sec %3ld ms\n", sec, ms);
	return 0;
}
