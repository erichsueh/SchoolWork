
#include <string.h>
#include <stdio.h>
 
int main(void)
{
    char input[] = "DRAWSegment 100.32 100 200 200";
    if (strncmp(input,"DRAWSegment",11)==0){
      //printf("Parsing the input string '%s'\n", input);
    char *token = strtok(input, " ");
    char str_output[10] ={0};
    strcpy(str_output, "drawSegment");
    while(token!= NULL) {
      if (strncmp(token, "DRAWSegment",11)!=0)
        {
        int test1 = atoi(token);
        printf("%d\n" ,test1);
        strcat(str_output, test1);
        }
	token = strtok(NULL," ");
    }
	printf("The output string is: %s", str_output);
    }
}

