#include  <stdio.h>
#include  <stdlib.h>
#include  <string.h>
#include  "projectinc.h"

//--------------------------------------------------------------------
// desc   문자열에서 /t /n /f 와 같은 화이트 문자를 NULL 코드로
//        바꾸어 준다. 
//--------------------------------------------------------------------
void remove_white_char( char *_str)
{
  int   ndx;
  
  for ( ndx = 0; ndx < strlen(_str); ndx++)
  {
    if (' ' > _str[ndx])
    {
      _str[ndx] = '\0';
    }
  }
}

//--------------------------------------------------------------------
// desc   메시지를 전송하고 실행을 중지한다.
//--------------------------------------------------------------------
void error_handling(char *message)
{
  fputs( message, stderr);
  fputc( '\n', stderr);
  exit(1);
}


