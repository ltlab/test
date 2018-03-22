#ifndef	_THREAD_H_
#define	_THREAD_H_

#include	<pthread.h>
#include	<errno.h>
#include	<string.h>	//	strerror()

#include	<iostream>
#include	<string>

#include	<unistd.h>
#include	<sys/syscall.h>	//	for SYS_xxxx definitions
#include	<sys/types.h>	//	for pid_t

extern "C" int gettid(void);

//#define	__DEBUG_THREAD__

#ifdef	__DEBUG_THREAD__

#define	THREAD_PRINTF( fmt, args... )		\
     printf( "[%16s:%4d P(%5d) T(%5d)]:|%16s|\t"fmt, __FUNCTION__, __LINE__, getpid(), gettid(), GetName().c_str(), ##args )

#else	//	__DEBUG_THREAD__
#define	THREAD_PRINTF( fmt, args... )
#endif	//	__DEBUG_THREAD__

#define	THREAD_INFO_PRINTF( fmt, args... )		\
     printf( "[%16s:%4d P(%5d) T(%5d)]:|%16s|\t"fmt, __FUNCTION__, __LINE__, getpid(), gettid(), GetName().c_str(), ##args )

namespace CTRing
{
	class Thread
	{
	public:
		typedef enum THREAD_STATUS_E
		{
			STATUS_STOPPED = -1,
			STATUS_RUNNING = 0,
			STATUS_WAIT = 1,
			STATUS_IDLE = 1,	//	Use in ThreadPool

			STATUS_END
		} THREAD_STATUS;

		static const int PRIORITY_LOW		= 0;
		static const int PRIORITY_NORMAL	= 1;
		static const int PRIORITY_HIGH		= 2;
	private:

		pthread_t			m_id;
		pthread_cond_t		m_cond;
		pthread_mutex_t		m_mutex;
		THREAD_STATUS		m_status;

		static void			*Run( void * pArg );
	protected:
		const std::string	m_name;
		const int			m_priority;
		bool				m_isRunning;

		virtual	bool		ThreadFunc( void * pArg ) = 0;
	public:
		Thread( const std::string name = "NONE", const int priority = PRIORITY_NORMAL );
		virtual ~Thread();

		void					SetThreadName( void );
		const pthread_t			GetTid() { return m_id;	}
		const THREAD_STATUS		GetStatus() { return m_status; }
		const std::string		GetName() { return m_name; }
		const int 				GetPriority() { return m_priority; }

		bool	Start();
		bool	Stop();
		bool	Join( void * pRetVal = NULL );

		bool	Lock( int timeout = 0 );
		void	Unlock();
		bool	Wait( int timeout = 0 );
		void 	Signal();
		void 	Broadcast();
	};
}
#endif	//	_THREAD_H_

