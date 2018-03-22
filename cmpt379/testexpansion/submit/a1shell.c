/*Eric Hsueh
Student Id: 1384955
This is my a1shell program
*/

/*Here are all my include files*/
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
#define MAXLINE 4096

/*Here is my error checking stuff, ie err_ret and err_do it etc*/
void err_ret(const char *, ...);
static void err_doit(int errnoflag, int error, const char *fmt, va_list ap)
{
  char buf[MAXLINE];
  vsnprintf(buf, MAXLINE-1, fmt, ap);
  if (errnoflag)
    snprintf(buf+strlen(buf), MAXLINE-strlen(buf)-1, ": %s",
	     strerror(error));
  strcat(buf, "\n");
  fflush(stdout);/* in case stdout and stderr are the same */
  fputs(buf, stderr);
  fflush(NULL);/* flushes all stdio output streams */
}

void err_ret(const char *fmt,...)
{
  va_list ap;
  va_start(ap, fmt);
  err_doit(1, errno, fmt, ap);
  va_end(ap);
  return;
}


void err_sys(const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  err_doit(1, errno, fmt, ap);
  va_end(ap);
  exit(1);
}

/************************************************************/
/*Here is where the main program starts*/

int main(int argc, char * argv[])
{
  char buf[MAXLINE];
  pid_t pid;
  int status;
  int interval;
  int setlimit;
  struct rlimit rl;
  /*this place sets the cpu limit so it dosn't run forever*/
  getrlimit (RLIMIT_CPU, &rl);
  setlimit = 10;
  printf("setting the limit to %d \n",setlimit);
  rl.rlim_cur = setlimit;
  setrlimit(RLIMIT_CPU, &rl);
  getrlimit(RLIMIT_CPU, &rl);
  printf("set lim to %ld \n",rl.rlim_cur);
  pid = fork();
  if (pid < 0)
    {
      err_sys("fork error");
    }
  else if (pid == 0)
    {
      /*a1monitor process starts here, this is where the child will continuousally print out its info*/
      FILE *fp;
      char buffer[255];
      time_t rawtime;
      char loadavg[255];
      struct tm * timeinfo;
      /* grabbed from here https://stackoverflow.com/questions/5141960/get-the-current-time-in-c */
      while(1==1)
	{
	  time ( &rawtime );
	  timeinfo = localtime ( &rawtime );
	  printf ( "\n%s", asctime (timeinfo) );
	  fp = fopen("/proc/loadavg", "r");
	  fscanf(fp, "%s", buffer);
	  strcpy(loadavg,buffer);
	  fscanf(fp, "%s", buffer);
	  strcat(loadavg," ");
	  strcat(loadavg,buffer);
	  fscanf(fp, "%s", buffer);
	  strcat(loadavg," ");
	  strcat(loadavg,buffer);
	  printf("Load average: %s \n", loadavg);
	  fscanf(fp, "%s", buffer);
	  printf("Processes: %s \n", buffer);
	  printf("a1shell%% ");
	  fclose(fp);
	  if (argc == 2)
	    {
	      interval = atoi(argv[1]);
	      sleep(interval);
	    }
	  else
	    {
	      exit(127);
	    }
	}
      exit(127);
    }
  else if (pid > 0)
    {
      printf("a1shell%% ");
      /*pid = wait(&status);*/
      /*a1shell process starts here this is where the parent will do its actual functions and programs*/
      while(fgets(buf, MAXLINE, stdin) != NULL)
	{
	  if (buf[strlen(buf) -1] = '\n')
	    {
	      buf[strlen(buf)-1] = 0;
	    }
	  if (strcmp(buf,"done") == 0)
	    {
	      /*kill the child and exit the program here is where the done function is implemented*/
	      kill(pid, SIGTERM);
	      exit(0);
	    }
	  else if (strcmp(buf,"pwd") ==0)
	    {
	      /*gets the current working directory here, this is where the pwd command is implemented*/
	      char cwd[1024];
	      if (getcwd(cwd, sizeof(cwd)) != NULL)
		{
		  printf("Current working dir: %s\n", cwd);
		}
	      else
		{
		printf("getcwd() error");
		}
	    }
	  else if (strcmp(buf,"umask") ==0)
	    {
	      /*gets the umask values in octal, this is where the umask is implemented*/
	      printf("Umask in Octal: %o \n",umask(S_IWGRP | S_IWOTH));
	      printf("Umask additonal values: %o \n",umask(S_IRWXU | S_IRWXG | S_IRWXO));
	    }
	  else if (buf[0] == 'c' && buf[1] =='d' && buf[2]==' ')
	    {
	      /*changes the directory here  this is where the changes in directory is implemented*/
	      if (buf[3]=='$')
		{
		  char* theenv;
		  theenv = getenv(buf+4);
		  /*printf("%s \n",theenv);*/
		  if (theenv == NULL)
		    {
		      printf("Error, no such directory found \n");
		    }
		  else
		    {
		      
		      int ret;
		      ret = chdir(theenv);
		      if (ret ==0)
			{
			  printf("Success, directory changed to: %s \n",theenv);
			}
		      else if (ret ==-1)
			{
			  printf("Changing directory failed, error no: %d \n",errno);
			}
		    }
		}
	      else
		{
		  int ret;
		  ret = chdir(buf+3);
		  if (ret ==0)
		    {
		      printf("Success, directory changed to: %s \n",buf+3);
		    }
		  else if (ret ==-1)
		    {
		      printf("Changing directory failed, error no: %d \n",errno);
		    }
		}
	    }
	  else
	    {
	      /*executes the cmd command here, this si the unrecognized command that we pass into a bash*/
	      pid_t pid1;
	      struct tms tmsstart, tmsend;
	      struct timespec timerstart;
	      struct timespec timerend;
	      clock_gettime(CLOCK_REALTIME, &timerstart);
	      times(&tmsstart);
	      if ((pid1 = fork()) <0)
		{
		err_sys("fork error");
		}
	      else if (pid1 == 0)
		{
		  if (execl("/bin/bash","bash", "-c", buf, (char *) 0) == -1)
		    {
		      exit(127);
		    }
		}
	      else
		{
		  pid1 = wait(&status);
		  /*printf("afterwait");*/
		  times(&tmsend);
		  int usertime = (tmsend.tms_utime - tmsstart.tms_utime);
		  int systemtime = (tmsend.tms_stime - tmsstart.tms_stime);
		  int childusertime = (tmsend.tms_cutime - tmsstart.tms_cutime);
		  int childsystemtime = (tmsend.tms_cstime - tmsstart.tms_cstime);
		  clock_gettime(CLOCK_REALTIME, &timerend);
		  int timerreal = timerend.tv_sec-timerstart.tv_sec;
		  printf("Real time:         %d \n",timerreal);
		  printf("User time:         %d \n",usertime);
		  printf("System time:       %d \n",systemtime);
		  printf("Child User Time:   %d \n",childusertime);
		  printf("Child System Time: %d \n",childsystemtime);
		}
	    }
	  
	  printf("a1shell%% ");
	  
	}
    }
  if ((pid = waitpid(pid, &status, 0)) <0)
    {
      err_sys("waitpid error");
    }
  exit(0);
}
