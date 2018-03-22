#ifndef _PROJECTINC_
#define _PROJECTINC_

#define NDEBUG

#ifndef NDEBUG
#define dp(fmt,args...) printf( fmt, ## args ); putchar( '\n')
#define dlp(fmt,args...) printf( "[%s %d]" fmt, __FILE__,__LINE__, ## args )
#else
#define dp(fmt,args...) 
#define dlp(fmt,args...) 
#endif

extern void remove_white_char( char *);
extern void error_handling(char *message);

//----- SysManager ---------------------------------------------------

#define   BUF_SIZE          1024
                                                                            
#endif
