#ifndef MAIN_H
#define MAIN_H

#include  <sys/types.h>

#define   TRUE                1
#define   FALSE               0
                              
#define   ERR_NONE            0
#define   ERR_PATH_TOO_LONG   -1
#define   ERR_EXE_TOO_LONG    -2
#define   ERR_PARAMS_TO0_LONG -3;
#define   ERR_TOO_MANY_PARAMS -4;
#define   ERR_EXECUTE         -5;

typedef struct
{
  char *full_filename;
  char *params[20];
  int   interval;
  int   count_down;
  int   error;
  pid_t pid;
} task_t;

                                  
#endif
