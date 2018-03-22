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
  /*load database*/
  if (rc = sqlite3_open(argv[1],&db))
    {
      fprintf(stderr, "Can't Open database: %s\n", sqlite3_errmsg(db));
      sqlite3_close(db);
      return(1);
    }
  if (argc == 4)
    {
      /*create function here*/
      sqlite3_create_function( db, "distance", 4, SQLITE_UTF8,NULL, distance, NULL, NULL);
      /*prepare sqlstatement here*/
      char*sql_qry = "SELECT distance(n1.lat,n2.lat,n1.lon,n2.lon) FROM node n1, node n2 WHERE n1.id = ? AND n2.id = ?;";
      rc = sqlite3_prepare_v2(db, sql_qry, -1, &stmt,0);
      if (rc != SQLITE_OK)
	{
	  fprintf(stderr, "Preparation failed: %s\n", sqlite3_errmsg(db));
	  sqlite3_close(db);
	  return 1;
	}
      /*bind values here*/
      sqlite3_bind_int64(stmt, 1, strtol(argv[2], (char**) NULL, 10));
      sqlite3_bind_int64(stmt, 2, strtol(argv[3], (char**) NULL, 10));
      rc = sqlite3_step(stmt);
      /*printf("%i \n",rc);*/
      while(rc == SQLITE_ROW)
	{
	  int col = 0;
	  printf("%s", sqlite3_column_text(stmt, col));
	  printf("\n");
	  rc = sqlite3_step(stmt);
	}
      sqlite3_finalize(stmt);
    }
}


  
