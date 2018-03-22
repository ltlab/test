#ifndef _SMART_H_
#define _SMART_H_

#include <stdio.h>			// pritnf, fprintf
#include <sys/socket.h>		// socket, bind, connect
#include <arpa/inet.h>		// sockaddr_in, inet_ntoa
#include <stdlib.h>			// atoi
#include <string.h>			// memset
#include <unistd.h>			// close
#include <sys/time.h>
#include <sys/types.h>

#define	ENDMSG	"@!*$q"
#define	LOGOUT	"-zeq="
#define	CLTEND	0x05		// 종료 Ctrl+E키 
#define	OUTMSG	"1명 퇴장"

#define	MAXPENDING	5		// Maximum outstanding connection requests
#define	MAXUSER	10


#endif	//_SMART_H_

