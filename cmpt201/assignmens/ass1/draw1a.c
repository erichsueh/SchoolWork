/*
Eric Hsueh
1384955
This program takes the input and then counts how many commands are shown
then it prints it out in the standard output
*/
/*the include files and defines*/
#include<stdio.h>
#include<string.h>
#include<unistd.h>
#define LINE_LEN 1024
void fileCheck(FILE * fp, char * fname);
void system();
/*Main function checks the validity of the file you're opening
 used the code from class as a guideline*/
int main(int argc, char*argv[])
{
  int i;
  FILE *fp;
  for (i = 1; i< argc; i++){
    fp = fopen(argv[i],"r");
    if (fp == NULL)
      {
	printf("Couldn't open file %s\n",argv[i]);
      }
    else
      {
	/*if the file is valid, do work*/
	fprintf(stdout,"%s started on ",argv[0]);
	
	fflush(stdout);
	system("date");
	fileCheck(fp,argv[i]);
	
	fclose(fp);
      }
  }
    return(0);
}

/*
declaring variables
this function check the file line by line
and if it sees a word it recognizes, then it'll increment the counter for that word
then prints all of it into standard output
 */
void fileCheck(FILE * fp, char *fname){
  char line[LINE_LEN+1];
  int imagenumb;
  int linetonumb;
  int endnumb;
  int printnumb;
  int drawnumb;
  int translatenumb;
  int childnumb;
  int commentnumb;
  commentnumb = 0;
  childnumb = 0;
  translatenumb = 0;
  drawnumb = 0;
  printnumb = 0;
  endnumb = 0;
  linetonumb = 0;
  imagenumb = 0;

  while (fgets(line,LINE_LEN+1,fp))
    {
      if (strncmp(line, "#", 1)== 0)
	commentnumb = commentnumb + 1;
      else if (strncmp(line,"Image",5)==0)
	imagenumb = imagenumb + 1;
      else if (strncmp(line,"lineTo",6)==0)
	linetonumb = linetonumb +1;
      else if (strncmp(line,"End",3)==0)
	endnumb = endnumb +1;
      else if (strncmp(line,"print",5)==0)
	printnumb = printnumb+1;
      else if (strncmp(line,"draw",4)==0)
	drawnumb = drawnumb +1;
      else if (strncmp(line,"translate",9)==0)
	translatenumb = translatenumb+1;
      else if (strncmp(line,"child",5)==0)
	childnumb = childnumb +1;
    }
  fprintf(stdout, "Input file: %s\n",fname );
  fprintf(stdout, "%d Image definition(s)\n",imagenumb );
  fprintf(stdout, "%d lineTo command(s) within Figures\n",linetonumb );
  fprintf(stdout, "%d End command(s)\n",endnumb );
  fprintf(stdout, "%d print command(s)\n",printnumb );
  fprintf(stdout, "%d draw command(s)\n",drawnumb );
  fprintf(stdout, "%d translate command(s) \n",translatenumb );
  fprintf(stdout, "%d child commands(s) \n",childnumb );
  fprintf(stdout, "%d comments(s) \n",commentnumb );
}
