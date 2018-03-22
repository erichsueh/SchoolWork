/*
lab
 */

//Imageholder container[16];
//Imageholder container =malloc(sizeof(Imageholder)*10);
//int counter2 =0;
#include"memcleaner.c"
void memclean(int count,Imageholder * contain);

/*
declaring variables
this function check the file line by line
and if it sees a word it recognizes, then it'll
increment the counter for that word
then prints all of it into standard output
 */
void imagepro(FILE * fp, char *fname, FILE* executable){
  char theline[LINE_LEN+1];
  char *line;
  char image[CHAR_LEN+1],name[CHAR_LEN+1];
  int intx,inty,shiftx,shifty,counter1,counter2,x,y;
  //Imageholder container[16];
  int xaxis,yaxis, nextx,nexty;
  int returnvalue;
  int linenumber = 1;
  counter2 = 0;
  char endimage[CHAR_LEN+1];
  char randomvar1[CHAR_LEN+1];
  int arraysize;
  double rotate,rox,roy,nxaxis,nyaxis;
  int spacecounter;
  //char *newline;
  Imageholder *container; 
  int containersize;
  containersize = 1;
  container = malloc(sizeof(Imageholder)*containersize);
  fprintf(stdout,"Input file: %s\n",fname);
  while (fgets(theline,LINE_LEN+1,fp))
    {
      //fprintf(stdout,"%s",line);
      //comment lines printed out
      spacecounter = 0;
      for (x=0;isspace(theline[x]);x++)
	{
	}
      if (x>0)
	{
	  spacecounter = x;
	  //fprintf(stdout,"spacecounter = %d\n",spacecounter);
	  if ((spacecounter == 1))
	    {
	      if ((theline[x-1])=='\n')
		{
		  line = "loop";
		}
	      else
		{
		  char *newline = theline+x;
		  line = newline;
		}
	    }
	  else
	    {
	      //fprintf(stdout,"printplease %s",line);
	      char *newline  = theline+x;
	      line  = newline;
	      //fprintf(stdout,"%s",newline);
	    }
	}
      else
	{
	  line = theline;
	}
      //fprintf(stdout,"%s",line);
      if (strncmp(line, "#", 1)== 0)
	fprintf(stdout,"%s",theline);
      //Image lines delt with, initializes the struct
      else if (strncmp(line,"Image",5)==0)
	{
	  returnvalue = sscanf(line,"%s %s %d %d\n",image,name,&intx,&inty);
	  if (returnvalue<4)
	    {
	    fprintf(stderr,"line number %d, error\n",linenumber);
            memclean(counter2,container);  
	    exit(EXIT_FAILURE);
	    }
	  //fprintf(stdout,"%s %d %d\n",name,intx,inty);
	  counter1 = 0;
	  Imageholder mystruct;
	  //setting initial array to 10
	  mystruct.strucarr = 10;
	  //allocating array
	  arraysize = mystruct.strucarr;
	  (mystruct.xarray)= malloc(sizeof(double)*arraysize);
	  (mystruct.yarray)= malloc(sizeof(double)*arraysize);
	  
	  (mystruct.xarray)[counter1] =lround(intx);
	  (mystruct.yarray)[counter1] =lround(inty);
	  counter1++;
	  //fprintf(stdout,"dicks");
	  while (fgets(theline,LINE_LEN+1,fp))
	    {
	      spacecounter = 0;
	      for (x=0;isspace(theline[x]);x++)
		{
		}
	      if (x>0)
		{
		  spacecounter = x;
		  //fprintf(stdout,"spacecounter = %d\n",spacecounter);
		  if ((spacecounter == 1))
		    {
		      if ((theline[x-1])=='\n')
			{
			  line = "loops";
			}
		      else
			{
			  char *newline = theline+x;
			  line = newline;
			  
			}
		    }
		  else
		    {
		      //fprintf(stdout,"printplease %s",line);
		      char *newline  = theline+x;
		      line  = newline;
		      //fprintf(stdout,"%s",newline);
		    }
		}
	      else
		{
		  line = theline;
		}
	      //fprintf(stdout,"%s",line);
	      
	      //If line = End , then save stuct/variables used
	      linenumber++;
	      if (strncmp(line,"End",3)==0)
		{
		  returnvalue = sscanf(line,"%s %s %s",image,randomvar1,endimage);
		  if (returnvalue <3)
		    {
		      fprintf(stderr,"line number %d, error\n",linenumber);
		      memclean(counter2,container);
		      exit(EXIT_FAILURE);
		    }
		  if (*endimage != *name)
		    {
		      fprintf(stderr,"line number %d, error\n",linenumber);
		      memclean(counter2,container);
		      exit(EXIT_FAILURE);
		    }
		  if (counter2 == containersize)
		    {
		      containersize = containersize *2;
		      container = realloc(container,sizeof(Imageholder)*arraysize);
		      //fprintf(stdout,"realloc");
		    }

		  mystruct.counter = counter1;
		  mystruct.imgname = *name;
		  
		  if (counter2==0)
		    {
		      container[0]=mystruct;
		      counter2++;
		      break;
		    }
		  //counter2++;
		  for (x=0;x != (counter2);x++)
		    {
		      if (*name == container[x].imgname)
			{
			  //fprintf(stdout,"%d\n",container[x].imgname);
			  free (container[x].xarray);
			  free (container[x].yarray);
			  container[x]= mystruct;
			  //counter2= counter2-1;
			  break;
			}
		      else if (x == counter2-1)
			{
			  container[counter2]=mystruct;
			  counter2++;
			  break;
			}
		    }
		  //counter2++;
		  break;
		}
	      // if line = LineTo, saved variables in int
	      else if (strncmp(line,"lineTo",6)==0)
		{
		  returnvalue = sscanf(line,"%s %d %d",image,&shiftx,&shifty);
		  //fprintf(stdout,"%d\n",returnvalue);
		  if (returnvalue < 3)
		    {
		    fprintf(stderr,"line number %d, error\n",linenumber);
		    memclean(counter2,container);
		    exit(EXIT_FAILURE);
		    }
		  //realloc if too small
		  
		  if (counter1 == mystruct.strucarr)
		    {
		    arraysize = arraysize*2;
		    mystruct.xarray = realloc(mystruct.xarray,sizeof(double)*arraysize);
		    mystruct.yarray = realloc(mystruct.xarray,sizeof(double)*arraysize);
		    mystruct.strucarr = arraysize;
		    fprintf(stdout,"realloc\n");
		    }
		  
		  intx = intx+shiftx;
		  inty = inty+shifty;
		  (mystruct.xarray)[counter1]=lround(intx);
		  (mystruct.yarray)[counter1]=lround(inty);
		  counter1 ++;
		}
	      else if (strncmp(line,"#",1)==0)
		fprintf(stdout,"%s",theline);
	      else if (strncmp(line,"loop",4)==0)
		{
		  line = "loop";
		}
	      else
		{
		  fprintf(stderr,"line number %d, error\n",linenumber);
		  memclean(counter2,container);
		  exit(EXIT_FAILURE);
		}

	    }
	}
      //If it's the print, will print out to stdout by checking container
      else if (strncmp(line,"print",5)==0)
	{
	  returnvalue = sscanf(line,"%s %s\n",image,name);
	  if(returnvalue <2)
	    {
	      fprintf(stderr,"line number %d, error\n",linenumber);
	      memclean(counter2,container);
	      exit(EXIT_FAILURE);
	    }
	  fprintf(stdout,"Print Image%s = \n",name);
	  for (y=0;y != counter2;y++)
	    {
	      if (*name == container[y].imgname)
		{
		  //x=0;
		  //xaxis = (container[y].xarray)[x];
		  //yaxis = (container[y].yarray)[x];
		  //fprintf(stdout,"%d %d\n",xaxis,yaxis);
		  for (x=0;x!=container[y].counter;x++)
		    {
		      nxaxis = (container[y].xarray)[x];
		      nyaxis = (container[y].yarray)[x];
		      fprintf(stdout,"%lg %lg\n",nxaxis, nyaxis);
		    }
		  fprintf(stdout,"End Image %s\n",name);
		  break;
		}
	    }
	}
      //If its the translate command add 10 to every value to shift
      else if (strncmp(line,"translate",9)==0)
	{
          returnvalue = sscanf(line,"%s %s %d %d\n",image,name,&intx,&inty);
          if (returnvalue < 4)
	    {
	      fprintf(stderr,"line number %d, error\n",linenumber);
	      memclean(counter2,container);
	      exit(EXIT_FAILURE);
	    }
	  for (y=0;y != counter2;y++)
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
	  returnvalue = sscanf(line,"%s %s\n",image,name);
	  if (returnvalue < 2)
	    {
	      fprintf(stderr,"line number %d, error\n",linenumber);
	      memclean(counter2,container);
	      exit(EXIT_FAILURE);
	    }
          for (y=0;y != counter2;y++)
            {
	      //fprintf(stdout,"try");
              if (*name == container[y].imgname)
                {
		  if (container[y].counter != 1)
		    {
		      for (x=0;x!=container[y].counter -1;x++)
			{
			  xaxis = lround((container[y].xarray)[x]);
			  yaxis = lround((container[y].yarray)[x]);
			  nextx = lround((container[y].xarray)[x+1]);
			  nexty = lround((container[y].yarray)[x+1]);
			  fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
			}
		    }
                  break;
                }
            }
	}
      else if (strncmp(line,"rotate",6)==0)
        {
          returnvalue = sscanf(line,"%s %s %lf\n",image,name,&rotate);
          if (returnvalue < 3)
            {
              fprintf(stderr,"line number %d, error\n",linenumber);
              memclean(counter2,container);
              exit(EXIT_FAILURE);
            }
          for (y=0;y != counter2;y++)
            {
              //fprintf(stdout,"try");
              if (*name == container[y].imgname)
                {
                  if (container[y].counter != 1)
                    {
		      rotate = rotate * (3.141592653589/180);
                      for (x=0;x!=container[y].counter ;x++)
                        {
			  //rotate = rotate*(3.141592653589/180);
			  //fprintf(stdout,"rotate = %lf\n",rotate);
                          nxaxis = (container[y].xarray)[x];
                          nyaxis = (container[y].yarray)[x];
                          rox = (nxaxis*cos(rotate))-(nyaxis*sin(rotate));
                          roy = (nxaxis*sin(rotate))+(nyaxis*cos(rotate));
			  //fprintf(stdout,"%lg %lg\n",nxaxis,nyaxis);
			  //fprintf(stdout,"x,y 2nd = %lg %lg\n",rox,roy);
                          (container[y].xarray)[x]= rox;
			  (container[y].yarray)[x]= roy;
                        }
                    }
                  break;
                }
            }
        }
      else if (strncmp(line,"child",5)==0)
	{
	char *b = line+5;
	fprintf(executable,"%s",b);
	//fprintf(stdout,"%s\n",b);
	if (strncmp(b," end",4)==0)
	  {
	    //fprintf(stdout,"counter = %d\n",counter2);
	    memclean(counter2,container);
	    //return;
	  }
	}
      else if (strncmp(line,"loop",4)==0)
	{
	  line = "loop";
	}
      else
	{
	  fprintf(stdout,"%d\n",counter2);
	  memclean(counter2,container);
	  exit(EXIT_FAILURE);
	}
      linenumber++;
    }
  return;
}
