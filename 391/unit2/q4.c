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

void distance(sqlite3_context* ctx, int nargs, sqlite3_value** values)
{
  double lat1, lat2, long1,long2;
  double dis;
  double r = 6371.009;
  lat1 = sqlite3_value_double(values[0]);
  lat2 = sqlite3_value_double(values[1]);
  long1 = sqlite3_value_double(values[2]);
  long2 = sqlite3_value_double(values[3]);
  /*do distance formula*/
  double deltalat = (lat2-lat1)*(M_PI/180);
  double deltalon = (long2-long1)*(M_PI/180);
  double rads = (M_PI/180)*(lat2+lat1)/2;
  double meanlat = cos(rads);
  double together = meanlat*deltalon;
  dis = r * sqrt( (deltalat*deltalat) + (together*together));
  /*printf("%lf",dis);*/
  sqlite3_result_double(ctx,dis);
}

int main(int argc, char * argv[])
{
  sqlite3 *db;
  int rc;
  sqlite3_stmt *stmt;
  long ids[600];
  /*load database*/
  if (rc = sqlite3_open(argv[1],&db))
    {
      fprintf(stderr, "Can't Open database: %s\n", sqlite3_errmsg(db));
      sqlite3_close(db);
      return(1);
    }
  sqlite3_create_function( db, "distance", 4, SQLITE_UTF8,NULL, distance, NULL, NULL);
  int z, counter;
  z = 2;
  counter=0;
  for (z=2; z<argc;z= z+1)
    {
      char*sql_qry = "SELECT n.id FROM waytag n WHERE n.k=? AND n.v=?";
      rc = sqlite3_prepare_v2(db, sql_qry, -1, &stmt,0);
      if (rc != SQLITE_OK)
	{
	  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	  sqlite3_close(db);
	  return 1;
	}

      char *token;
      char *search = "=";
      token = strtok(argv[z],search);
      /*printf("first token:%s\n",token);
      printf("%li",sizeof(token));*/
      sqlite3_bind_text(stmt, 1, token,-1,SQLITE_TRANSIENT);
      token = strtok(NULL,search);
      /*printf("secondtoken:%s\n",token);*/
      sqlite3_bind_text(stmt, 2, token,-1,SQLITE_TRANSIENT);
      rc = sqlite3_step(stmt);
      /*printf("%i \n",rc);*/
      while(rc == SQLITE_ROW)
	{
	  int col = 0;
	  printf("%s", sqlite3_column_text(stmt, col));
	  ids[counter] = sqlite3_column_int64(stmt,col);
	  counter = counter + 1;
	  printf("\n");
	  rc = sqlite3_step(stmt);
	}
      sqlite3_finalize(stmt);
    }
  /*do stuff with it*/
  int c1 = 0;
  double largest = -1;
  long tempids[600];
  /*initiate tempid here*/
  for (c1=0;c1<counter;c1=c1+1)
    {
      /*start query here*/
      char*sql_qry4 = "SELECT ordinal,nodeid FROM waypoint WHERE wayid =?";
      rc = sqlite3_prepare_v2(db, sql_qry4, -1, &stmt,0);
      if (rc != SQLITE_OK)
	{
	  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	  sqlite3_close(db);
	  return 1;
	}
      /*bind values here*/
      sqlite3_bind_int64(stmt, 1, ids[c1]);

      rc = sqlite3_step(stmt);
      int counter = 0;
      while(rc == SQLITE_ROW)
	{
	  /*printf("%s", sqlite3_column_text(stmt, 0));
	  printf("|%s",sqlite3_column_text(stmt, 1));*/
	  tempids[counter] = sqlite3_column_int64(stmt,1);
	  counter = counter +1;
	  /*printf("  : %li",tempids[counter]);
	    printf("\n");*/
	  rc = sqlite3_step(stmt);
	}
      sqlite3_finalize(stmt);
      /*check for open/close*/
      /*find length*/
      char*sql_qry1 = "SELECT closed FROM way WHERE id =?";
      rc = sqlite3_prepare_v2(db, sql_qry1, -1, &stmt,0);
      if (rc != SQLITE_OK)
	{
	  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	  sqlite3_close(db);
	  return 1;
	}
      sqlite3_bind_int64(stmt, 1, strtol(argv[2], (char**) NULL, 10));
      rc = sqlite3_step(stmt);
      int torf = sqlite3_column_int(stmt, 0);
      /*find length in a loop*/
      double total =0;
      int a;
      for (a=0;a<counter;a=a+1)
	{
	  char*sql_qry2 = "SELECT distance(n1.lat,n2.lat,n1.lon,n2.lon) FROM node n1, node n2 WHERE n1.id = ? AND n2.id = ?;";
	  rc = sqlite3_prepare_v2(db, sql_qry2, -1, &stmt,0);
	  if (rc != SQLITE_OK)
	    {
	      fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	      sqlite3_close(db);
	      return 1;
	    }
	  /*bind values here*/
	  sqlite3_bind_int64(stmt, 1, tempids[a]);
	  sqlite3_bind_int64(stmt, 2, tempids[a+1]);
	  rc = sqlite3_step(stmt);
	  /*printf("%i \n",rc);*/
	  while(rc == SQLITE_ROW)
	    {
	      int col = 0;
	      /*printf("%s", sqlite3_column_text(stmt, col));
		printf("\n");*/
	      /*add total here*/
	      total = total + sqlite3_column_double(stmt,0);
	      rc = sqlite3_step(stmt);
	    }
	  /*printf("total length = %lf",total);*/
	  /*add if statment for closed*/
	}
      if (total > largest)
	{
	  largest = total;
	}
      /*soidjf*/
    }

  printf("The largest distance is %lf \n",largest);
  printf("The total number of node elements is %i \n",counter);
}
