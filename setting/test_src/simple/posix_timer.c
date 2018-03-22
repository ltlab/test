#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <netinet/in.h>
#include <linux/socket.h>
#include <time.h>


#define SIGTIMER (SIGRTMAX)
#define SIG SIGUSR1
static timer_t     tid;
static timer_t     tid2;

void SignalHandler(int, siginfo_t*, void* );
timer_t SetTimer(int, int, int);

int main(int argc, char *argv[]) {


    struct sigaction sigact;
    sigemptyset(&sigact.sa_mask);
    sigact.sa_flags = SA_SIGINFO;
    sigact.sa_sigaction = SignalHandler;
    // set up sigaction to catch signal
    if (sigaction(SIGTIMER, &sigact, NULL) == -1) {
        perror("sigaction failed");
        exit( EXIT_FAILURE );
    }

    // Establish a handler to catch CTRL+c and use it for exiting.
    sigaction(SIGINT, &sigact, NULL);
    tid=SetTimer(SIGTIMER, 1000, 1);

    struct sigaction sa;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = SignalHandler;
    // set up sigaction to catch signal
    if (sigaction(SIG, &sa, NULL) == -1) {
        perror("sa failed");
        exit( EXIT_FAILURE );
    }

    // Establish a handler to catch CTRL+c and use it for exiting.
    sigaction(SIGINT, &sa, NULL);
    tid2=SetTimer(SIG, 500, 1);
    for(;;);
    return 0;
}

void SignalHandler(int signo, siginfo_t* info, void* context)
{
    if (signo == SIGTIMER) {
        printf("Command Caller has ticked\n");

    }else if (signo == SIG) {
        printf("Data Caller has ticked\n");

    } else if (signo == SIGINT) {
        timer_delete(tid);
        perror("Crtl+c cached!");
        exit(1);  // exit if CRTL/C is issued
    }
}
timer_t SetTimer(int signo, int sec, int mode)
{
    static struct sigevent sigev;
    static timer_t tid;
    static struct itimerspec itval;
    static struct itimerspec oitval;

    // Create the POSIX timer to generate signo
    sigev.sigev_notify = SIGEV_SIGNAL;
    sigev.sigev_signo = signo;
    sigev.sigev_value.sival_ptr = &tid;

    if (timer_create(CLOCK_REALTIME, &sigev, &tid) == 0) {
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
        perror("timer_create error!");
        return NULL;
    }
    return tid;
}
