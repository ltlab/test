#include "smart.h"

#define MAXPENDING 	5
#define MAXUSER		10

typedef struct _TInfo
{
	unsigned int	uiUser;
	int				iSock;
	pthread_t		tID;
} TInfo;

void *ClientRecv(void *);

///  Critical Section Start  ///
unsigned int		uiUser;
TInfo *				stpLink[MAXUSER];
/////  크리티컬 섹션 End  /////
pthread_mutex_t		MLock;

int main(int iArg, char *cpArg[])
{
	int servSock; 
	TInfo stTempInfo;
	struct sockaddr_in echoServAddr;
	struct sockaddr_in echoClntAddr;
	unsigned short echoServPort;
	unsigned int clntLen;
	int iRet;
	int iCnt;
	int iCnt2;
	unsigned char ucBuff[500];

	if (1 == iArg)
	{
		echoServPort = 9999;
	}
	else if (2 == iArg)
	{
		echoServPort = atoi(cpArg[1]);
	}
		
	servSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(0 > servSock)
	{
		printf("socket() failed");

		return 0;
	}

	memset(&echoServAddr, 0, sizeof(echoServAddr));
	echoServAddr.sin_family = AF_INET;
	echoServAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	echoServAddr.sin_port = htons(echoServPort);

	iRet = bind(servSock, (struct sockaddr *)&echoServAddr, sizeof(echoServAddr));
	if(0 > iRet)
	{
		close(servSock);
		printf("bind() failed");

		return 0;
	}

	iRet = listen(servSock, MAXPENDING);
	if(0 > iRet)
	{
		close(servSock);
		printf("listen() failed");

		return 0;
	}

	clntLen = sizeof(echoClntAddr);

	uiUser = 0;
	pthread_mutex_init(&MLock, NULL);			// mutex 초기화 
	while(1)
	{
		stTempInfo.iSock = accept(servSock, (struct sockaddr *)&echoClntAddr, &clntLen);
		if(0 > stTempInfo.iSock)				// 신규접속자 에러처리
		{
			printf("accept() failed");
			continue;	
		}	
		printf("Handling client ip : %s\n", inet_ntoa(echoClntAddr.sin_addr));
		printf("Handling client port : %d\n", ntohs(echoClntAddr.sin_port));
		printf("Handling client socket number : %d\n", stTempInfo.iSock);
		if(MAXUSER <= uiUser)					// 유저 가득차면 종료
		{
			close(stTempInfo.iSock);
			continue;
		}
		pthread_mutex_lock (&MLock);			// 다른 쓰레드 접근 불가
		stTempInfo.uiUser = uiUser;
		pthread_create (&stTempInfo.tID, 0, ClientRecv, &stTempInfo);
		++uiUser;								// 접속자수 증가전에 쓰레드 생성 
		pthread_mutex_unlock (&MLock);

		while (0 != stTempInfo.iSock);			// 쓰레드가 생성될때까지 대기
		printf("현재 접속자 수 : %d\n", uiUser);
	}

	close(servSock);

	return 0;
}

void *ClientRecv(void *vp)						// 한명이 접속할때마다 쓰레드 하나씩 생성
{
	unsigned char	ucBuff[500];
	unsigned char	ucSBuff[500];
	unsigned int	uiCnt;
	int				iRet;
	TInfo			stMyInfo = *((TInfo *)vp);

	stpLink[stMyInfo.uiUser] = &stMyInfo;
	((TInfo *)vp)->iSock = 0;					// stTempInfo.iSock의 값을 0으로 만듬
												// main과 이별 
	while(1)
	{
		iRet = read (stMyInfo.iSock, ucBuff, 500);
		if (1 > iRet)
		{
			break;
		}
		ucBuff[iRet - 1] = 0;					// enter값 제거
		printf ("[%dSock][MyUserNum:%d]:[%s]\n", stMyInfo.iSock, stMyInfo.uiUser, ucBuff);
		if ('$' == ucBuff[0])
		{
			break;
		}
		iRet = sprintf (ucSBuff, "[%dSock][MyUserNum:%d]:[%s]\n",
						stMyInfo.iSock, stMyInfo.uiUser, ucBuff);
		for (uiCnt=0 ; uiUser>uiCnt; ++uiCnt)		// 모든 유저한테 보내기
		{
			if (&stMyInfo == stpLink[uiCnt])
			{
				continue;
			}
			write (stpLink[uiCnt]->iSock, ucSBuff, iRet);
		}
	}
	pthread_mutex_lock (&MLock);					// 다른 쓰레드 접근 불가
	--uiUser;	
	stpLink[stMyInfo.uiUser] = stpLink[uiUser];
	stpLink[stMyInfo.uiUser]->uiUser = stMyInfo.uiUser;
	pthread_mutex_unlock (&MLock);
	close(stMyInfo.iSock);
	return 0;
}

