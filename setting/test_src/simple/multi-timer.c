#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <netinet/in.h>
#include <linux/socket.h>
#include <time.h>

#include	<errno.h>

#include	<asm/unistd.h>	//	gettid

#define SIGTIMER (SIGRTMAX)
//#define SIGTIMER (SIGUSR2)
#define SIG SIGUSR2

#define	MAX_TID		16


static timer_t     gTid[ MAX_TID ];
//static timer_t     tid2;

void SignalHandler(int, siginfo_t*, void* );
timer_t SetTimer(int, int, int);

int main(int argc, char *argv[]) {

	int i;
	struct sigaction sigact;

	for( i = 0 ; i < MAX_TID ; i++ )
	{
		sigemptyset(&sigact.sa_mask);
		sigaddset( &sigact.sa_mask, SIGTIMER );
		sigact.sa_flags = SA_SIGINFO;
		sigact.sa_flags |= SA_NODEFER;
		sigact.sa_sigaction = SignalHandler;
		// set up sigaction to catch signal
		if (sigaction(SIGTIMER, &sigact, NULL) == -1) {
		//if (sigaction(SIG, &sigact, NULL) == -1) {
			perror("sigaction failed");
			exit( EXIT_FAILURE );
		}
		// Establish a handler to catch CTRL+c and use it for exiting.
	    sigaction(SIGINT, &sigact, NULL);
		//tid=SetTimer(SIGTIMER, 1000, 1);
	    //gTid[ i ] = SetTimer(SIG, 100 * (i+1), 2);
	    gTid[ i ] = SetTimer(SIGTIMER, 1, 2);
		printf( "gTid[ %d ] = %d(%p)\n", i, gTid[ i ], &gTid[ i ] );
	}


#if 0
    struct sigaction sa;
    //sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = SignalHandler;
    // set up sigaction to catch signal
    if (sigaction(SIG, &sa, NULL) == -1) {
        perror("sa failed");
        exit( EXIT_FAILURE );
    }

    // Establish a handler to catch CTRL+c and use it for exiting.
    sigaction(SIGINT, &sa, NULL);
    tid2=SetTimer(SIG, 2000, 1);
#endif
    for(;;);
    return 0;
}

void SignalHandler(int signo, siginfo_t* info, void* context)
{
	static int i = 0;
	static int nested = 0;
	timer_t *pTid = ( timer_t * )(info->si_value.sival_ptr);

	if( nested > 0 )
	{
		printf( "[NESTED] cnt: %d\n", nested );
	}
    if (signo == SIGTIMER) {
		nested++;
		printf("[%d] Data Caller has ticked. pid: %d tid = %d timer_id: %d(%p) nested: %d\n", i++, getpid(), syscall( __NR_gettid ), *pTid, pTid, nested );
	    //printf("Command Caller has ticked. pid: %d tid = %d\n", getpid(), syscall( __NR_gettid ) );
		//
        printf("start sleep: %d\n", *pTid );
		usleep( 2 * 1000 );
        printf("stop sleep: %d\n", *pTid );
		nested--;

    }else if (signo == SIG) {
	    printf("Data Caller has ticked. pid: %d tid = %d\n", getpid(), syscall( __NR_gettid ) );

    } else if (signo == SIGINT) {
		for( i = 0 ; i < MAX_TID ; i++ ) { timer_delete( gTid[ i ] ); }
        perror("Crtl+c cached!");
	    printf("Data Caller has ticked. pid: %d tid = %d\n", getpid(), syscall( __NR_gettid ) );
        exit(1);  // exit if CRTL/C is issued
    }
}

//void timer_thread( void* arg )
void timer_thread( sigval_t sigval )
{
	static int i = 0;
	timer_t *pTid = ( timer_t * )sigval.sival_ptr;
    printf("[%d] Data Caller has ticked. pid: %d tid = %d timer_id: %d(%p)\n", i++, getpid(), syscall( __NR_gettid ), *pTid, pTid );

}
void (*pfn_thread)( sigval_t sigval );

timer_t SetTimer(int signo, int sec, int mode)
{
	static int i = 0;
    static struct sigevent sigev;
    static timer_t tid;
    static struct itimerspec itval;
    static struct itimerspec oitval;

//	pfn_thread = &timer_thread;
    // Create the POSIX timer to generate signo
#if 0
    sigev.sigev_notify = SIGEV_THREAD;
	sigev.sigev_notify_function = timer_thread;
	sigev.sigev_notify_attributes = NULL;
    sigev.sigev_value.sival_ptr = &gTid[ i++ ];
#else
    sigev.sigev_notify = SIGEV_SIGNAL;
    sigev.sigev_signo = signo;
    //sigev.sigev_value.sival_ptr = &tid;
    sigev.sigev_value.sival_ptr = &gTid[ i++ ];
#endif

    int res =timer_create(CLOCK_REALTIME, &sigev, &tid );
    //if (timer_create(CLOCK_REALTIME, &sigev, &tid) == 0) {
    if ( res == 0) {
        itval.it_value.tv_sec = sec / 1000;
        itval.it_value.tv_nsec = (long)(sec % 1000) * (1000000L);

        if (mode == 1) {
            itval.it_interval.tv_sec = itval.it_value.tv_sec;
            itval.it_interval.tv_nsec = itval.it_value.tv_nsec;
        }
        else {
            itval.it_interval.tv_sec = 0;
            itval.it_interval.tv_nsec = 0;
        }

        if (timer_settime(tid, 0, &itval, &oitval) != 0) {
            perror("time_settime error!");
        }
    }
    else {
		printf( "res: %d errno: %d\n", res, errno );
        perror("timer_create error!");
        return NULL;
    }
    return tid;
}
