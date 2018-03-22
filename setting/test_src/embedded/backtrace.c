#include <stdio.h>

#include <string.h>
#include <sys/uio.h>
#include <dlfcn.h>
#include <stdio.h>
#include <link.h>	/* required for __ELF_NATIVE_CLASS */

#include <sys/ucontext.h>
//#include <execinfo.h>

/* Command
arm-hisiv100nptl-linux-g++ -o backtrace backtrace.c -fno-omit-frame-pointer -mapcs-frame -mabi=aapcs-linux -rdynamic -ldl
*/

extern void * __libc_stack_end;

struct backtrace_frame_t
{
    void * fp;
    void * sp;
    void * lr;
    void * pc;
};

#define	BACKTRACE_DEPTH	( 32 )

int backtrace(void ** array, int size)
{
    void * top_frame_p;
    void * current_frame_p;
    struct backtrace_frame_t * frame_p;
    int frame_count;

    top_frame_p = __builtin_frame_address(0);
    current_frame_p = top_frame_p;
    frame_p = (struct backtrace_frame_t*)((void**)(current_frame_p)-3);
    frame_count = 0;

	fprintf(stderr, "backtrace: cur(%p) pc(%p) lr(%p) sp(%p) fp(%p)\n", *( ( int * )current_frame_p - 1 ),
		frame_p->pc, frame_p->lr, frame_p->sp, frame_p->fp );

    if( __builtin_return_address(0) != frame_p->lr )
    {
        fprintf(stderr, "backtrace error: __builtin_return_address(0) %p != frame_p->lr(%p)\n", \
				__builtin_return_address(0), frame_p->lr);
        return frame_count;
    }

    if (current_frame_p != NULL
        && current_frame_p > (void*)&frame_count
        && current_frame_p < __libc_stack_end)
    {
        while (frame_count < size
               && current_frame_p != NULL
               && current_frame_p > (void*)&frame_count
               && current_frame_p < __libc_stack_end)
        {
            frame_p = (struct backtrace_frame_t*)((void**)(current_frame_p)-3);	//	get fp
            array[frame_count] = frame_p->lr;	//	get lr
			
			fprintf(stderr, "backtrace: [%d] cur(%p) pc(%p) lr(%p) sp(%p) fp(%p)\n", frame_count,
					*( ( int * )current_frame_p - 1 ), frame_p->pc, frame_p->lr, frame_p->sp, frame_p->fp );

            frame_count++;
            current_frame_p = frame_p->fp;
        }
    }

    return frame_count;
}


#if __ELF_NATIVE_CLASS == 32
# define WORD_WIDTH 8
#else
/* We assyme 64bits.  */
# define WORD_WIDTH 16
#endif

#define BUF_SIZE ( WORD_WIDTH + 1 )

void backtrace_symbols_fd (void *const *array, int size, int fd)
{
	struct iovec iov[9];
	int cnt;

	for (cnt = 0; cnt < size; ++cnt) {
        char buf[BUF_SIZE] ={0,};
		Dl_info info;
		size_t last = 0;
		size_t len = 0;

		memset(buf, 0, sizeof(buf));
		if (dladdr (array[cnt], &info)
			&& info.dli_fname && info.dli_fname[0] != '\0')	{
			/* Name of the file.  */
			iov[0].iov_base = (void *) info.dli_fname;
			iov[0].iov_len = strlen (info.dli_fname);
			last = 1;

			/* Symbol name.  */
			if (info.dli_sname != NULL) {
                char buf2[BUF_SIZE] ={0,};
				memset(buf2, 0, sizeof(buf2));
				size_t diff;

				iov[1].iov_base = (void *) "(";
				iov[1].iov_len = 1;
				iov[2].iov_base = (void *) info.dli_sname;
				iov[2].iov_len = strlen (info.dli_sname);

				if (array[cnt] >= (void *) info.dli_saddr) {
					iov[3].iov_base = (void *) "+0x";
					diff = ( size_t )array[cnt] - ( size_t )info.dli_saddr;
				} else {
					iov[3].iov_base = (void *) "-0x";
					diff = ( size_t )info.dli_saddr - ( size_t )array[cnt];
				}

				iov[3].iov_len = 3;

				/* convert diff to a string in hex format */
				len = snprintf(buf2, sizeof(buf2), "%lx", (unsigned long) diff);
				iov[4].iov_base = buf2;
				iov[4].iov_len = len;

				iov[5].iov_base = (void *) ")";
				iov[5].iov_len = 1;

				last = 6;
			}
		}

		iov[last].iov_base = (void *) "[0x";
		iov[last].iov_len = 3;
		++last;

		/* convert array[cnt] to a string in hex format */
		len = snprintf(buf, sizeof(buf), "%lx", (unsigned long) array[cnt]);
		iov[last].iov_base = buf;
		iov[last].iov_len = len;

		++last;

		iov[last].iov_base = (void *) "]\n";
		iov[last].iov_len = 2;
		++last;

		writev (fd, iov, last);
	}
}

void backtrace_test(void* fp)
{
  if (fp == NULL )
    return;
//  if( fp = *( (int*)fp - 3) )
//	  return;

//  fprintf (stderr, "0 %x at %p\n", *((int*)fp ), fp );
  fprintf (stderr, "1 %x at %p\n", *((int*)fp - 1 ), (int *)fp - 1 );
//  fprintf (stderr, "2 %x at %p\n", *((int*)fp - 2 ), (int *)fp - 2 );
//  fprintf (stderr, "3 %x at %p\n", *((int*)fp - 3 ), (int *)fp - 3 );
//  fprintf (stderr, "4 %x at %p\n", *((int*)fp - 4 ), (int *)fp - 4 );
  backtrace_test( (void*)( *((int*)fp - 3 ) ) );
}

int bar()
{
	void*	backTrace[ BACKTRACE_DEPTH ] = { NULL };
	size_t	size;
	printf ("bar\n");
	printf ("*** backtrack ***\n");
	size = backtrace( backTrace, BACKTRACE_DEPTH );

	// print out all the frames to stderr
	backtrace_symbols_fd( backTrace, size, 2);
	//backtrace (__builtin_frame_address (0));
	printf ("\n");

	return 0;
}

int foo()
{
  printf ("foo\n");
  printf ("*** backtrack ***\n");
  //backtrace (__builtin_frame_address (0));
  printf ("\n");

  return bar();
}

int main()
{
  printf ("main at %p\n", main);
  printf ("foo at %p\n", foo);
  printf ("bar at %p\n\n", bar);

  printf ("main\n");
  printf ("*** backtrack ***\n");
  //backtrace (__builtin_frame_address (0));
  printf ("\n");
 
  return foo();
}

