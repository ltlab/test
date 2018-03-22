#include <stdio.h> 
#include <string.h> 
#include <pthread.h> 

pthread_t threads[5]; 
int done[5]; 

void* thread_main( void * ); 
int thread_free( void );

int main( void ) 
{ 
	int i; 

	//printf( "pid=%d\n", getpid() ); 

	for( i = 0 ; i < 5 ; i++ ) 
	{     
		done[ i ] = 0; 
		pthread_create( &threads[ i ], NULL, thread_main, (void *)i ); 
		printf( "[START] thread %d, %d\n", i, (int)threads[ i ] ); 
	} 
	sleep( 3 );

	thread_free();

	return 0; 
} 

int thread_free( void )
{
	int i;
	int status; 
	int rc; 

	for( i = 4 ; i >= 0 ; i-- ) 
	{ 
		done[ i ] = 1; 
		rc = pthread_join( threads[i], (void **)&status ); 
		if( rc == 0 ) 
		{ 
			printf( "Completed join with thread %d status= %d\n", i, status ); 
		} 
		else 
		{ 
			printf( "ERROR; return code from pthread_join() is %d, thread %d\n", rc, i ); 
			return -1; 
		} 
	} 
	return 0; 
}


void* thread_main( void *arg ) 
{ 
	int i; 
	//double result = .0; 
	int result = (int)arg; 

	printf( "### thread: arg = %d, getpid() = %d\n", (int)arg, getpid() ); 

	while( !done[ (int)arg ] ) 
	{ 
		for( i = 0 ; i < 100 ; i++ ) 
		{ 
			//result = result + ( double )random(); 
			result += i;
			usleep( 10 * 1000 );
		}
		//printf( "### thread: %d, result = %e\n", (int)arg, result ); 
		printf( "### thread: %d, result = %d\n", (int)arg, result ); 
	} 
	printf( "###[FREE] thread: %d, result = %d\n", (int)arg, result ); 

	pthread_exit( (void *)result ); 
} 
