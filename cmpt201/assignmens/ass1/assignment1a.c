#include <stdio.h>
#include <string.h> /* For strncmp(), etc. */
#define MIN_BUF 256
#define MAX_BUF 2048
char Buffer[ MAX_BUF ];
char Word[ MIN_BUF ];
char NextWord[ MIN_BUF ];
void parseFile( FILE * fp, char * fname );

int main( int argc, char * argv[] )
{
  int i;
  FILE * fp;
  for( i = 1; i < argc; i++ )
    {
      fp = fopen( argv[ i ], "r" );
      if( fp == NULL )
	{
	  printf( "Could not open file %s\n", argv[ i ] );
	  exit( -1 );
	}
      else
	{
	  parseFile( fp, argv[ i ] );
	  fclose( fp );
	}
    }
  return( 0 );
} /* main */

