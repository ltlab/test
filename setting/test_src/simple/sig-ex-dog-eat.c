/* Shyoo 
 * signaling example.
 * 2002. 11. 3.
 */

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <stdlib.h>
#include <sched.h>

int pid;
int ate;
void do_timer(int signo);
void eat_fin(int signo);
void wait_for_eat();
void stat(int signo);

int main(int argc, char * argv[])
{
	pid = fork();
	if (pid == 0) {
		wait_for_eat();
		for (;;) sched_yield();
	} else {
		//parent
		(void) signal(SIGALRM, do_timer);
		(void) signal(SIGUSR1, eat_fin);
		(void) signal(SIGINT,  stat);
	
		struct itimerval set;
		struct itimerval otv;
	
		set.it_interval.tv_sec = 2;
		set.it_interval.tv_usec = 0;
		set.it_value.tv_sec = 1;
		set.it_value.tv_usec = 0;
		setitimer(ITIMER_REAL, &set, &otv);
	
		for (;;) sched_yield();
	}
}

void ate_all()
{
	signal(SIGALRM, ate_all);
	printf("I ate all\n");
	kill(getppid(), SIGUSR1);
}

void wait_for_eat()
{
	signal(SIGUSR1, wait_for_eat);
	signal(SIGALRM, ate_all);
	printf("umm~~~umm~~umm~\n");
	alarm(1);
}

void do_timer(int signo)
{
	signal(SIGALRM, do_timer);
	printf("Time to give meal!!\n");
	kill(pid, SIGUSR1);
	return;
}

void eat_fin(int signo)
{
	signal(SIGUSR1, eat_fin);
	ate++;
	return;
}

void stat(int signo)
{
	printf("ate %d\n", ate);
	ate = 0;
}
