/*
Eric Hsueh
1384955
ehsueh
MWF 9-10
T Lab D02
*/
#include"draw1b.h"
/*Main function checks the validity of the file you're opening
 used the code from class as a guideline*/
int main(int argc, char*argv[])
{
  int i;
  FILE *fp;
  FILE* executable;
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
	executable = popen(exec_name, "w");
	if (executable == NULL)
	  fprintf(stderr,"Could not open pipe %s\n",exec_name);

	fileCheck(fp,argv[i], executable);
	fflush(executable);
	pclose(executable);
	fclose(fp);
      }
  }
    return(0);
}

/*
declaring variables
this function check the file line by line
and if it sees a word it recognizes, then it'll
increment the counter for that word
then prints all of it into standard output
 */
void fileCheck(FILE * fp, char *fname, FILE* executable){
  char line[LINE_LEN+1];
  char image[CHAR_LEN+1],name[CHAR_LEN+1];
  int intx,inty,shiftx,shifty,counter1,counter2,x,y;
  Imageholder container[16];
  int xaxis,yaxis,nextx,nexty;
  counter2 = 0;
  
  fprintf(stdout,"Input file: %s\n",fname);
  while (fgets(line,LINE_LEN+1,fp))
    {
      //fprintf(stdout,"%s",line);
      //comment lines printed out
      if (strncmp(line, "#", 1)== 0)
	fprintf(stdout,"%s",line);
      //Image lines delt with, initializes the struct
      else if (strncmp(line,"Image",5)==0)
	{
	  sscanf(line,"%s %s %d %d\n",image,name,&intx,&inty);
	  //fprintf(stdout,"%s %d %d\n",name,intx,inty);
	  counter1 = 0;
	  Imageholder mystruct;
	  (mystruct.xarray)[counter1] =lround(intx);
	  (mystruct.yarray)[counter1] =lround(inty);
	  counter1++;
	  //fprintf(stdout,"dicks");
	  while (fgets(line,LINE_LEN+1,fp))
	    {
	      //If line = End , then save stuct/variables used
	      if (strncmp(line,"End",3)==0)
		{
		  mystruct.counter = counter1;
		  mystruct.imgname = *name;
		  counter2++;
		  for (x=0;x != counter2;x++)
		    {
		      if (*name == container[x].imgname)
			{
			  container[x]= mystruct;
			  break;
			}
		      else if (x== counter2-1)
			{
			  //fprintf(stdout,"true");
			  container[counter2-1]=mystruct;
			}
		    }
		  break;
		}
	      // if line = LineTo, saved variables in int
	      else if (strncmp(line,"lineTo",6)==0)
		{
		  sscanf(line,"%s %d %d",image,&shiftx,&shifty);
		  intx = intx+shiftx;
		  inty = inty+shifty;
		  (mystruct.xarray)[counter1]=lround(intx);
		  (mystruct.yarray)[counter1]=lround(inty);
		  counter1 ++;
		}
	      else if (strncmp(line,"#",1)==0)
		fprintf(stdout,"%s",line);
	    }
	}
      //If it's the print, will print out to stdout by checking container
      else if (strncmp(line,"print",5)==0)
	{
	  sscanf(line,"%s %s\n",image,name);
	  fprintf(stdout,"Print Image%s = \n",name);
	  for (y=0;y != counter2+1;y++)
	    {
	      if (*name == container[y].imgname)
		{
		  //x=0;
		  //xaxis = (container[y].xarray)[x];
		  //yaxis = (container[y].yarray)[x];
		  //fprintf(stdout,"%d %d\n",xaxis,yaxis);
		  for (x=0;x!=container[y].counter;x++)
		    {
		      xaxis = (container[y].xarray)[x];
		      yaxis = (container[y].yarray)[x];
		      fprintf(stdout,"%d %d\n",xaxis, yaxis);
		    }
		  fprintf(stdout,"End Image %s\n",name);
		  break;
		}
	    }
	}
      //If its the translate command add 10 to every value to shift
      else if (strncmp(line,"translate",9)==0)
	{
          sscanf(line,"%s %s %d %d\n",image,name,&intx,&inty);
          for (y=0;y != counter2+1;y++)
            {
              if (*name == container[y].imgname)
                {
                  for (x=0;x!=container[y].counter;x++)
                    {
                      xaxis =(container[y].xarray)[x];
                      yaxis =(container[y].yarray)[x];
		      (container[y].xarray)[x]= xaxis+intx;
		      (container[y].yarray)[x]= yaxis+inty;
                      //fprintf(stdout,"%d %d\n",xaxis, yaxis);
                    }
                  break;
                }
            }
        }
      //draw access the structure and then prints out the code into java
      else if (strncmp(line,"draw",4)==0)
	{
	  sscanf(line,"%s %s\n",image,name);
          for (y=0;y != counter2+1;y++)
            {
              if (*name == container[y].imgname)
                {
		  if (container[y].counter != 1)
		    {
		      for (x=0;x!=container[y].counter -1;x++)
			{
			  xaxis = (container[y].xarray)[x];
			  yaxis = (container[y].yarray)[x];
			  nextx = (container[y].xarray)[x+1];
			  nexty = (container[y].yarray)[x+1];
			  fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
			}
		    }
                  break;
                }
            }
	}
      //child echo's the command to java without child
      else if (strncmp(line,"child",5)==0)
	{
	char *b = line+5;
	fprintf(executable,"%s",b);
	}
    }
}
