/*
Eric Hsueh
1384955
ehsueh
Class:MWF 9-10
Lab:Tuesday D02

This program take the input of a file, and then prints it out to
Sketchpad for it to draw lines
*/
/*the include files and defines*/
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<math.h>
#include<ctype.h>
#define LINE_LEN 1024
#define CHAR_LEN 16
#define IMAGE_NAME 128
#define _XOPEN_SOURCE
#define ARRAYSIZE 10

//Imageholder container[16];
//int counter2;

//void memclean(int count,Imageholder * contain);
void fileCheck(FILE* fp, char * fname, FILE* executable);
//void system();
FILE *popen(const char *command, const char *type);
int pclose(FILE *stream);
const char exec_name[]= "java -jar Sketchpad.jar";

typedef struct arrayholder
{
  char imgname;
  double *xarray;
  double *yarray;
  int strucarr;
  //double xarray[CHAR_LEN+1];
  //double yarray[CHAR_LEN+1];
  int counter;
}Imageholder;

void memclean(int count,Imageholder * contain);
