#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>
#include "err.h"

#include	<sys/syscall.h>

#ifdef SYS_gettid
pid_t	gettid()
{
	return syscall( SYS_gettid );
}
#else
#endif

#define NR_THREADS	3
#define SLEEP_TIME	3

int ile = 0;

void *watek (void *data) 
{
	int ret = *( int * )data;
	pid_t pid = getpid();
	pid_t tid = gettid();

	ile++; /* Odwolanie do zmiennej dzielonej ktore moze prowadzic do bledow ! */
	printf ("START: Thread No: %d. PID: %d, TID: %d\n", ret, pid, tid);

	sleep( SLEEP_TIME );

	printf ("END: Thread No: %d. PID: %d, TID: %d\n", ret, pid, tid);

	//return (void *) ile;
	return (void *) ret;
}

int main (int argc, char *argv[])
{
	pthread_t th[NR_THREADS];
	pthread_attr_t attr;
	int i, wynik;
	int blad;
	pid_t pid = getpid();

	printf("Process pid: %d\n", pid);

	if ((blad = pthread_attr_init(&attr)) != 0 )
		syserr(blad, "attrinit");

	if ((blad = pthread_attr_setdetachstate(&attr, 
					argc > 1 ? PTHREAD_CREATE_DETACHED : PTHREAD_CREATE_JOINABLE)) != 0)
		syserr(blad, "setdetach");

	for (i = 0; i < NR_THREADS; i++)
		if ((blad = pthread_create(&th[i], &attr, watek, ( void * )&i )) != 0)
			syserr(blad, "create");

	if (argc > 1) {
		sleep( SLEEP_TIME );
		printf("KONIEC\n");
	} else { 
		printf ("Process pid: %d Before join\n", pid);
		for (i = 0; i < NR_THREADS; i++) {
			if ((blad = pthread_join(th[i], (void **) &wynik)) != 0)
				syserr(blad, "join");
			printf("return value: %d\n", wynik);
		}
	}

	if ((blad = pthread_attr_destroy (&attr)) != 0)
		syserr(blad, "attrdestroy");
	return 0;
}
