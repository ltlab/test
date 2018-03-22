#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h> /* mmap() is defined in this header */
#include <fcntl.h>
#include	<stdio.h>
#include	<string.h>
#include	<errno.h>
#include	<unistd.h>

#define	FILE_NAME	"./mmap-test.txt"
//#define	FILE_NAME	"/dev/zero"
#define	FILE_MODE	0644
#define	FILE_SIZE 	( 8 * 1024 )

#define	SECTOR_SIZE		512
#define	SECTOR_SHIFT	9 /*	0x200	*/
#define	SECTOR_MASK		( SECTOR_SIZE - 1 )
#define	SECTOR_ALIGN( size )	( ( ( size >> SECTOR_SHIFT ) + 1 ) << SECTOR_SHIFT )

int main ()
{
	char	*src = "0123456789abcdef0123456789ABCDEF 0123456789abcdef0123456789ABCDEF ";
	char	*dst;
	size_t	len = strlen( src ), pageSize = getpagesize();
	int		fdMmap;
	struct stat	statbuf;


	/* open/create the output file */
	if ( ( fdMmap = open( FILE_NAME, O_RDWR | O_CREAT | O_APPEND, FILE_MODE ) ) < 0 )
		printf("can't open() for writing\n" );

	/* go to the location corresponding to the last byte */
	//offset = lseek( fdMmap, 0, SEEK_END );

	/* find size of input file */
	if( fstat( fdMmap, &statbuf ) == 0 )
	{
		printf( "[VDB:MMAP] File Size = %d pageSize = 0x%x(%d)\n", statbuf.st_size, pageSize, pageSize );
	}

	ftruncate( fdMmap, statbuf.st_size + len );

	/* mmap the output file */
	if ( ( dst = mmap ( 0, ( statbuf.st_size & (pageSize-1) ) + len, \
					PROT_READ | PROT_WRITE, \
					MAP_SHARED, \
					fdMmap, \
					statbuf.st_size & ~(pageSize-1) ) ) == MAP_FAILED )
	{
		printf ("mmap error for output\n");
	}

	/* this copies the input file to the output file */
	printf( " src(%p) dst(%p) len = %d mmap_len = %d(0x%x) oft= %d(0x%x)\n", src, dst, len, \
			( statbuf.st_size & (pageSize-1) ) + len, ( statbuf.st_size & (pageSize-1) ) + len, \
			statbuf.st_size & ~(pageSize-1), statbuf.st_size & ~(pageSize-1) );
	memcpy ( dst + ( statbuf.st_size & (pageSize-1) ), src, len );

	printf( " dst(%p -> %p) len = %d mmap_len = %d(0x%x) oft= %d(0x%x)\n", dst, dst-( statbuf.st_size & (pageSize-1) ), len, \
			( statbuf.st_size & (pageSize-1) ) + len, ( statbuf.st_size & (pageSize-1) ) + len, \
			statbuf.st_size & ~(pageSize-1), statbuf.st_size & ~(pageSize-1) );
	
	printf( " sector_align = %d(0x%x)\n", SECTOR_ALIGN( statbuf.st_size ), SECTOR_ALIGN( statbuf.st_size ) );

	//msync( dst, len, MS_SYNC );
	if( munmap( dst, ( statbuf.st_size & (pageSize-1) ) + len ) == -1 )
	{
		printf( "munmap failed errno %d\n", errno );
	}

	close( fdMmap );

} /* main */

