
/*Eric Hsueh
Student ID: 1384955
This is my a3chat program

Things to be done
keepalive
proper printing of the thing(alarm)
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
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <netdb.h>
#include <signal.h>
#define MAXLINE 4096
#define BUFFSIZE 4096
#define MAXBUF 4096
#define err(mess) { fprintf(stderr,"Error: %s.", mess); exit(1); }
#define KAL_char     0x6    // A non-printable character (e.g., ACK)
#define KAL_length   5      // Number of KAL_char in one keepalive message
#define KAL_interval 1.5    // Client sends a keepalive message every 1.5 seconds
#define KAL_count    5      // Number of consecutive keepalive messages that needs
                            // to be missed for the server to consider that the client
                            // has terminated unexpectedly
struct activity
{
  int ifd;//which fd
  char name[40];//name
  char date[100];
  int used;
};
struct activity activities[100];

int globalactrack =1;
void  ALARMhandler(int sig)
{
  int count;
  signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
  printf("Activity Report:");
  for(count = 0;count<= 100;count = count +1)
    {
      if (activities[count].used != 404)
	{
	  break;
	}
      else
	{
	  printf("'%s' [sockfd =%i]: %s\n",activities[count].name,activities[count].ifd,activities[count].date);
	}
    }
  signal(SIGALRM, ALARMhandler);     /* reinstall the handler    */
  alarm(15);
}


int main(int argc, char * argv[])
{
  char buf[MAXLINE];
  int fd,clientopenfd,counter;
  int conindicator;
  conindicator = 0;
  
  if ((strcmp(argv[1],"-c") ==0) && (argc ==4))
    {
      /*printf("a3chat_client:");*/
      /*this is the client portion of the code */
      /*declare stuff*/
      struct pollfd input[1] = {{fd: 0, events: POLLIN,revents: 0}};
      int ret_poll, n, myport, s, i, rval;
      char buff[MAXLINE], pidstr[MAXLINE];
      char buf[MAXBUF];
      struct hostent *hp;
      struct sockaddr_in server;
      printf("argv[2] = %s\n",argv[2]);
      myport = atoi(argv[2]);
      FILE * sfp;
      struct pollfd pfd[1] = {{fd:-1, events: POLLIN, revents:0}};
      printf("a3chat_client:");
      fflush(stdout);
      while(1)
	{
	  rval = poll(pfd,1,0);
	  if (rval == -1)
	    {
	      printf("%d",errno);
	    }
	  ret_poll = poll(input,1,0);
	  
	  if (conindicator == 1)
	    {
	      /*poll here for server response*/
	      /*printf("aoeijfoaej\n");*/
	      /*rval = poll(pfd,2,0);*/
	      if (pfd[0].revents & POLLIN)
		{
		  /*printf("get event\n");*/
		  memset(buf, 0, sizeof(buf));
		  if (recv(s,buf,MAXBUF,MSG_DONTWAIT)<= 0)
		    {
		      /*printf("%i",errno);*/
		    }
		  else
		    {
		      printf("%s",buf);
		    }
		  /*
		  if (fgets(buf, MAXBUF, sfp) != NULL)
		    {
		      printf("%s", buf);
		      fflush(stdout);
		      }*/
		}
	    }
	  /*ret_poll = poll(input,1,0);*/
	  if (ret_poll >=1 && (input[0].revents &POLLIN))
	    {
	      memset(buff, 0, sizeof(buff));
	      n = read(input[0].fd, buff, sizeof(buff));
	      /*printf("command:%s\n",buff);*/
	      if (strcmp(buff,"exit\n") == 0)
		{
		  printf("exiting\n");
		  if (conindicator == 1)
		    {
		      /*write(s, pidstr, strlen(pidstr));*/
		      write(s, buff, strlen(buff));
		    }
		  exit(1);
		}
	      else if (strcmp(buff,"close\n")== 0)
		{
		  printf("close\n");
		  if (conindicator == 1)
		    {
		      /*write(s, pidstr, strlen(pidstr));*/
		      write(s, buff, strlen(buff));
		    }
		  conindicator = 0;
		}
	      else if ((buff[0]=='o')&& buff[1]=='p' && buff[2]=='e' && buff[3]=='n'&&(conindicator ==0))
		{
		  printf("getting argv[3] = %s \n",argv[3]);
		  hp= gethostbyname(argv[3]);
		  if (hp == (struct hostent *) NULL) {
		    fprintf (stderr, "%s: gethostbyname ('%s') \n", argv[0], argv[3]);
		    exit (1);
		  }
		  memset ((char *) &server, 0, sizeof server);
		  memcpy ((char *) &server.sin_addr, hp->h_addr, hp->h_length);
		  server.sin_family= hp->h_addrtype;
		  printf("my port = %i",myport);
		  server.sin_port= htons(myport);

		  s= socket(hp->h_addrtype, SOCK_STREAM, 0);
		  if (s < 0) {
		    fprintf (stderr, "%s: socket \n", argv[0]);
		    exit (1);
		  }
		  
		  if (connect(s, (struct sockaddr *) &server, sizeof server) < 0) {
		    fprintf (stderr, "%s: connect\n", argv[0]);
		    exit (1);
		  }

		  if ((sfp= fdopen(s, "r+")) < 0) {
		    fprintf (stderr, "%s: converting s to FILE* \n", argv[0]);
		    exit (1);
		  }
		  sprintf(pidstr, "%d: ", getpid());
		  /*writing client pid into socket?*/
		  printf("opened\n");
		  pfd[0].fd= s;
		  pfd[0].events= POLLIN;
		  pfd[0].revents= 0;
		  conindicator = 1;
		  if (conindicator == 1)
		    {
		      /*write(s, pidstr, strlen(pidstr));*/
		      write(s, buff, strlen(buff));
		    }
		  
		}
	      else
		{
		  /*if it goes through, just send command to s*/
		  if (conindicator == 1)
		    {
		      /*write(s, pidstr, strlen(pidstr));*/
		      write(s, buff, strlen(buff));
		    }
		}
	      printf("a3chat_client:");
	      fflush(stdout);
	      /*printf("a3chat_client:");*/
	    }
	}/*end of loop for polling client*/
    }/*close for client portion if*/


  
  else if ((strcmp(argv[1],"-s") == 0) && (argc == 4))
    {
      int s;
      struct sockaddr_in sin;
      char buf[MAXBUF];
      /* creatiemanageing socket*/
      s= socket (AF_INET, SOCK_STREAM, 0);
      if (s < 0) {
	fprintf (stderr, "%s: socket \n", argv[0]);
	exit (1);
      }
      signal(SIGALRM, ALARMhandler);
      int myport , N, clientlimit, timeout, rval, fromlen;
      myport = atoi(argv[2]);
      clientlimit = atoi(argv[3]);
      struct pollfd pfd[clientlimit+1];
      struct sockaddr_in from;
      int newsock[clientlimit+1];
      FILE *sfp[clientlimit+1];
      /*bind managing socket to name*/
      sin.sin_family= AF_INET;
      sin.sin_addr.s_addr= htonl(INADDR_ANY);
      sin.sin_port= htons(myport);
      if (bind (s, (struct sockaddr *) &sin, sizeof sin) < 0) {
	fprintf (stderr, "%s: bind \n", argv[0]);
	exit (1);
      }
      
      /* indicate how many connection requests can be queued */
      listen (s, 5);

      /* prepare for nonblocking I/O polling from the master socket  */
      timeout=  0;
      pfd[0].fd= s;
      pfd[0].events= POLLIN;
      pfd[0].revents= 0;
      int zero;
      int inuse[clientlimit];
      char nameArray[clientlimit][40];
      int toarray[clientlimit][clientlimit];
      int d;
      int p;
      for (d=0; d< clientlimit; d= d+1)
	{
	  for (p=0; p < clientlimit; p=p+1)
	    {
	      toarray[d][p] = 0;
	    }
	}	
      for (d=0; d <clientlimit; d=d+1)
	{
	  strcpy(nameArray[d],"0");
	}
      memset(inuse, 0, sizeof(int)*clientlimit);
      N = 1;/* N descriptors to poll */
      alarm(2);
      struct pollfd input[1] = {{fd: 0, events: POLLIN,revents: 0}};
      int ret_poll;
      char buff[MAXLINE];
      int n;
      while (1)
	{
	  rval= poll (pfd, N, timeout);
	  ret_poll = poll(input,1,0);


	  if (ret_poll >=1 && (input[0].revents &POLLIN))
	    {
	      memset(buff, 0, sizeof(buff));
	      n = read(input[0].fd, buff, sizeof(buff));
	      /*printf("command:%s\n",buff);*/
	      if (strcmp(buff,"exit\n") == 0)
		{
		  printf("exiting\n");
		  if (conindicator == 1)
		    {
		      /*write(s, pidstr, strlen(pidstr));*/
		      write(s, buff, strlen(buff));
		    }
		  exit(1);
		}
	    }

	  
	  /* check master socket  for new connections here*/
	  if ( (N <= clientlimit) && (pfd[0].revents & POLLIN))
	    {	      
	      /* accept a new connection */
	      int a;
	      
	      for (a=0; a <= clientlimit; a = a+1)
		{
		  /*
		  printf("a is eual to %i\n",a);
		  printf("is true %d\n",(inuse[a]==0));
		  printf("array is [%d,%d,%d,%d,%d]\n",inuse[0],inuse[1],inuse[2],inuse[3],inuse[4]);
		  fflush(stdout);*/
		  if (inuse[a] == 0)
		    {
		      zero = a+1;
		      /*
		      printf("using zero of %i\n",zero);
		      fflush(stdout);*/
		      break;
		    }
		}
	      fromlen= sizeof (from);
	      newsock[zero]= accept (s, (struct sockaddr *) &from, &fromlen);
	      /* we may also want to perform STREAM I/O */
	      if ((sfp[zero]= fdopen(newsock[zero], "r+")) < 0)
		{
		  fprintf (stderr, "%s: fdopen \n", argv[0]);
		  exit (1);
		}
	      pfd[zero].fd= newsock[zero];
	      pfd[zero].events= POLLIN;
	      pfd[zero].revents= 0;
	      N++;
	      inuse[zero-1] = 1;
	      printf("socketopened\n");
	    }
	  /* polling the sockets here*/
	  int i;
	  char *serv="\n[server]";
	  
	  for (i= 1; i < N; i++)
	    {
	      if (pfd[i].revents & POLLIN)
		{/* check data socket */
		  /*insert activity message here*/
		  /*name array-1,i,time */
		  time_t rawtime;
		  struct tm * timeinfo;
		  timeinfo = localtime ( &rawtime );
		  /*printf ( "Current local time and date: %s", asctime (timeinfo) );*/
		  strcpy(activities[i-1].date,asctime(timeinfo));
		  strcpy(activities[i-1].name,nameArray[i-1]);
		  activities[i-1].used = 404;
		  activities[i-1].ifd = i;
		  memset(buf, 0, sizeof(buf));
		  if (fgets(buf, MAXBUF, sfp[i]) != NULL)
		    {
		      /*removes the \n*/
		      
		      if (buf[strlen(buf) -1] == '\n')
			{
			  buf[strlen(buf)-1] = 0;
			  }
		      if (strcmp(buf,"close") ==0)
			{
			  N = N -1;
			  inuse[i-1] = 0;
			  strcpy(nameArray[i-1],"0");
			  printf("array is [%d,%d,%d,%d,%d]\n",inuse[0],inuse[1],inuse[2],inuse[3],inuse[4]);  
			}
		      else if (strcmp(buf,"exit") ==0)
			{
			  N = N -1;
			  inuse[i-1] = 0;
			  strcpy(nameArray[i-1],"0");
			  printf("array is [%d,%d,%d,%d,%d]\n",inuse[0],inuse[1],inuse[2],inuse[3],inuse[4]);
			}
		      else if (buf[0]=='o' && buf[1] =='p' && buf[2] =='e' && buf[3] == 'n')
			{

			  printf("check if name in list, then open");
			  int c;
			  int same;
			  same = 0;
			  for(c=0; c <= clientlimit; c= c+1)
			    {
			      /*printf("name array = %s",nameArray[c]);*/
			      if (strcmp(nameArray[c],buf+5)== 0)
				{
				  printf("names are equal\n");
				  N = N -1;
				  inuse[i-1] = 0;
				  same = 1;
				  /*tell client he dosn't exist anymore*/
				  char *mes="Existing Username";
				  write(newsock[i],mes,strlen(mes));
				  pfd[i].fd =0;
				}
			    }
			  if (same==0)
			    {
			      printf("nameset = %s\n",buf+5);
			      strcpy(nameArray[i-1], buf+5);
			      write(newsock[i],serv,strlen(serv));
			      
			      char *mes="User '";
			      write(newsock[i],mes,strlen(mes));
			      write(newsock[i],buf+5,strlen(buf+5));
			      char *omes="'Has Logged In\n";
			      write(newsock[i],omes,strlen(omes));
			      
			    }
			}

		      else if (buf[0]=='w' && buf[1]=='h' && buf[2]=='o')
			{
			  /*printf("send the who command to the server here");*/
			  char other[MAXLINE];
			  int d;
			  d=0;
			  strcpy(other,"users: ");
			  for (d=0; d <clientlimit; d=d+1)
			    {
			      if (strcmp(nameArray[d],"0")!=0)
				{
				  strcat(other,nameArray[d]);
				  printf("users %s",other);
				}
			    }
			  strcat(other,"\n");
			  write(newsock[i], serv, strlen(serv));
			  write(newsock[i], other, strlen(other));
			}
		      else if (buf[0]=='t' && buf[1]=='o')
			{
			  printf("here is the to function");
			  char* token = strtok(buf," ");
			  int tokencounter;
			  token = strtok(NULL, " ");
			  write(newsock[i],serv, strlen(serv));
			  char other[MAXLINE];
			  strcpy(other,"Recipiants Added:");
			  while (token != NULL)
			    {
			      tokencounter = 0;
			      printf("token: %s \n", token);
			      int d;
			      d=0;
			      for (d=0; d <clientlimit; d=d+1)
				{
				  if(strcmp(nameArray[d],token)==0)
				    {
				      strcat(other,nameArray[d]);
				      /*printf("added\n");*/
				      /*add to 2d array*/
				      toarray[i-1][tokencounter] = d+1;
				      tokencounter = tokencounter + 1;
				    }
				  
				}
			      
			      token = strtok(NULL," ");
			    }
			  strcat(other,"\n");
			  write(newsock[i],other,strlen(other));
			}
		      else if (buf[0]=='<')
			{
			  int d;
			  d = 0;
			  char *left = "\n[";
			  char *right = "]";
			  char *n = "\n";
			  for (d=0; d < clientlimit; d=d+1)
			    {
			      if (toarray[i-1][d] !=0)
				{
				  write(newsock[toarray[i-1][d]],left,strlen(left));
				  write(newsock[toarray[i-1][d]],nameArray[i-1],strlen(nameArray[i-1]));
				  write(newsock[toarray[i-1][d]],right,strlen(right));
				  write(newsock[toarray[i-1][d]],buf,strlen(buf));
				  write(newsock[toarray[i-1][d]],n,strlen(n));
				}
			    }
			  /*printf("send to all");*/

			}
		      else
			{
		      /*prints buffer here*/
		      /*printf("%s\n", buf);*/
			  
			  write(newsock[i],serv,strlen(serv));
			  
			  char *mes="Improper message\n";
			  if (write(newsock[i],mes,strlen(mes)) <=0)
			    printf("fail write %d\n",errno);
			}
		      printf("%s\n", buf);
		      fflush(stdout);
		    }
		}
	    }
	}/*end for while for polling*/
    }/*endbracket for else if which ends server*/

  /*do nothing if argv/c dont match*/
}
