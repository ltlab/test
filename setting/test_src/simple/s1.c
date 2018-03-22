#include <signal.h>
#include <unistd.h>
#include <linux/errno.h>
#include <sys/types.h>
#include <sys/time.h>
#include <stdio.h>



void give_meal(int signo);
void eating(int signo);
void ate_all(int signo);
void cleanup(int signo);
void child_sleep(int signo);

pid_t pid;
int count;
int eat_time;

int main(void)
{

	pid = fork();

	if(pid) //parent
	{
		signal(SIGALRM, give_meal);
		signal(SIGUSR2, cleanup);
//		signal(SIGUSR1, give_meal);
//		printf("parent \n");
//		kill(pid,SIGUSR1);	

		struct itimerval set;
		struct itimerval otv;
	
		set.it_interval.tv_sec = 3;
		set.it_interval.tv_usec = 0;
		set.it_value.tv_sec = 1;
		set.it_value.tv_usec = 0;
		setitimer(ITIMER_REAL, &set, &otv);

		for(;;) sched_yield();

	}
	else //child
	{
		printf("child created\n\n");
//		kill(getppid(),SIGUSR1);
		signal(SIGUSR1, eating);
		signal(SIGUSR2, child_sleep);
		for(;;) sched_yield();	
	}
	exit(0);
	
}

void give_meal(int signo)
{
	if(eat_time<2)
	{
		printf("give meal\n");
		kill(pid,SIGUSR1);
		eat_time++;
		printf("eat_time = %d\n",eat_time);
	}
	else
	{
	 	eat_time=0;
		kill(pid,SIGUSR2);
		printf("child go to sleep\n");
	}
}

void eating(int signo)
{
	printf("eating %d times\n",count);
	signal(SIGALRM, ate_all);
	alarm(1);
}

void ate_all(int signo)
{
	++count;
	printf("ate all\n");
	kill(getppid(), SIGUSR2);
}

void cleanup(int signo)
{
	printf("clean up\n");
	printf("\n");
	
}

void child_sleep(int signo)
{
	printf("child sleeping\n");
	printf("\n");
	sleep(1);
	printf("child wake up\n");
	kill(getppid(), SIGALRM);
	
}
