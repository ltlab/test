/* =====================================================================
   File:	rtest.h
   Author:	Rammi
   Date:	5/28/1998

   License:	(This is the open source ISC license, see 
                 http://en.wikipedia.org/wiki/ISC_license 
                 for more info)

	 Copyright � 2010  Andreas M. Rammelt <rammi@hexco.de>

	 Permission to use, copy, modify, and/or distribute this software for any
	 purpose with or without fee is hereby granted, provided that the above
	 copyright notice and this permission notice appear in all copies.

	 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
	 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
	 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
	 ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
	 WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
	 ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
	 OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

   Content:	Testing of malloc library

   Last Change:	$Date: 2010/10/08 09:38:23 $

   History:     $Log: rtest.c,v $
   History:     Revision 1.3  2010/10/08 09:38:23  rammi
   History:     Clarified license to ISC license
   History:
   History:     Revision 1.2  2008/12/27 16:31:24  rammi
   History:     Added Test6 to check for calloc overflow.
   History:

   Pre-CVS history:
                5/18/1999
		Changed signal handling to avoid abort for machines
		which block signals while handling them.
   ===================================================================== */


#define MALLOC_DEBUG

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <signal.h>
#include <unistd.h>
#include <stdint.h>
#include "rmalloc.h"

#define TEST_SIZE	1000




/* ===============================================================
			IMPLEMENTATION
   =============================================================== */



/* =============================================================================
   Function:		Passed		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		The last "test" ending the program
   ============================================================================= */
static void Passed(void)
{
  fprintf(stderr,
	  "\n\n"
	  "------------------------------\n"
	  "All tests passed successfully.\n"
	  "------------------------------\n");
  _exit(0);
}



/* =============================================================================
   Function:		Test0		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		Allocate some stuff. Show statistics. The write
			anywhere past the end of a buffer and CRASH.
   ============================================================================= */
static void Test0(void)
{
  unsigned int u;
  int i;
  char *bla[TEST_SIZE];
  unsigned int count = TEST_SIZE;
  char *foo[20];

  memset(bla, 0, sizeof(bla));
  srand(time(NULL));

  while (count > 0) {
    u = (u + rand()) % TEST_SIZE;
    if (bla[u] == NULL) {
      bla[u] = strdup("abcdefg");
      assert(bla[u] != NULL);
      count--;
    }
  }

  RM_STAT;

  for (i = 0;   i < sizeof(foo)/sizeof(*foo);   i++) {
    foo[i] = strdup("0123456");
  }

  RM_STAT;

  for (i = TEST_SIZE-1;   i >= 0;   i--) {
    assert(strcmp(bla[i], "abcdefg") == 0);
    bla[i] = realloc(bla[i], 16);
    assert(bla[i] != NULL);
    strcpy(bla[i], "ABCDEFGHIJKLMNO");
  }

  RM_STAT;

  bla[0][19] = '?';		/* boo! from now on everything is corrupted */

  for (i = 0;   i < sizeof(foo)/sizeof(*foo);   i++) {
    free(foo[i]);
    foo[i] = strdup("6543210");
  }

  count = TEST_SIZE;
  while (count > 0) {
    u = (u + rand()) % TEST_SIZE;
    if (bla[u] != NULL) {
      assert(strcmp(bla[u], "ABCDEFGHIJKLMNO") == 0);
      free(bla[u]);
      bla[u] = NULL;
      count--;
    }
  }

  for (i = 0;   i < sizeof(foo)/sizeof(*foo);   i++) {
    free(foo[i]);
  }

}

/* =============================================================================
   Function:		Test1		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		Write string one byte to long and CRASH.
   ============================================================================= */
static void Test1(void)
{
  char *str = strdup("01");
  strcpy(str, "012");		/* wrong! */
  free(str);
}


/* =============================================================================
   Function:		Test2		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		Write string several bytes to long and CRASH.
   ============================================================================= */
static void Test2(void)
{
  char *str = strdup("0");
  strcpy(str, "012long");	/* wrong! */
  free(str);
}



/* =============================================================================
   Function:		Test3		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		Write a pointer array one entry to long and CRASH.
   ============================================================================= */
static void Test3(void)
{
  char **arr = malloc(1*sizeof(char *));
  char *bla = strdup("Kaputt!");

  arr[1] = bla;			/* wrong! */
  free(arr);			/* last chance to find */
  free(bla);
}



/* =============================================================================
   Function:		Test4		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		Allocate some complicated stuff, then free something
			twice and CRASH.
   ============================================================================= */
static void Test4(void)
{
  unsigned int u;
  int i;
  char *bla[TEST_SIZE];
  unsigned int count = TEST_SIZE;
  char *foo[20];
  void *pending;

  memset(bla, 0, sizeof(bla));
  srand(time(NULL));

  while (count > 0) {
    u = (u + rand()) % TEST_SIZE;
    if (bla[u] == NULL) {
      bla[u] = malloc(u+1);
      assert(bla[u] != NULL);
      count--;
    }
  }

  for (i = TEST_SIZE-1;   i >= 0;   i--) {
    bla[i] = realloc(bla[i], 2*i+2);
  }

  pending = bla[0];

  count = TEST_SIZE;
  while (count > 0) {
    u = (u + rand()) % TEST_SIZE;
    if (bla[u] != NULL) {
      free(bla[u]);
      bla[u] = NULL;
      count--;
    }
  }

  free(pending);
}



/* =============================================================================
   Function:		Test5		// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		---

   Purpose:		Free a pointer to nowhere and CRASH.
   ============================================================================= */
static void Test5(void)
{
  free((void *)0x12345678);
}

/* =============================================================================
   Function:		Test6		// local //
   Author:		Rammi
   Date:		12/27/2008

   Return:		---

   Parameter:		---

   Purpose:		Allocate too much memory in calloc()
   ============================================================================= */
static void Test6(void)
{
  void * m = calloc(SIZE_MAX/2, 3); // too much!
  free(m);
}


/* =============================================================================
   Function:		CatchAbort	// local //
   Author:		Rammi
   Date:		05/25/1998

   Return:		---

   Parameter:		signum    signal number

   Purpose:		Signal handler f�r signal SIGABRT.
			Dispatch through testing functions.

   Changes:		05/18/1999
                        Changed signal handling to sigaction.
   ============================================================================= */
static void CatchAbort(int signum)
{
  static void (*Test[])(void) = { /* test dispatching. step through these tests */
    Test0,
    Test1,
    Test2,
    Test3,
    Test4,
    Test5,
    Test6,

    Passed			/* this must stay the last */
  };
  static int TestNumber = 0;	/* test counter */

  extern void Rmalloc_reinit(void);

  struct sigaction action;

  action.sa_handler = CatchAbort;
  sigemptyset(&action.sa_mask);
  action.sa_flags = SA_RESETHAND | SA_NODEFER;

  sigaction(SIGABRT, &action, NULL);

  Rmalloc_reinit();
  if (TestNumber < (sizeof(Test)/sizeof(Test[0]) - 1)) {
    fprintf(stderr,
	    "\n\n"
	    "------------------\n"
	    "Running test %2d...\n"
	    "------------------\n",
	    TestNumber);
  }
  Test[TestNumber++]();		/* should not return! */
  fprintf(stderr, "Failed!\n");
  _exit(1);
}





/* =============================================================================
   Function:		main
   Author:		Rammi
   Date:		05/25/1998

   Return:		[does not return]

   Parameter:		[unused]

   Purpose:		As easy as can be. CatchAbort will do the work.
   ============================================================================= */
int main()
{
  CatchAbort(0);
  return 0;
}


