#include	"Thread.hpp"

#include	<stdio.h>
#include	<time.h>
#include	<sys/prctl.h>

extern "C" int gettid(void)
{
	return ( int )syscall( __NR_gettid );
}

using namespace CTRing;

Thread::Thread( const std::string name, const int priority )
: m_id( 0 ), m_status( STATUS_STOPPED ), m_name( name ), m_priority( priority ), m_isRunning( false )
{
	pthread_mutex_init( & m_mutex, NULL );
	pthread_cond_init( & m_cond, NULL );
}

Thread::~Thread()
{
	pthread_mutex_destroy( & m_mutex );
	pthread_cond_destroy( & m_cond );
}
void Thread::SetThreadName( void )
{
	int ret = prctl( PR_SET_NAME, (unsigned long)( GetName().c_str() ) );
	if(ret < 0) {
		THREAD_PRINTF( "ERROR - %s(0x%08x)\n", strerror(errno), errno);
	} else {
		char pBuf[ 16 ] = { 0x0, };
		prctl( PR_GET_NAME, (unsigned long)pBuf );
		THREAD_PRINTF( "SET_NAME: %s\n", pBuf);
	}
	return ;
}

bool Thread::Start()
{
	THREAD_PRINTF( "START priority: %d\n", m_priority );

	int  policy, prev_policy;
	struct sched_param schedParam, prev_schedParam;

	pthread_getschedparam( pthread_self(), &prev_policy, &prev_schedParam );

	policy = SCHED_OTHER;
	schedParam.sched_priority = 0;

	pthread_setschedparam( pthread_self(), policy, &schedParam );
	if( pthread_create( & m_id, NULL, Run, this ) != 0 )
	{
		return false;
	}
	m_isRunning = true;
	m_status = STATUS_RUNNING;

	pthread_setschedparam( pthread_self(), prev_policy, &prev_schedParam );

	return true;
}

void *Thread::Run( void * pArg )
{
	Thread	*pThread = reinterpret_cast< Thread * >( pArg );

	pThread->SetThreadName();

	pthread_exit( ( void * )( pThread->ThreadFunc( pArg ) ) );

	return NULL;
}

bool Thread::Stop()
{
	THREAD_PRINTF( "STOP priority: %d\n", m_priority );

	m_isRunning = false;

	Lock();
	Signal();
	Unlock();

	return true;
}

bool Thread::Join( void * pRetVal )
{
	bool * pRet = ( bool * )pRetVal;

	THREAD_INFO_PRINTF( "JOIN\n" );

	Stop();

	pthread_join( m_id, ( void **)pRet );

	m_status = STATUS_STOPPED;

	THREAD_INFO_PRINTF( "JOIN END\n" );

	return true;
}

bool Thread::Lock( int timeout )
{
	THREAD_PRINTF( "LOCK: timeout: %d\n", timeout );

	if( timeout > 0 )
	{
		struct timespec	ts;

		clock_gettime( CLOCK_REALTIME, &ts );

		if( timeout > 1000 )
		{
			ts.tv_sec += ( timeout / 1000 );
			timeout %= 1000;
		}

		ts.tv_nsec += ( timeout * 1000000 );
		if( ts.tv_nsec > 1000000000 )
		{
			ts.tv_sec++;
			ts.tv_nsec -= 1000000000;
		}

		pthread_mutex_timedlock( & m_mutex, & ts );
	}
	else
	{
		pthread_mutex_lock( & m_mutex );
	}

	return true;
}

void Thread::Unlock()
{
	pthread_mutex_unlock( & m_mutex );

	return ;
}

bool Thread::Wait( int timeout )
{
	THREAD_PRINTF( "WAIT: timeout: %d\n", timeout );

	m_status = STATUS_WAIT;
	if( timeout > 0 )
	{
		struct timespec	ts;

		clock_gettime( CLOCK_REALTIME, & ts );

		if( timeout > 1000 )
		{
			ts.tv_sec += ( timeout / 1000 );
			timeout %= 1000;
		}

		ts.tv_nsec += ( timeout * 1000000 );
		if( ts.tv_nsec > 1000000000 )
		{
			ts.tv_sec++;
			ts.tv_nsec -= 1000000000;
		}

		if( pthread_cond_timedwait( & m_cond, & m_mutex, & ts ) == ETIMEDOUT )
		{
			THREAD_PRINTF( "TIMEOUT: timeout: %d\n", timeout );
		}
	}
	else
	{
		pthread_cond_wait( & m_cond, & m_mutex );
	}
	m_status = STATUS_RUNNING;

	return true;
}

void Thread::Signal()
{
	THREAD_PRINTF( "SIGNAL\n" );
	if( m_status == STATUS_WAIT )
	{
		pthread_cond_signal( & m_cond );
	}

	return ;
}

void Thread::Broadcast()
{
	pthread_cond_broadcast( & m_cond );

	return ;
}
