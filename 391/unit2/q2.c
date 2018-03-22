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
  int a, counter;
  a = 2;
  counter=0;
  for (a=2; a<argc;a= a+1)
    {
      char*sql_qry = "SELECT n.id FROM nodetag n WHERE n.k=? AND n.v=?";
      rc = sqlite3_prepare_v2(db, sql_qry, -1, &stmt,0);
      if (rc != SQLITE_OK)
	{
	  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	  sqlite3_close(db);
	  return 1;
	}

      char *token;
      char *search = "=";
      token = strtok(argv[a],search);
      printf("first token:%s\n",token);
      printf("%li",sizeof(token));
      sqlite3_bind_text(stmt, 1, token,-1,SQLITE_TRANSIENT);
      token = strtok(NULL,search);
      printf("secondtoken:%s\n",token);
      sqlite3_bind_text(stmt, 2, token,-1,SQLITE_TRANSIENT);
      rc = sqlite3_step(stmt);
      printf("%i \n",rc);
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
  int c1 = 0;
  int c2 = 0;
  double largest = -1;
  for (c1=0;c1<counter;c1=c1+1)
    {
      int c2 = 0;
      for(c2=0;c2<counter;c2=c2+1)
	{
	  char*sql_qry = "SELECT distance(n1.lat,n2.lat,n1.lon,n2.lon) FROM node n1, node n2 WHERE n1.id = ? AND n2.id = ?;";
	  rc = sqlite3_prepare_v2(db, sql_qry, -1, &stmt,0);
	  if (rc != SQLITE_OK)
	    {
	      fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	      sqlite3_close(db);
	      return 1;
	    }
	  /*bind values here*/
	  sqlite3_bind_int64(stmt, 1, ids[c1]);
	  sqlite3_bind_int64(stmt, 2, ids[c2]);
	  rc = sqlite3_step(stmt);
	  /*printf("%i \n",rc);*/
	  while(rc == SQLITE_ROW)
	    {
	      int col = 0;
	      /*double ans = sqlite3_column_double(stmt, col);*/
	      if (sqlite3_column_double(stmt,col) > largest)
		{
		  printf("dis = %lf \n",sqlite3_column_double(stmt,col));
		  largest = sqlite3_column_double(stmt,col);
		}
	      rc = sqlite3_step(stmt);
	    }
	  sqlite3_finalize(stmt);
	}
    }
  printf("The largest pair has a distance of %lf \n",largest);
  printf("The total number of node elements is %i \n",counter);
  /*loop here to find all nodes with the same key=value and put them in a array*/
  /*then loop through the array in a double loop and find the largest distance*/
  /*keep a counter of the length of the arrays or the value added*/
  
  
}
