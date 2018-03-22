#include	"ThreadPool.hpp"

#include	<stdio.h>
#include	<unistd.h>

#ifdef	__DEBUG_THREAD_POOL__
#ifndef	__DEBUG_THREAD__
extern "C" int gettid(void)
{
	return ( int )syscall( __NR_gettid );
}
#endif	//	__DEBUG_THREAD__
#endif	//	__DEBUG_THREAD_POOL__

using namespace CTRing;

WorkerThread::WorkerThread( const std::string name, const int priority )
: Thread( name, priority ), m_pTaskInfo( NULL ), m_timeout( 3000 )
{
}

WorkerThread::~WorkerThread()
{
}

bool WorkerThread::ThreadFunc( void * pArg )
{
	//Thread	*pWorker = reinterpret_cast< Thread * >( pArg );

	do
	{
		Lock();
		/*	Avoid spurious wakeup	*/
		while( m_pTaskInfo == NULL )
		{
			Wait( m_timeout );
			if( m_isRunning == false ) { break; }
		}
		Unlock();

		Lock();
		if( m_pTaskInfo != NULL )
		{
			if( m_pTaskInfo->TaskFunc != NULL )
			{
				THREAD_POOL_PRINTF( "START_TASK\tm_pTaskInfo: %p pData: %p\n", m_pTaskInfo, m_pTaskInfo->pData );
				if( m_pTaskInfo->TaskFunc( m_pTaskInfo->pData ) == true )
				{
					if( m_pTaskInfo->Callback != NULL )
					{
						m_pTaskInfo->Callback( m_pTaskInfo->pData );
					}
				}
			}
			if( m_pTaskInfo->pData != NULL )
			{
				if( m_pTaskInfo->freeData == true )
				{
					delete m_pTaskInfo->pData;
					m_pTaskInfo->pData = NULL;
				}
			}
			delete m_pTaskInfo;
			m_pTaskInfo = NULL;
		}
		Unlock();
	} while( m_isRunning == true );

	return true;
}

bool WorkerThread::AssignTask( TASK_INFO * pTaskInfo )
{
	if( pTaskInfo == NULL ) { return false; }
	if( GetStatus() != STATUS_IDLE ) { return false; }
	if( m_pTaskInfo != NULL ) { return false; }

	Lock();
	m_pTaskInfo = pTaskInfo;
	Signal();
	Unlock();

	return true;
}

bool WorkerThread::Join( void * pRetVal )
{
	m_timeout = 3000;	//	3 secs

	return Thread::Join( pRetVal );
}


ThreadPool::ThreadPool( const int maxThread )
: Thread( "THREAD_POOL", PRIORITY_HIGH ), m_maxThread( maxThread ), m_timeout( 3000 )
{
	m_workerVector.clear();

	m_workerVector.assign( m_maxThread, ( WorkerThread * )NULL );
}

ThreadPool::~ThreadPool()
{
	Lock();

	for( int idx = 0 ; idx < m_maxThread ; idx++ )
	{
		if( m_workerVector.at( idx ) != NULL )
		{
			delete m_workerVector.at( idx );
		}
	}
	m_workerVector.clear();

	Unlock();
}

bool ThreadPool::JoinAll()
{
	THREAD_POOL_INFO_PRINTF( "JOIN_ALL\n" );

	Lock();
	Signal();
	Unlock();

	while( m_taskQueue.empty() == false )
	{
		usleep( 10 * 1000 );
	}
	THREAD_POOL_INFO_PRINTF( "All tasks have been completed!!\n" );

	for( int idx = 0 ; idx < m_maxThread ; idx++ )
	{
		if( m_workerVector.at( idx ) != NULL )
		{
			m_workerVector.at( idx )->Join();
		}
	}
	THREAD_POOL_INFO_PRINTF( "JOIN_ALL END\n" );

	return true;
}

bool ThreadPool::Join( void * pRetVal )
{
	JoinAll();

	m_timeout = 3000;	//	3 sec

	return Thread::Join( pRetVal );
}

bool ThreadPool::AddTask( TASK_INFO *pTaskInfo, const int priority )
{
	Lock();

	THREAD_POOL_PRINTF( "ADD_TASK\tpTaskInfo: %p pData: %p\n", pTaskInfo, pTaskInfo->pData );

	m_taskQueue.push( std::pair< int, TASK_INFO * >( priority, pTaskInfo ) );

	Signal();

	Unlock();

	return true;
}

bool ThreadPool::ThreadFunc( void * pArg )
{
	//Thread	*pThread = reinterpret_cast< Thread * >( pArg );

	THREAD_POOL_PRINTF( "START_THREAD_POOL\n" );

	/*	Create Worker Threads.
	 *	*/
	Lock();
	for( int idx = 0 ; idx < m_maxThread ; idx++ )
	{
		if( m_workerVector.at( idx ) == NULL )
		{
			char	name[ 32 ] = { 0x0, };
			sprintf( name, "Worker_%d", idx );

			WorkerThread *pWorker = new WorkerThread( name, PRIORITY_NORMAL );

			if( pWorker != NULL )
			{
				m_workerVector.at( idx ) = pWorker;
				m_workerVector.at( idx )->Start();
			}
		}
	}
	Unlock();

	/*	Manage WorkerThreads.	*/
	do
	{
		Lock();
		/*	Wait Until adding Task into Queue	*/
		/*	Avoid spurious wakeup	*/
		while( m_taskQueue.empty() == true )
		{
			Wait( m_timeout );
			if( m_isRunning == false ) { break; }
		}
		Unlock();

		int busyCount = 0;

		/*	Find IDLE Worker	*/
		for( int idx = 0 ; idx < m_maxThread ; idx ++ )
		{
			if( m_taskQueue.empty() == true ) { break; }

			if( m_workerVector.at( idx )->GetStatus() == STATUS_IDLE )
			{
				Lock();

				const std::pair< int, TASK_INFO * > taskPair = m_taskQueue.top();

				if( taskPair.second != NULL )
				{
					THREAD_POOL_PRINTF( "ASSIGN\t\tidx: %d pTaskInfo: %p pData: %p m_taskQueue.size: %d\n", \
							idx, taskPair.second, taskPair.second->pData, m_taskQueue.size() );

					if( m_workerVector.at( idx )->AssignTask( taskPair.second ) == true )
					{
						m_taskQueue.pop();
						busyCount++;
					}
					else
					{
						THREAD_POOL_PRINTF( "ASSIGN_FAIL\tidx: %d pTaskInfo: %p pData: %p m_taskQueue.size: %d\n", \
								idx, taskPair.second, taskPair.second->pData, m_taskQueue.size() );
					}
				}
				else
				{
					m_taskQueue.pop();
				}

				Unlock();
			}
			else
			{
				busyCount++;
			}
		}

		if( busyCount >= m_maxThread )
		{
			usleep( 10 * 1000 );
		}

	} while( m_isRunning == true );

	return true;
}
