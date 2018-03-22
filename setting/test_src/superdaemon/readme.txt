prj name  : superdaemon - 등록된 프로그램을 실행 및 관리
descript  :

          superdaemon.ini 에 등록된 프로그램을 실행하고
          프로그램 종료를 계속 확인하면서,
          종료되면 지정된 시간 후 다시 실행하게 한다.
version :
          0.0.1   superdaemon.ini 에 등록된 프로그램을 실행
          0.0.2   execl() 사용하여 구성
          0.0.3   1. 
                    execl() 을 execv() 로 재 구성
                    ref
                        execl() 은 인수가 ( )
                  2.
                    실행파일 정보 문자열에 이상이 없을 때에만
                    fork() 실행하도록 수정
          1.0.0   1.
                    파일을 실행할 때, 파일의 존재 유무를 확인하는
                    코드를 추가
                  2.
                    환경 파일에서 경로명에 '/' 이 없을 때 발생하던
                    오류를 잡음
                                      

                                                                      장길석, jwjwmx@gmail.com
    
