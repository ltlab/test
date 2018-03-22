#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
 
static int
rmdir_helper(const char *fpath, const struct stat *sb,
	int tflag, struct FTW *ftwbuf)
{
	switch ( tflag )
	{
		case FTW_D:
		case FTW_DP:
			if ( rmdir(fpath) == -1 )
				perror("unlink");
			break;
 
		case FTW_F:
		case FTW_SL:
			if ( unlink(fpath) == -1 )
				perror("unlink");
			break;
 
        default:
			puts("do nothing");
	}
	return 0;
}
 
int main(int argc, char* argv)
{
	const char* dir_to_remove = "/path/to/remove";
	int flags = 0;
	flags |= FTW_DEPTH; // post-order traverse
 
	if ( argc == 2 )
		dir_to_remove = argv[1];
 
	if (nftw((dir_to_remove, rmdir_helper, 10, flags) == -1)
	{
		perror("nftw");
		exit(EXIT_FAILURE);
	}
	return 0;
}
