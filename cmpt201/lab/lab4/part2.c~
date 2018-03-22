#include<stdio.h>
#include<string.h>
#define LINE_LEN 1024
#define numb_len 3
void reversenumb(FILE * fp, char * fname);

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
	reversenumb(fp,argv[i]);
	
	fclose(fp);
      }
  }
    return(0);
}
void reversenumb(FILE * fp, char *fname){
  char line[LINE_LEN+1];
  char numberarray[100];
  int int1, i;
  i = 0;
  while (fgets(line,LINE_LEN+1,fp))
    {
      sscanf(line,"%d\n",&int1);
      numberarray[i] = int1;
      i = i+1;
      //fprintf(stdout,"%s",numberarray);
    }
  for (i = i-1;i!=-1;i = i-1){
    int1=numberarray[i];
    fprintf(stdout,"%d\n",int1);
  }

}
