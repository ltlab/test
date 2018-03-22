#ifndef	_THREAD_POOL_H_
#define	_THREAD_POOL_H_

#include	"Thread.hpp"

#include	<iostream>
#include	<string>
#include	<vector>
#include	<queue>

//#define	__DEBUG_THREAD_POOL__

#ifdef	__DEBUG_THREAD_POOL__

#define	THREAD_POOL_PRINTF( fmt, args... )		\
     printf( "[%16s:%4d P(%5d) T(%5d)]:|%16s|\t"fmt, __FUNCTION__, __LINE__, getpid(), gettid(), GetName().c_str(), ##args )
#else	//	__DEBUG_THREAD_POOL__
#define	THREAD_POOL_PRINTF( fmt, args... )
#endif	//	__DEBUG_THREAD_POOL__

#define	THREAD_POOL_INFO_PRINTF( fmt, args... )		\
     printf( "[%16s:%4d P(%5d) T(%5d)]:|%16s|\t"fmt, __FUNCTION__, __LINE__, getpid(), gettid(), GetName().c_str(), ##args )

namespace CTRing
{
	class	WorkerThread;

	typedef struct TASK_INFO_S
	{
		bool			( *TaskFunc )( void * pArg );
		bool			( *Callback )( void * pArg );
		void			* pData;
		bool			freeData;
	} TASK_INFO;

	class ThreadPool: public Thread
	{
		static const int MAX_THREAD = 4;

	private:
		const int	m_maxThread;
		int			m_timeout;

		std::vector< WorkerThread * >	m_workerVector;
		std::priority_queue< std::pair< int, TASK_INFO * > >		m_taskQueue;

	protected:
		bool		ThreadFunc( void * pArg );

	public:
		ThreadPool( const int maxThread = MAX_THREAD );
		virtual ~ThreadPool();

		bool	AddTask( TASK_INFO * pTaskInfo, const int priority = PRIORITY_NORMAL );

		bool	JoinAll();
		bool	Join( void * pRetVal = NULL );
	};

	class WorkerThread: public Thread
	{
	private:
		TASK_INFO	* m_pTaskInfo;
		int			m_timeout;

	protected:
		bool		ThreadFunc( void * pArg );

	public:
		WorkerThread( const std::string name, const int priority = PRIORITY_NORMAL );
		virtual ~WorkerThread();

		bool		AssignTask( TASK_INFO * pTaskInfo );

		bool		Join( void * pRetVal = NULL );
	};

}
#endif	//	_THREAD_POOL_H_

