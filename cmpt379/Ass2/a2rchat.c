/*Eric Hsueh
Student ID: 1384955
This is my a2chat program
*/

/* Here are all my include files*/

#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdarg.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <sys/times.h>
#include <poll.h>
#define MAXLINE 4096
#define BUFFSIZE 4096
#define err(mess) { fprintf(stderr,"Error: %s.", mess); exit(1); }

int main(int argc, char * argv[])
{
  char buf[MAXLINE];
  int fd,clientopenfd,counter; 
  /*printf("%i",argc);*/
  /*THIS IS THE CLIENT PORTION OF THE CODE*/
  if (3 == argc)
    {
      if (strcmp(argv[1],"-c") ==0)
	{
	  char *name,snum[3],final[300];
	  printf("a2chat_client:");
	  counter = 0;
	  name = argv[2];
	  strcpy(final,name);
	  sprintf(snum, "%d",counter);
	  strcat(final,snum);
	  strcat(final,".in");
	  printf("%s \n",final);
	  while((fd = open(final, O_WRONLY)) < 0)
	    {
	      counter = counter + 1;
	      strcpy(final,name);
	      sprintf(snum, "%d",counter);
	      strcat(final,snum);
	      strcat(final,".in");
	      printf("%s \n",final);
	    }
	  strcpy(final,name);
	  sprintf(snum, "%d",counter);
	  strcat(final,snum);
	  strcat(final,".out");
	  if ( (clientopenfd = open(final, O_RDWR|O_NONBLOCK)) < 0)
		{
		  err("open");
		}
	  /*find fifo unlocked with same basename
	    connect to said fifo
	    run this loop
	    at the end of the loop, unlock said fifo
	    close*/
	  char buff[MAXLINE];
	  while(fgets(buf, MAXLINE, stdin) != NULL)   
	    {
	      if ( write(fd, buf, strlen(buf))== -1)
		{
		  err("write");
		}
	      read(clientopenfd, buff, sizeof(buff));
	      printf("buff  %s",buff);
	      
	    }
	  close(fd);
	}
    }
  /*THIS IS THE SERVER PORTION OF THE CODE*/
  else if (4 == argc)
    {
      if (strcmp(argv[1],"-s") ==0)
	{
	  /*create fifo's with the base name in a loop to the max #*/
	  int a,nclient,outies[nclient];
	  char *name,snum[3],final[300];
	  nclient = atoi(argv[3]);
	  struct pollfd fds[nclient];
	  name = argv[2];
	  /*creating clients here*/
	  for(a=0; a<nclient ;a= a+1)
	    {
	      strcpy(final,name);
	      sprintf(snum, "%d",a);
	      strcat(final,snum);
	      strcat(final,".in");
	      printf("%s \n",final);
	      mkfifo(final,0666);
	      if ( (fd = open(final, O_RDWR|O_NONBLOCK)) < 0)
		{
		  err("open");
		}
	      fds[a].fd = fd;
	      fds[a].events = POLLIN;
	    }
	  for(a=0; a<nclient ;a= a+1)
	    {
	      strcpy(final,name);
	      sprintf(snum, "%d",a);
	      strcat(final,snum);
	      strcat(final,".out");
	      printf("%s \n",final);
	      mkfifo(final,0666);
	      /*if ( (fd = open(final, O_WRONLY|O_NONBLOCK)) < 0)
		{
		  err("open");
		}
		  outies[a] = fd;*/
	    }
	  
	  printf("Chat server begins [nclient = %s]",argv[3]); 
	  int ret,n,b,sfd;
	  int ret_poll,fd_poll; ssize_t ret_read;
	  char buff[MAXLINE];
	  struct pollfd input[1] = {{fd: 0, events: POLLIN}};
	  while(1)
	    {
	      /*poll here*/
	      ret_poll = poll(input, 2, 1);
	      fd_poll = poll(fds, nclient, 1);
	      /*printf("startpollhere, retpoll = %i fd_poll = %i \n",ret_poll,fd_poll);*/
	      if (fd_poll > 0)
		{
		  for (b=0; b<nclient ; b = b+1)
		    {
		      if (fds[b].revents & POLLIN)
			{
			  n = read(fds[b].fd, buff, sizeof(buff));
			  printf("buff  %s",buff);
			  strcpy(final,name);
			  sprintf(snum, "%d",b);
			  strcat(final,snum);
			  strcat(final,".out");
			  printf("%s \n",final);
			  /*open, write, close*/
			  sfd = open(final, O_WRONLY);
			  write(fd, buff, strlen(buff));
			  close(fd);
			}
		    }
		}
	      
	      if (ret_poll == 1 & POLLIN)
		{
		  n = read(input[1].fd, buff, sizeof(buff));
		  printf("POLLIN n=%d buf=%.*s\n", n, n, buff);
		  printf("Im this thing occasionally exits, sometimes doesn't will fix later %d   ",strcmp(buff,"exit\n"));
		  if (strcmp(buff,"exit\n") ==0)
		    {
		      printf("EXITING");
		      exit(0);
		    }
		  if (strcmp(buff,"exit") == 0)
		    {
		      printf("exiting");
		      exit(1);
		    }
		  /*input[1] = {fd: 0, events: POLLIN};*/
		}
	    }
	      /*if ( write(STDOUT_FILENO, buf, n) != n)
		{
		  exit(1);
	        }*/
	}
    } 
}
