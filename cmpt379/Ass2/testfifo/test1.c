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


int main(int argc, char * argv[])
{
  int  len;
  char buf[80];
  while(1)
    {
      memset(buf, 0, sizeof(buf));
      len= read(STDIN_FILENO, buf, sizeof(buf));
      write(STDOUT_FILENO, buf, strlen(buf));
      if (strstr(buf, "exit") != NULL){
	exit(0);
      }
    }
}
