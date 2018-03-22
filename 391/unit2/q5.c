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
#include <sqlite3.h>
#include <math.h>
#define MAXLINE 4096

int main(int argc, char * argv[])
{
  sqlite3 *db;
  int rc;
  sqlite3_stmt *stmt;
  FILE *fp;
  char buff[MAXLINE];
  /*load database*/
  if (rc = sqlite3_open(argv[1],&db))
    {
      fprintf(stderr, "Can't Open database: %s\n", sqlite3_errmsg(db));
      sqlite3_close(db);
      return(1);
    }
  fp = fopen(argv[2],"r");
  if (fp == NULL)
    {
      printf("File not found");
      return 1;
    }
  while(fgets(buff, MAXLINE, fp) !=NULL)
    {
      if (buff[strlen(buff) -1] = '\n')
	{
	  buff[strlen(buff)-1] = 0;
	}
      int counter = 0;
      char *token;
      char *search = "\t";
      char*sql_qry = "INSERT INTO node VALUES(?,?,?)";
      long nodeid;
      rc = sqlite3_prepare_v2(db, sql_qry, -1, &stmt,0);
      if (rc != SQLITE_OK)
	{
	  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	  sqlite3_close(db);
	  return 1;
	}
      
      token = strtok(buff,search);
      printf("first token:%s\n",token);
      nodeid = strtol(token, (char**) NULL, 10);
      sqlite3_bind_int64(stmt, 1, strtol(token, (char**) NULL, 10));

      token = strtok(NULL,search);
      printf("thirdtoden:%s\n",token);
      sqlite3_bind_double(stmt, 2, atof(token));
      
      
      token = strtok(NULL,search);
      printf("secondtoken:%s\n",token);
      sqlite3_bind_double(stmt, 3, atof(token));
      rc = sqlite3_step(stmt);
      
      token = strtok(NULL,search);
      while (token != NULL)
	{	  
	  printf("%s\n",token);
	  /*initiate sqlite query here*/
	  char*sql_qry1 = "INSERT INTO nodetag VALUES(?,?,?)";
	  rc = sqlite3_prepare_v2(db, sql_qry1, -1, &stmt,0);
	  if (rc != SQLITE_OK)
	    {
	      fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	      sqlite3_close(db);
	      return 1;
	    }
	  
	  char *equalsign;
	  char *searchequal = "=";
	  sqlite3_bind_int64(stmt, 1, nodeid);
	  equalsign = strtok(token,searchequal);
	  printf("first token:%s\n",equalsign);
	  sqlite3_bind_text(stmt, 2, equalsign,-1,SQLITE_TRANSIENT);
	  equalsign = strtok(NULL,searchequal);
	  printf("secondtoken:%s\n",equalsign);
	  sqlite3_bind_text(stmt, 3, equalsign,-1,SQLITE_TRANSIENT);
	  rc = sqlite3_step(stmt);
	  
	  token = strtok (NULL, " \t");
	  counter = counter +1;
	}
    }
  
}
