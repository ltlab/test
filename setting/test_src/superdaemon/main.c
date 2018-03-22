/*********************************************************************
 이  름 :   superdaemon - 등록된 프로그램을 실행 및 관리
 버  전 :   1.0.2
                  -  get_execinfo() 함수 추가
                  -  read_task_list() 함수에서 task_t 정보를 모두 구성하도록 수정
            1.0.1
                  -  자시 프로세스에서 프로그램을 식행하기 전에
                     부모 프로세스의 타스크 정보에 생성한 프로세스의 ID를
                     지정하는 시간을 벌어 주기 위해 sleep()함수를 호출
            1.0.0
*********************************************************************/
#include  <stdio.h>
#include  <stdlib.h>
#include  <signal.h>
#include  <string.h>
#include  <sys/types.h>
#include  <sys/wait.h>
#include  <unistd.h>
#include  "main.h"
#include  "projectinc.h"

#include	<time.h>
#include	<fcntl.h>

#define  PATH_SIZE         255
#define  TASK_ARRAY_SIZE   20

#define	INI_FILE "/CTR/daemon.ini"
#define	LOG_FILE "/CTR/daemon.log"
#define	SHUTDOWN_FILE "/tmp/shutdown_ctrPro"
#define	RESTART_FILE "/tmp/restart_ctrPro"
#define	REBOOT_FILE "/tmp/reboot_ctrPro"
int		logFd;

task_t   ary_task[TASK_ARRAY_SIZE];                                     // 타스크 배열
int      cnt_task;                                                      // 실행한 타스크의 개수

//--------------------------------------------------------------------
// desc   차일드 프로세스가 종료되면 발생하는 이벤트 핸들러
// params sig
// ref    종료된 차일드 프로세스에 해당하는 ary_task 의 아이템 값을
//        수정한다.
//
//        ary_task 아이템 값을 수정하면, main() 에서 check_task_list()
//        를 호출함으로써 다시 실행하게 된다.
//--------------------------------------------------------------------
void on_check_child( int sig)
{
	pid_t    pid;
	int      result;
	int      ndx;

	time_t	t;
	char	buf[ 32 ];
	char	writeBuf[ 128 ];
	char	actBy[ 16 ];

	// 종료된 차일드 프로세스에 해당하는 ary_task 아이템을 찾는다.
	// task_t 아이템의 pid 를 0 으로 설정하면 check_task_lisk() 에서
	// count_down 값을 감소하고, 0 이되면 다시 실행하게 된다.

	while( 0 < ( pid = waitpid( -1, &result, WNOHANG)))
	{                                                                    dp( "killed child pid=%d", pid);
		for ( ndx= 0; ndx < cnt_task; ndx++)
		{                                                                 dp( "checked child pid=%d %s", ary_task[ndx].pid, ary_task[ndx].full_filename);
			if ( pid == ary_task[ndx].pid)
			{
				time( &t );
				strftime( buf, sizeof( buf ), "%Y.%m.%d %k:%M:%S", localtime( &t ) );
				if( access( SHUTDOWN_FILE, F_OK ) == 0 )
				{
					strcpy( actBy, "SHUTDWN" );
				}
				else if( access( RESTART_FILE, F_OK ) == 0 )
				{
					strcpy( actBy, "RESTART" );
				}
				else if( access( REBOOT_FILE, F_OK ) == 0 )
				{
					strcpy( actBy, "RESTART" );
				}
				else
				{
					strcpy( actBy, "UNKNOWN" );
				}
				sprintf( writeBuf, "STOP:\t%s\t%d\t%s\t%s ndx[%d]\n", actBy, ary_task[ ndx ].pid, \
						ary_task[ ndx ].full_filename, buf, ndx );
				write( logFd, writeBuf, strlen( writeBuf ) );
				ary_task[ndx].count_down   = ary_task[ndx].interval;        // 다시 실행하기 까지의 대기 시간(초)
				ary_task[ndx].pid          = 0;                             // check_task_list() 의 대상이 되도록 0 으로 초기화
			}
		}
	}
}

//--------------------------------------------------------------------
// desc   _str 에서 첫번째 공백 문자 전까지
//             또는 공백 문자가 없을 때에는 문자열 끝까지를 _rst
//             에 복사한다.
// params _str 원본 문자열을 가지고 있는 변수
//        _rst 문자열을 복사 받을 변수
// ret    복사 문자열 다음의 문자 위치의 포인터
//--------------------------------------------------------------------
char *str_spc( char *_str, char *_rst)
{
   char *pos;

   *_rst = '\0';                                                        // NULL 을 대입
   pos = index(_str, ' ');
   if ( !pos)                                                           // 공백 구분자가 없다면 다음 루프로
   {
      strcpy(_rst, _str);
   }
   else
   {
      strncpy(_rst, _str, pos-_str);
      _rst[pos-_str]  = '\0';
      while ( ' ' == *pos)                                              // 앞에 있는 공백 삭제
         pos++;
   }
   return( pos);
}

//--------------------------------------------------------------------
// desc   _task 의 내용에 따라 새 프로세스를 만들어서 실행한다.
// params _task : 실행 파일에 대한 정보
// ref    1.
//          _task 의 task 로부터 실행파일과 인수를 구한다.
//          실행이나 인수에서 문제가 있다면 에러를 출력하고,
//          _task 의 error 에 에러코드를 넣어 다음 호출에도 실행이
//          되지 않도록 한다.
//        2.
//          인수는 20개까지 처리한다.
//
//        3.
//          인수의 개수는 프로그램에 따라 다르므로,
//          *[] 를 사용하는 execv() 를 사용한다.
//--------------------------------------------------------------------
void exec_task( task_t *_task)
{
	pid_t    pid;
	time_t	t;
	char	buf[ 32 ];
	char	writeBuf[ 128 ];

	if ( ERR_NONE != _task->error)
	{
		return;
	}

	pid = fork();
	if ( 0 == pid)                                                       // 자식 프로세서 라면
	{                                                                    dp( "1 sec wait and exec %s", _task->full_filename);
		sleep( 1);                                                        // 프모  프로세스에서 _task->pid = pid 가 실행이 되도록 sleep
		execv(_task->full_filename, _task->params);                       // 프로그램을 실행한다.
	}
	else if ( 0 < pid)                                                   // fork 실행에 이상이 없었다면
	{                                                                    dp( "********** task= %s New Pid= %d", _task->full_filename, pid);
		_task->pid = pid;
		time( &t );
		strftime( buf, sizeof( buf ), "%Y.%m.%d %k:%M:%S", localtime( &t ) );
		printf( "START: %s\t%s\n", _task->full_filename, buf );
		sprintf( writeBuf, "START:\t\t%d\t%s\t%s\n", _task->pid, _task->full_filename, buf );
		write( logFd, writeBuf, strlen( writeBuf ) );
	}
	else                                                                 // 만일 fork() 실행에 실패했다면
	{                                                                    dp( "Reset Counter %d", _task->interval);
		_task->count_down   = _task->interval;
	}
}

//--------------------------------------------------------------------
// desc   ary_task 목록을 확인해서 종료된 차일드가 있는지를 확인한다.
//        종료된 차일드가 있다면 실행여부(에러 상태)를 확인하고,
//        재 실행 시킨다.
//--------------------------------------------------------------------
void check_task_list( void)
{
	int     ndx;

	// ary_task 목록에서 pid 가 0 인 항목은
	// 종료된 차일드 이다.
	//

	for ( ndx = 0; ndx < cnt_task; ndx++)
	{
		if ( ( !ary_task[ndx].pid)                                        // 타스크가 실행 전이고
				&& ( ERR_NONE == ary_task[ndx].error))                      // 에러가 없다면
		{
			if ( 0 < ary_task[ndx].count_down)                             // 아직 카우트 다운 중이라면
			{                                                              dp( "count down :%d", ary_task[ndx].count_down);
				ary_task[ndx].count_down--;
			}
			else                                                           // 카운트 다운을 완료
			{
				exec_task( &ary_task[ndx]);
			}
		}
	}
	return;
}

//--------------------------------------------------------------------
// 파일의 문자열에서 task_t 의 정보중 프로그램 이름과 인수를 구한다.
//
// _data : 파일에서 읽어 들인 내용중 디렉토리 위치부터의 문자열
// _task : 실행 파일에 대한 정보
//
// typedef struct
// {
//   char *full_filename;     <- 디렉토리 포함 전체 파일 이름을 구한다.
//   char *params[20];        <- 프로그램 실행을 위한 인수 배열을 구한다.
//          :
//   int   error;             <- 내용을 구성 중에 에러가 있다면 에러 정보
//          :
// } task_t;



// ref    1.
//          _task 의 task 로부터 실행파일과 인수를 구한다.
//          실행이나 인수에서 문제가 있다면 에러를 출력하고,
//          _task 의 error 에 에러코드를 넣어 다음 호출에도 실행이
//          되지 않도록 한다.
//        2.
//          인수는 20개까지 처리한다.
//
//        3.
//          인수의 개수는 프로그램에 따라 다르므로,
//          *[] 를 사용하는 execv() 를 사용한다.
//--------------------------------------------------------------------
void get_execinfo( char *_data, task_t *_task)
{
   char     buf[BUF_SIZE];
   char     exe_path[PATH_SIZE+5];                                      // 에러 대비 +5
   char     exe_name[PATH_SIZE+5];                                      // 에러 대비 +5
   int      nparam;
   int      sz_str;
   pid_t    pid;

                                 // 경로 명을 구한다.
                                 // 경로 명의 끝에 '/' 이 없다면 추가한다.

   _data = str_spc(_data, buf);
   if ( PATH_SIZE < strlen( buf))                                       // 경로명의 길이가 너무 길다.
   {
      printf( "%s : path is too long!!\n", buf);
      _task->error  = ERR_PATH_TOO_LONG;
      return;
   }
   strcpy( exe_path, buf);                                              // exe_path <- 경로명

                                 // 경로 명의 끝의 '/' 를 확인한다.

   sz_str  = strlen( exe_path);
   if ( '/' != exe_path[sz_str-1])                                      // 끝에 / 를 반드시 포함
   {
      exe_path[sz_str  ]  = '/';
      exe_path[sz_str+1]  = '\0';
   }

                                 // 실행 파일의 전체 이름을 구한다.

   _data  = str_spc(_data, buf);
   if ( PATH_SIZE < strlen( exe_path)+strlen( buf))                     // 경로와 실행파일의 이름 길이 합이 너무 길다.
   {
      printf( "%s/%s : full name is too long!!\n", exe_path, buf);
      _task->error  = ERR_PATH_TOO_LONG;
      return;
   }
   strcpy( exe_name, buf);
   strcat( exe_path, exe_name);                                         // exe_path <- 경로/실행파일이름
   _task->full_filename = malloc( strlen( exe_path)+1);
   strcpy( _task->full_filename, exe_path);

                                 // 실행 파일의 존재 유무를 확인한다.

   if ( 0 != access(_task->full_filename, F_OK))
   {
      printf( "%s is not exists!!\n",_task->full_filename);
      _task->error  = ERR_PATH_TOO_LONG;
      return;
   }

                                 // 실행에 필요한 인수를 배열로 구성한다.
                                 // 첫번째 인수는 실행파일 이름으로 한다.
                                 // 마지막 인수는 NULL 이 되도록 한다.

   _task->params[0] = malloc( strlen( exe_name)+1);
   strcpy(_task->params[0], exe_name);

                                 // [0] 인수는 실행 파일의 이름이므로,
                                 // [1] 부터 프로그램의 인수를 대입한다.
                                 // params는 *[20]로 선언되어 있으므로
                                 // 인수 개수가 19 개를 넘지 못하게 한다.

   nparam    = 1;
   while (_data)
   {
      _data = str_spc(_data, buf);                                      // 다음 인수값을 구한다.
      _task->params[nparam] = malloc( strlen( buf)+1);                  // param[nparam] <- 인수값
      strcpy(_task->params[nparam], buf);
      nparam++;
      if ( 19 == nparam)                                                // 인수가 너무 많다면
      {
         printf( "%s has too many params!!\n", exe_name);
         _task->error  = ERR_TOO_MANY_PARAMS;
         return;
      }
   }
   _task->params[nparam]   = ( char *)0;                                // 마지막 아이템은 NULL
   _task->error            = ERR_NONE;                                  // 에러 없음
}

//--------------------------------------------------------------------
// ini 파일에서 실행할 파일의 정보를 읽어 들이고,
// ary_task 목록을 작성한다.
//--------------------------------------------------------------------
void read_task_list( void)
{
   FILE  *fp;
   char  *tag;
   char  *pos;
   char   buf[BUF_SIZE];
   char   item[255];

   cnt_task  = 0;                                                       // 실행할 작업 개수 초기화

   fp = fopen( INI_FILE, "r");                               // 환경파일 open;
   if ( NULL == fp)
   {                                                                    // 읽어 들일 타스크가 없음
      return;
   }
   else
   {
      while( NULL != fgets( buf, BUF_SIZE, fp))
      {
         tag = buf;
         remove_white_char( tag);                                       // 문장에 라인피드와 같은 화이트 문자를 없앤다.

                                 // 프로그램 종료 시 다음 시작까지의 시간 간격을 구한다.

         while ( ' ' == *tag)                                           // 앞에 있는 공백 삭제
         {
            tag++;
         }

         if ( ( ' ' > *tag) ||                                          // 문장의 끝이거나
              ( !strncmp( tag, "//", 2))  )                             // 주석문이라면 다음 행으로
         {
            continue;
         }
                                 // 행의 첫 번째 데이터는 대기 시간 정보이다.
                                 // 첫번째 문자열에서 시간 정보를 구한다.

         tag = str_spc( tag, item);
         ary_task[cnt_task].interval  = atoi( item);

                                 // 프로그램의 실행 정보를 구한다.
                                 // 실행 정보에는 경로와 프로그램 명이 있어야 하므로
                                 // 최소 공백 문자가 하나 있어야 한다.
                                 // 인수에 공백 문자가 없다면 취소한다.

         if ( ( ' ' > *tag) ||                                          // 문장의 끝이거나
              ( !strncmp( tag, "//", 2))  )                             // 주석문이라면 다음 행으로
         {
            continue;
         }

         pos = index( tag, ' ');                                        // 공백 문자가 없다면 취소한다.
         if (!pos)
         {
            continue;
         }

         get_execinfo( tag, &ary_task[cnt_task]);

                                 // task 의 초기값을 초기화 한다.

         ary_task[cnt_task].count_down = 0;
         ary_task[cnt_task].pid        = 0;
         cnt_task++;
         if ( TASK_ARRAY_SIZE == cnt_task)
         {
            printf( "***** Task list is over %d. *****\n", TASK_ARRAY_SIZE);
            break;
         }
      }
   }
   fclose( fp);
}

//--------------------------------------------------------------------
// 차일드 프로세서의 죽음을 확인하는 시그널 등록
//--------------------------------------------------------------------
void reg_child_signal( void)
{
   struct  sigaction  sig_child;                                        // 차일드의 죽음을 알기 위한 시그털

   sig_child.sa_handler  = on_check_child;
   sigemptyset( &sig_child.sa_mask);
   sig_child.sa_flags    = 0;
   sigaction( SIGCHLD, &sig_child, 0);
}

//--------------------------------------------------------------------
// main procedure
//--------------------------------------------------------------------
int main( int argc, char **argv)
{
	pid_t	sid;
	char	writeBuf[ 128 ];
#ifdef NDEBUG

	pid_t   pid_daemon;                                                  // release 모드일 때만 endif 사이의 내용이 실행된다.

	pid_daemon  = fork();
	if ( 0 > pid_daemon)                                                 // fork() 실행에 실패했다면
	{
		printf( "ERR: fork() failed\n");
		exit( EXIT_FAILURE );
	}
	else if( 0 != pid_daemon)                                            // 부모 프로세스 라면
	{
		exit( EXIT_SUCCESS );
	}

#endif
	umask( 0 );

	if( access( LOG_FILE, F_OK ) != 0 )
	{
		logFd = open( LOG_FILE, O_WRONLY | O_CREAT | O_APPEND );
		if( logFd < 0 )
		{
			printf( "ERR: open() Logfile(%d) failed.\n", LOG_FILE );
			exit( EXIT_FAILURE );
		}
		sprintf( writeBuf, "ACT\tACT_BY\tPID\tCOMMAND\t\t\tDATE\n" );
		write( logFd, writeBuf, strlen( writeBuf ) );
	}
	else
	{
		//logFd = open( LOG_FILE, O_WRONLY | O_TRUNC );
		logFd = open( LOG_FILE, O_WRONLY | O_CREAT | O_APPEND );
		if( logFd < 0 )
		{
			printf( "ERR: open() Logfile(%d) failed.\n", LOG_FILE );
			exit( EXIT_FAILURE );
		}
	}

	sid = setsid();	//	by jyhuh
	if( sid < 0 )
	{
		printf( "ERR: setsid() failed\n");
		exit( EXIT_FAILURE );
	}
//	if( chdir( "/" ) < 0 )
//	{
//		printf( "ERR: chdir() failed\n");
//		exit( EXIT_FAILURE );
//	}
//	close( STDIN_FILENO );
//	close( STDOUT_FILENO );
//	close( STDERR_FILENO );

	reg_child_signal();                                                  // child 시그널 등록
	read_task_list();                                                    // 실행할 정보 목록을 작성한다.

	while( 1 )
	{
		if( ( access( SHUTDOWN_FILE, F_OK ) != 0 ) && ( access( RESTART_FILE, F_OK ) != 0 ) \
				&& ( access( REBOOT_FILE, F_OK ) != 0 ) )
		{
			check_task_list();                                                // 작업 상태를 확인한다.
		}
		sleep( 1);                                                        // 1 초를 대기
	}
	close( logFd );
	exit( EXIT_SUCCESS );
}
