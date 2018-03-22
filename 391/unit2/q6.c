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
  long nodeid;
  int linecounter = 0;
  char *token;
  char *search = "\t";
  while(fgets(buff, MAXLINE, fp) !=NULL)
    {
      /*printf("%li",nodeid);*/
      if (strcmp(buff,"\n") == 0)
	{
	  linecounter =0;
	}
      else if (linecounter == 0)
	{
	  if (buff[strlen(buff) -1] = '\n')
	    {
	      buff[strlen(buff)-1] = 0;
	    }
	  /*waytags here*/
	  token = strtok(buff,search);
	  nodeid = strtol(token, (char**) NULL, 10);
	  token = strtok(NULL,search);
	  while (token != NULL)
	    {
	      printf("%s\n",token);
	      /*initiate sqlite query here*/
	      char*sql_qry1 = "INSERT INTO waytag VALUES(?,?,?)";
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
	    }
	  
	  linecounter = linecounter+1;
	}
      else if (linecounter == 1)
	{
	  if (buff[strlen(buff) -1] = '\n')
	    {
	      buff[strlen(buff)-1] = 0;
	    }
	  int ordinalcounter = 0;
	  token = strtok(buff,search);
	  long first = strtol(token, (char**) NULL, 10);
	  long last;
	  /*start waypoint inserting ehre*/
	  while (token != NULL)
	    {
	      /*check for validity of node*/
	      char*sql_qryexist = "SELECT * FROM node WHERE id = ?";
	      rc = sqlite3_prepare_v2(db, sql_qryexist, -1, &stmt,0);
	      if (rc != SQLITE_OK)
		{
		  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
		  sqlite3_close(db);
		  return 1;
		}
	      sqlite3_bind_int64(stmt, 1, nodeid);
	      if (rc =sqlite3_step(stmt) == SQLITE_ROW)
		{
		  /*if valid insert into sql*/
		  char*sql_insqry = "INSERT INTO waypoint VALUES(?,?,?)";
		  rc = sqlite3_prepare_v2(db, sql_insqry, -1, &stmt,0);
		  if (rc != SQLITE_OK)
		    {
		      fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
		      sqlite3_close(db);
		      return 1;
		    }
		  sqlite3_bind_int64(stmt,1,nodeid);
		  sqlite3_bind_int(stmt,2,ordinalcounter);
		  sqlite3_bind_int64(stmt,3,strtol(token, (char**) NULL, 10));
		  rc = sqlite3_step(stmt);
		  ordinalcounter = ordinalcounter +1;
		  last = strtol(token, (char**) NULL, 10);
		}
	      else
		{
		  printf("node dosn't exist\n");
		}
	      token = strtok (NULL, " \t");
	    }

	  /*insert the way here*/
	  int closed =0;
	  if (last == first)
	    {
	      closed =1;
	    }
	  char*sql_insqry = "INSERT INTO way VALUES(?,?)";
	  rc = sqlite3_prepare_v2(db, sql_insqry, -1, &stmt,0);
	  if (rc != SQLITE_OK)
	    {
	      fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	      sqlite3_close(db);
	      return 1;
	    }
	  sqlite3_bind_int64(stmt,1,nodeid);
	  sqlite3_bind_int(stmt,2,closed);
	  
	  linecounter = linecounter +1;
	}
    }
}
