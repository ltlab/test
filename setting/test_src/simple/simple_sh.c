/*****************************************************************************
  @file         main.c
  @author       Stephen Brennan
  @date         Thursday,  8 January 2015
  @brief        LSH (Libstephen SHell)
******************************************************************************/

#include <sys/wait.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <assert.h>


#ifndef SH_NAME
#define SH_NAME       "lsh"
#endif	//	SH_NAME

/*
   Function Declarations for builtin shell commands:
   */
int do_cd(char **args);
int do_test(char **args);
int do_help(char **args);
int do_exit(char **args);

/*
   List of builtin commands, followed by their corresponding functions.
   */
typedef int ( *pFnBuiltinFunc ) (char **);

typedef struct BUILTIN_FN_PAIR_S
{
	const char				*name;
	const pFnBuiltinFunc	function;
} BUILTIN_FN_PAIR;

const BUILTIN_FN_PAIR s_builtinFuncPair[] = {
	{ "cd", do_cd },
	{ "test", do_test },
	{ "help", do_help },
	{ "exit", do_exit },
};

int sh_num_builtins() {
	return sizeof( s_builtinFuncPair ) / sizeof( BUILTIN_FN_PAIR );
}

/*
   Builtin function implementations.
   */

/**
  @brief Bultin command: change directory.
  @param args List of args.  args[0] is "cd".  args[1] is the directory.
  @return Always returns 1, to continue executing.
  */
int do_cd(char **args)
{
	if (args[1] == NULL) {
		fprintf(stderr, SH_NAME ": expected argument to \"cd\"\n" );
	} else {
		if (chdir(args[1]) != 0) {
			perror( SH_NAME );
		}
	}
	return 1;
}

int do_test(char **args)
{
	int i;

	assert( *args );

	for( i = 1 ; args[ i ] != NULL; i++  )
	{
		printf( SH_NAME ": args[ %d ]: \'%s\'\n", i, args[ i ] );
	}
	return 1;
}

/**
  @brief Builtin command: print help.
  @param args List of args.  Not examined.
  @return Always returns 1, to continue executing.
  */
int do_help(char **args)
{
	int i;
	printf("Stephen Brennan's LSH\n");
	printf("Type program names and arguments, and hit enter.\n");
	printf("The following are built in:\n");

	for (i = 0; i < sh_num_builtins(); i++) {
		printf("  %s\n", s_builtinFuncPair[ i ].name );
	}

	printf("Use the man command for information on other programs.\n");
	return 1;
}

/**
  @brief Builtin command: exit.
  @param args List of args.  Not examined.
  @return Always returns 0, to terminate execution.
  */
int do_exit(char **args)
{
	return 0;
}

/**
  @brief Launch a program and wait for it to terminate.
  @param args Null terminated list of arguments (including program).
  @return Always returns 1, to continue execution.
  */
int sh_launch(char **args)
{
	pid_t pid;
	int status;

	pid = fork();
	if (pid == 0) {
		// Child process
		if (execvp(args[0], args) == -1) {
			perror( SH_NAME );
		}
		exit(EXIT_FAILURE);
	} else if (pid < 0) {
		// Error forking
		perror( SH_NAME );
	} else {
		// Parent process
		do {
			waitpid(pid, &status, WUNTRACED);
		} while (!WIFEXITED(status) && !WIFSIGNALED(status));
	}

	return 1;
}

/**
  @brief Execute shell built-in or launch program.
  @param args Null terminated list of arguments.
  @return 1 if the shell should continue running, 0 if it should terminate
  */
int sh_execute(char **args)
{
	int i;

	if (args[0] == NULL) {
		// An empty command was entered.
		return 1;
	}

	for (i = 0; i < sh_num_builtins(); i++) {
		if (strcmp( args[0], s_builtinFuncPair[ i ].name) == 0) {
			return s_builtinFuncPair[ i ].function( args );
		}
	}

	return sh_launch(args);
}

#define READLINE_BUFSIZE 64
/**
  @brief Read a line of input from stdin.
  @return The line from stdin.
  */
char *sh_read_line(void)
{
	int bufsize = READLINE_BUFSIZE;
	int position = 0;
	char *buffer = malloc(sizeof(char) * bufsize);
	int c;

	if (!buffer) {
		fprintf(stderr, SH_NAME ": allocation error\n");
		exit(EXIT_FAILURE);
	}

	while (1) {
		// Read a character
		c = getchar();

		if (c == EOF) {
			exit(EXIT_SUCCESS);
		} else if (c == '\n') {
			buffer[position] = '\0';
			return buffer;
		} else {
			buffer[position] = c;
		}
		position++;

		// If we have exceeded the buffer, reallocate.
		if (position >= bufsize) {
			bufsize += READLINE_BUFSIZE;
			buffer = realloc(buffer, bufsize);
			//printf( "INFO: realloc: %d => %d\n", position, bufsize );
			if (!buffer) {
				fprintf(stderr, SH_NAME ": allocation error\n");
				exit(EXIT_FAILURE);
			}
		}
	}
}

#define TOK_BUFSIZE 64
#define TOK_DELIM " \t\r\n\a"
/**
  @brief Split a line into tokens (very naively).
  @param line The line.
  @return Null-terminated array of tokens.
  */
char **sh_split_line(char *line)
{
	int bufsize = TOK_BUFSIZE, position = 0;
	char **tokens = malloc(bufsize * sizeof(char*));
	char *token, **tokens_backup;

	if (!tokens) {
		fprintf(stderr, SH_NAME ": allocation error\n");
		exit(EXIT_FAILURE);
	}

	token = strtok(line, TOK_DELIM);
	while (token != NULL) {
		tokens[position] = token;
		position++;

		if (position >= bufsize) {
			bufsize += TOK_BUFSIZE;
			tokens_backup = tokens;
			tokens = realloc(tokens, bufsize * sizeof(char*));
			if (!tokens) {
				free(tokens_backup);
				fprintf(stderr, SH_NAME ": allocation error\n");
				exit(EXIT_FAILURE);
			}
		}

		token = strtok(NULL, TOK_DELIM);
	}
	tokens[position] = NULL;
	return tokens;
}

/**
  @brief Loop getting input and executing it.
  */
void sh_loop(void)
{
	char *line;
	char **args;
	int status;

	do {
		printf( SH_NAME " # " );
		line = sh_read_line();
		args = sh_split_line(line);
		status = sh_execute(args);

		free(line);
		free(args);
	} while (status);
}

/**
  @brief Main entry point.
  @param argc Argument count.
  @param argv Argument vector.
  @return status code
  */
int main(int argc, char **argv)
{
	// Load config files, if any.

	// Run command loop.
	sh_loop();

	// Perform any shutdown/cleanup.

	return EXIT_SUCCESS;
}
