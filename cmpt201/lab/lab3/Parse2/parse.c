#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include "parse.h"

char program_name[PROG_LEN + 1];
const char exec_name[] = "java -jar Sketchpad.jar -d";
int shiftX; 
int shiftY;
char *pa,*pb;
int main(int argc, char* argv[])
{
  FILE* input;
  FILE* executable;

  memset(program_name, 0, PROG_LEN + 1);
  strncpy(program_name, argv[0], PROG_LEN);

  if (argc != 4) {
    fprintf(stderr, "Usage: %s input-file shiftX shiftY\n", program_name);
    exit(1);
  }

  input = fopen(argv[1], "r");

  if (input == NULL) {
    fprintf(stderr, "Could not open input file %s\n", argv[1]);
    exit(1);
  }
  pa =argv[2];
  shiftX = atoi(pa);
  
  pb =argv[3];
  shiftY = atoi(pb);
  fprintf(stdout,"%d %d \n",shiftX,shiftY);
  /*** Add code to extract the shift values from the command line ***/
  /*** arguments and set the shift values shiftX and shiftY ***/

  executable = popen(exec_name, "w");
  if (executable == NULL)
    fprintf(stderr, "Could not open pipe %s\n", exec_name);
  
  convert(input, executable);

  pclose(executable);
  fclose(input);

  return EXIT_SUCCESS;
}

// Read from input, convert and send the rows to executable 
void convert(FILE* input, FILE* executable)
{
  char command[LINE_LEN + 1];
  char line[LINE_LEN + 1];
  int  int1,int2,int3,int4;
  char str1[12];
  memset(line, 0, LINE_LEN + 1);
  memset(command, 0, LINE_LEN + 1);
  while (fgets(line, LINE_LEN + 1, input) != NULL)
  {
    if (strncmp(line, "drawSegment", 11) == 0) {
      fprintf(executable, "%s", line);  // print the original line
      //fprintf(stdout,"%s",line);
      sscanf(line,"%s %d %d %d %d", str1,&int1,&int2,&int3,&int4);
      int1 = int1+shiftX;
      int2 = int2+shiftY;
      int3 = int3+shiftX;
      int4 = int4+shiftY;
      fprintf(executable,"%s %d %d %d %d\n",str1,int1,int2,int3,int4);
      /*** Add code to shift the X and Y coordinates respectively by shiftX
           and shiftY (i.e. add shiftX to X and shiftY to Y) and draw 
           the shifted line ***/
      
    }
    else 
      fprintf(executable, "%s", line);

    memset(line, 0, LINE_LEN + 1);
    memset(command, 0, LINE_LEN + 1);
  }
}
