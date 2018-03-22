/*
# ------------------------------------------------------------
# client.c - a client for the simple concurrent server 'server.c'
#     Compilation:
#     Linux        gcc client.c -o client
#     Usage:client  remotehost
#     Features:- use of setrlimit() to limit the CPU time
#  note: time spent while sleeping, or waiting for input
#        is not CPU time
#- use of htons()
#
# [U. of Alberta, CMPUT379, E.S. Elmallah]
# ------------------------------------------------------------
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>/* required by setrlimit() */
#include <sys/resource.h>/* required by setrlimit() */

#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <netdb.h>/* defines struct hostent, struct servent,  */
/* and prototypes for obtaining host and    */
/* service information                      */
#include <poll.h>

#define MAXBUF 80
#define CPU_LIMIT 10
#define MYPORT 2222

int main (int argc, char **argv) {

  int pid, i, s;
  char buf[MAXBUF], pidstr[MAXBUF];
  struct rlimit cpuLimit;
  struct sockaddr_in server;
  struct hostent*hp;/* host entity    */

  FILE*sfp;

  /* check for at least one argument */

  if (argc < 2) {
    fprintf (stderr, "Usage: %s hostname \n", argv[0]);
    fprintf (stderr, "       e.g., %s gpu.srv.ualberta.ca\n",  argv[0]);
    exit (1);
  }

  /* set a cpu limit */

  cpuLimit.rlim_cur= cpuLimit.rlim_max= CPU_LIMIT;

  if (setrlimit (RLIMIT_CPU, &cpuLimit) < 0 ) {
    fprintf (stderr, "%s: setrlimit \n", argv[0]);
    exit (1);
  }
  getrlimit (RLIMIT_CPU, &cpuLimit);
  printf ("cpuLimit: current (soft)= %lud, maximum (hard)= %lud \n",
	  cpuLimit.rlim_cur, cpuLimit.rlim_max);

  /* lookup the specified host */

  hp= gethostbyname(argv[1]);
  if (hp == (struct hostent *) NULL) {
    fprintf (stderr, "%s: gethostbyname ('%s') \n", argv[0], argv[1]);
    exit (1);
  }

  /* put the host's address, and type into a socket structure;    */
  /* first, clear the structure, then fill in with the IP address */
  /* of the foreign host, and the port number at which the remote */
  /* server listens    */

  memset ((char *) &server, 0, sizeof server);
  memcpy ((char *) &server.sin_addr, hp->h_addr, hp->h_length);
  server.sin_family= hp->h_addrtype;
  server.sin_port= htons(MYPORT);

  /* create a socket, and initiate a connection */

  s= socket(hp->h_addrtype, SOCK_STREAM, 0);
  if (s < 0) {
    fprintf (stderr, "%s: socket \n", argv[0]);
    exit (1);
  }

  /* if the socket is unbound at the time of connect(); the system */
  /* automatically selects and binds a name to the socket          */

  if (connect(s, (struct sockaddr *) &server, sizeof server) < 0) {
    fprintf (stderr, "%s: connect\n", argv[0]);
    exit (1);
  }

  /* we may also want to perform STREAM I/O on the socket */

  if ((sfp= fdopen(s, "r")) < 0) {
    fprintf (stderr, "%s: converting s to FILE* \n", argv[0]);
    exit (1);
  }

  sprintf(pidstr, "%d: ", getpid()); /* get client pid */

  /* read from stdin, and write into socket */

  while (! feof(stdin)) {

    if (fgets(buf, MAXBUF, stdin) != NULL) {
      printf("%s: %s", argv[0], buf);

      write(s, pidstr, strlen(pidstr));
      write(s, buf, strlen(buf));

      /* slow down clients to allow viewing interleaved input */
      /* from multiple clients at the sever side         */

      for (i=0; i < 4e6; i++);
    }
  }

  printf("\n"); close(s); return 0;
}
