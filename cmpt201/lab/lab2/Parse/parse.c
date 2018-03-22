/* name:               Neil Burch
 * ONE Card number:    9999999
 * Unix id:            burch
 * lecture section:    A1
 * lab section:        D01
 * TA's name:          Your TAName
 *
 *  Reads input meant for sketchpad.pl, except the instructions have incorrect
 *  case.  Specifically, it reads instructions in the first column and
 *  converts them to the instructions in the second column
 *
 *  Read from input file (1st col.)             Convert to this (2nd col.)
 *  ==============================              =========================
 *  CLEARscreen                                 clearScreen
 *  Pause n                                     pause n_r
 *  END                                         end
 *  DRAWSegment x1 y1 x2 y2                     drawSegment x1_r y1_r x2_r y2_r
 *
 *  The DRAWSegment/drawSegment command is not handled; you will need to add
 *  this code.
 *
 *  Also, numbers in the input file (n, x1, y1, x2, y2) are floating
 *  point, and can be stored as doubles.  Send to filter the rounded
 *  versions of these numbers (n_r, x1_r, y1_r, x2_r, y2_r), which can
 *  be stored as longs.   Do the rounding with lround. (You need to
 *  implement this for DRAWSegment/drawSegment numbers.)
 *
 *  Note, for Assignment 1, you will be reading in different input; this sample
 *  code only uses similar tools, but the input it reads is very different.
 */

/* we want popen/pclose and lround, which are not in standard C
   but are part of the XOPEN POSIX standard for UNIX systems */
#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "parse.h"


/* Global variable definitions. */

/* The name of this program (i.e it's executable, from argv[0]). */
char program_g[PROG_LEN + 1];

/* The name and path of the executable to send information to. */
const char Exec_name[] = "java -jar Sketchpad.jar -d";

/*
 * It expects one argument.  Opens both the input file and the pipe (could be
 * separated in two functions ... subjective).
 *
 * Calls the convert function to deal with the input.
 */
int main(int argc, char* argv[])
{
  FILE* input;
  FILE* executable;

  memset(program_g, 0, PROG_LEN + 1);
  strncpy(program_g, argv[0], PROG_LEN);

  if (argc != NUM_ARGS + 1)
    print_err("Number of command line arguments incorrect", NULL);

  input = fopen(argv[1], "r");
  if (input == NULL)
    print_err("Could not open input file", argv[1]);

  executable = popen(Exec_name, "w");
  if (executable == NULL)
    print_err("Could not open pipe", Exec_name);

  convert(input, executable);

  if (pclose(executable) == PCLOSE_ERR)
    print_err("Could not close pipe", Exec_name);

  if (fclose(input) == EOF)
    print_err("Could not close input file", argv[1]);

  return EXIT_SUCCESS;
}

/*
 * Reads from input, converts appropriately, and sends instructions to
 * executable.
 *
 * See comment above for more information.
 *
 * Assumes there are no errors in the input file.
 *
 * Called from main.
 */
void convert(FILE* input, FILE* executable)
{
  char command[LINE_LEN + 1];
  char line[LINE_LEN + 1];
  double time_read;
  double number[4];
  long time_sent;

  char drawseg[11];
  int numberlist[4];
  /* will want to add some variables, likely here */

  memset(line, 0, LINE_LEN + 1);
  memset(command, 0, LINE_LEN + 1);
  while (fgets(line, LINE_LEN + 1, input) != NULL)
  {
    /*
     * You can forgo macros here, as, unless combined with string literals, will
     * make things confusing and tough to maintain (ideal to use macros and
     * string literals, though, in some peoples' opinions).
     *
     * Assumes there is no leading whitespace.
     */
    if (strncmp(line, "CLEARscreen", 11) == 0)
      fprintf(executable, "clearScreen\n");
    else if (strncmp(line, "END", 3) == 0)
      fprintf(executable, "end\n");
    else if ( sscanf(line, "%s%lf", command, &time_read) == 2 &&
              strncmp(command, "Pause", PAUSE_LEN + 1) == 0
            )
    {
      time_sent = lround(time_read);
      fprintf(executable, "pause %ld\n", time_sent);
    }
    else if (strncmp(line, "DRAWSegment", 11)==0){
      scanf(line, "%s %lf %lf %lf %lf", drawseg, &number[0],&number[1],&number[2],&number[3]
	    for (i=0,i >4, i++){
	      numberlist[i]= lround(number[i]);
	    }
	    fprintf(executable," %d %d %d %d\n" ,numberlist[0],numberlist[1],numberlist[2],numberlist[3]);
	    }
    /* Add code to handle DRAWSegment/drawSegment here.  Style does not matter.
     */

    memset(line, 0, LINE_LEN + 1);
    memset(command, 0, LINE_LEN + 1);
  }

  /* What two things could fgets returning NULL mean? */
  if (ferror(input) != 0)
    print_err("Error reading from pipe", Exec_name);

}

/*
 * Called on an error.  Prints msg, preceded by program, and prints file_name
 * if file_name is not NULL.
 *
 */
void print_err(const char msg[], const char file_name[])
{
  fprintf(stderr, "%s:  %s", program_g, msg);
  if (file_name != NULL)
    fprintf(stderr, ", %s", file_name);
  fprintf(stderr, "\n");
  exit(EXIT_FAILURE);
}
