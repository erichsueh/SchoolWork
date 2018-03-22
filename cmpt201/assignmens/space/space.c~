/*
Eric Hsueh
1384955
ehsueh
Class:MWF 9-10
Lab:Tuesday D02

This program take the input of a file, and then prints it out to
Sketchpad for it to draw lines
*/
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <signal.h> // for signal handling
#include <sys/time.h> // for the timer
#include<string.h>
#include<unistd.h>
#include<math.h>
#include<ctype.h>

#include <assert.h>
#include <ncurses.h>

#define LINE_LEN 1024



typedef struct arrayholder
{
  char imgname;
  int xarray[21];
  int yarray[21];
  int counter;
  double xship[6];
  double yship[6];
  double yvelocity;
  double xvelocity;
  double rotation;
  double xshipflame[3];
  double yshipflame[3];
}Imageholder;

Imageholder mystruct;
static int g_finished = 0;

FILE *popen(const char *command, const char *type);
int pclose(FILE *stream);

const char exec_name[]= "java -jar Sketchpad.jar";
void startgame(FILE * fp, char * fname);
void draw();
void handle_timeout( int signal );
void gravity();
FILE* executable;
void critcode();
double gravitynumb;
double accl;
void init_ncurses();
void shutdown_ncurses();
void thrust();
//void rotatex();
//void rotatey();
void rotate(double rorl);
void drawthrust();
void erasethrust();
int thruston = 1;
int improve;
void endgame();
void title();
void brown();
void blue();
void red();
int lineSegmentIntersection(
double Ax, double Ay,
double Bx, double By,
double Cx, double Cy,
double Dx, double Dy);
void printv();
int trueorfalse = 1;
int win = 0;
void winner();
void explosion();
double fuel = 1000;

//Check Inputs **********************************************
int main(int argc, char*argv[])
{
char filename[256];
int i;
improve = 0;
FILE *fp;
for (i = 1; i<argc; i++)
	{	
	if (argv[i][0] == '-')
		{
		switch(argv[i][1])
			{
			case 'g':
				sscanf(argv[i+1], "%lf", &gravitynumb);
				break;	
			case 't':
				sscanf(argv[i+1], "%lf", &accl);
				break;
			case 'f':
				strcpy(filename, argv[i+1]);
				fp = fopen(filename,"r");
				break;
			case 'i':
				improve = 1;
				break;
			}
		}
	}
executable = popen(exec_name, "w");
if (executable == NULL)
	{
	fprintf(stderr,"Could not open pipe %s\n",exec_name);
	}
startgame(fp,argv[i]);
fflush(executable);
pclose(executable);
fclose(fp);
return(EXIT_SUCCESS);
}


//Start Game***********************************************
void startgame(FILE * fp, char *fname)
{
char line[LINE_LEN+1];
int intx,inty;
int counter1 = 0;
g_finished = 1;
//initialize ship
//gravitynumb = 0;
//accl = -20;
mystruct.xship[0] = 300;
mystruct.yship[0] = 40;
mystruct.xship[1] = 330;
mystruct.yship[1] = 40;
mystruct.xship[2] = 320;
mystruct.yship[2] = 10;
mystruct.xship[3] = 310;
mystruct.yship[3] = 10;
mystruct.xship[4] = 300;
mystruct.yship[4] = 40;
mystruct.xvelocity = 0;
mystruct.yvelocity = 0;
mystruct.xshipflame[0] = 300;
mystruct.yshipflame[0] = 40;
mystruct.xshipflame[1] = 315;
mystruct.yshipflame[1] = 60;
mystruct.xshipflame[2] = 330;
mystruct.yshipflame[2] = 40;

if (improve == 1)
	{
	title();
	}

while (fgets(line,LINE_LEN+1,fp))
    	{
	sscanf(line,"%d %d\n",&intx,&inty);
	(mystruct.xarray)[counter1] =lround(intx);
	(mystruct.yarray)[counter1] =lround(inty);
	counter1++;
	}
mystruct.counter = counter1;

//Initialize timer
struct sigaction handler;
handler.sa_handler = handle_timeout;
sigemptyset( &handler.sa_mask );
handler.sa_flags = 0;
if( sigaction( SIGALRM, &handler, NULL ) < 0 )
	{
	exit( EXIT_FAILURE );
	}
struct itimerval timer;
timer.it_value.tv_sec = 0;  // 0 in the example lander program
timer.it_value.tv_usec = 50000; // 50000 in the example lander program
timer.it_interval.tv_sec = 0;  // 0 in the example lander program
timer.it_interval.tv_usec = 50000; // 50000 in the example lander program
if( setitimer( ITIMER_REAL, &timer, NULL ) < 0 )
	{
    	exit( EXIT_FAILURE );
  	}
//Initialize Curses/keys
int c;
init_ncurses();
mvprintw( 5, 10, "Press any key to start." );
refresh(); // printed output doesn't appear until we refresh
c = getch();
nodelay( stdscr, TRUE ); // have getch() return ERR if input isn't ready
erase();
mvprintw( 5, 10, "Press arrow keys, 'q' to quit." );
refresh();

//Draw it
draw();

  do {
    c = getch();
    if( c == ERR ) { continue; } // keep looping until we get input

    // in asn3, won't need to do any printing to screen.
    // instead, will rotate figure on left or right arrow keys, and
    // initiate thrust when space bar is pressed.
    erase();
    mvprintw( 5, 10, "Press arrow keys, 'q' to quit." );
    move( 6, 10 );
    switch( c ) {
    case KEY_DOWN:
      printw( "down key pressed" );
      break;

    case KEY_LEFT:
      printw( "left key pressed" );
      rotate(-10);
      break;

    case KEY_RIGHT:
      printw( "right key pressed" );
      rotate(10);
      break;

    case KEY_UP:
      printw( "up key pressed" );
      break;

    case 'q':
      g_finished = 0;
      break;

    case ' ':
      if (fuel > 0)
	{
      	thruston = 0;
      	drawthrust();
      	printw( "spacebar pressed");
      	thrust();
      	thruston = 1;
      	erasethrust();
      	fuel = fuel-1;
	}
      break;

    default:
      //break
      break;
    }
    refresh();
  } while( g_finished );


if (win == 1)
	{
	winner();
	}
fprintf(executable,"pause 2\n");
timer.it_value.tv_sec = 0;  // 0 in the example lander program
timer.it_value.tv_usec = 0; // 50000 in the example lander program
timer.it_interval.tv_sec = 0;  // 0 in the example lander program
timer.it_interval.tv_usec = 0;
// must do this or else the terminal will be unusable
shutdown_ncurses();
fprintf(executable,"end");
//shutdown_ncurses();
//exit( EXIT_SUCCESS );
}

//*********Winner*****
void winner()
{
fprintf(executable,"drawSegment 100 100 150 200\n");
fprintf(executable,"drawSegment 150 200 200 100\n");
fprintf(executable,"drawSegment 200 100 250 200\n");
fprintf(executable,"drawSegment 200 200 300 100\n");

fprintf(executable,"drawSegment 400 100 400 200\n");

fprintf(executable,"drawSegment 500 100 500 200\n");
fprintf(executable,"drawSegment 500 100 600 200\n");
fprintf(executable,"drawSegment 600 200 600 100\n");
}


//****Rotate**************************

void rotate(double rorl)
{
int xaxis,yaxis,nextx,nexty,x,xmax,xmin,ymax,ymin;
double centerx,centery,extrax,extray;
sigset_t block_mask;
sigset_t old_mask;
sigemptyset( &block_mask );
sigaddset( &block_mask, SIGALRM );
if( sigprocmask( SIG_BLOCK, &block_mask, &old_mask ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
xmax = mystruct.xship[0];
xmin = mystruct.xship[0];
ymax = mystruct.yship[0];
ymin = mystruct.yship[0];

mystruct.rotation = mystruct.rotation +rorl;
for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	if (xaxis > xmax){
		xmax = xaxis;}
	if (xaxis < xmin){
		xmin = xaxis;}
	if (yaxis >ymax){
		ymax = yaxis;}
	if (yaxis < ymin){
		ymin = yaxis;}
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"eraseSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}
centerx = (xmin +xmax)/2;
centery = (ymin +ymax)/2;
for (x=0; x!= 5; x++)
	{
	mystruct.xship[x] = mystruct.xship[x] - centerx;
	mystruct.yship[x] = mystruct.yship[x] - centery;
	 
	extrax = (mystruct.xship[x]*cos(rorl*M_PI/180))-(mystruct.yship[x]*sin(rorl*M_PI/180));
	extray = (mystruct.xship[x]*sin(rorl*M_PI/180))+(mystruct.yship[x]*cos(rorl*M_PI/180));
	
	mystruct.xship[x] = extrax + centerx;
	mystruct.yship[x] = extray + centery;
	}
for (x=0; x!= 3; x++)
	{
	mystruct.xshipflame[x] = mystruct.xshipflame[x] - centerx;
	mystruct.yshipflame[x] = mystruct.yshipflame[x] - centery;
	 
	extrax = (mystruct.xshipflame[x]*cos(rorl*M_PI/180))-(mystruct.yshipflame[x]*sin(rorl*M_PI/180));
	extray = (mystruct.xshipflame[x]*sin(rorl*M_PI/180))+(mystruct.yshipflame[x]*cos(rorl*M_PI/180));
	
	mystruct.xshipflame[x] = extrax + centerx;
	mystruct.yshipflame[x] = extray + centery;
	}

for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	//fprintf(stdout,"%d %d %d %d\n",xaxis,yaxis,nextx,nexty);

	}
fflush(executable);

if( sigprocmask( SIG_SETMASK, &old_mask, NULL ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
}

void drawthrust()
{
int xaxis,yaxis,nextx,nexty,x;
sigset_t block_mask;
sigset_t old_mask;
sigemptyset( &block_mask );
sigaddset( &block_mask, SIGALRM );
if( sigprocmask( SIG_BLOCK, &block_mask, &old_mask ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
for (x=0; x!= 2; x++)
	{
	xaxis = (mystruct.xshipflame)[x];
	yaxis = (mystruct.yshipflame)[x];
	nextx = (mystruct.xshipflame)[x+1];
	nexty = (mystruct.yshipflame)[x+1];
	fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	//fprintf(stdout,"%d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}
if( sigprocmask( SIG_SETMASK, &old_mask, NULL ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
fflush(executable);
}

void erasethrust()
{
int xaxis,yaxis,nextx,nexty,x;
sigset_t block_mask;
sigset_t old_mask;
sigemptyset( &block_mask );
sigaddset( &block_mask, SIGALRM );
if( sigprocmask( SIG_BLOCK, &block_mask, &old_mask ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"eraseSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}
fflush(executable);
if( sigprocmask( SIG_SETMASK, &old_mask, NULL ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
}
//******Thrusters activate**********
void thrust()
{
int xaxis,yaxis,nextx,nexty,x;
sigset_t block_mask;
sigset_t old_mask;
sigemptyset( &block_mask );
sigaddset( &block_mask, SIGALRM );
if( sigprocmask( SIG_BLOCK, &block_mask, &old_mask ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"eraseSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}
for (x=0; x!=5; x++)
	{
	mystruct.xship[x] = (mystruct.xship[x]+(mystruct.xvelocity*0.05)+(1/2 *accl)*cos((mystruct.rotation+ 90) *M_PI/180));
	mystruct.yship[x] = mystruct.yship[x]+(mystruct.yvelocity*0.05)+(1/2 *accl)*cos(mystruct.rotation *M_PI/180);
	}
mystruct.yvelocity = (mystruct.yvelocity) + (accl *.05)*cos((mystruct.rotation) *M_PI/180);
mystruct.xvelocity = (mystruct.xvelocity) + (accl *.05)*cos((mystruct.rotation+90) *M_PI/180);
for (x=0; x!= 2; x++)
	{
	xaxis = (mystruct.xshipflame)[x];
	yaxis = (mystruct.yshipflame)[x];
	nextx = (mystruct.xshipflame)[x+1];
	nexty = (mystruct.yshipflame)[x+1];
	fprintf(executable,"eraseSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	//fprintf(stdout,"%d %d %d %d\n",xaxis,yaxis,nextx,nexty);

	}
fflush(executable);
if( sigprocmask( SIG_SETMASK, &old_mask, NULL ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
}


//****** Handle Timeout ********************
void handle_timeout(int signal)
{
static int called = 0;
if( signal == SIGALRM ) 
	{
    	called++;
	critcode();
	//gravity();
	}
}

//******Blocking crit code***************
void critcode()
{
//int x;
sigset_t block_mask;
sigset_t old_mask;
sigemptyset( &block_mask );
sigaddset( &block_mask, SIGALRM );
if( sigprocmask( SIG_BLOCK, &block_mask, &old_mask ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
	/*
	if (thruston == 0)
		{
		for (x=0; x!= 3; x++)
			{
			mystruct.xshipflame[x] = mystruct.xshipflame[x]+(mystruct.xvelocity*0.05);
			mystruct.yshipflame[x] = mystruct.yshipflame[x]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
			}
		//drawthrust();
		}*/
	gravity();
	endgame();
	if (improve == 1)
		{
		printv();
		}
	//check linecolision & offscreen
if( sigprocmask( SIG_SETMASK, &old_mask, NULL ) < 0 ) 
	{
	exit( EXIT_FAILURE );
	}
}
void printv()
{
mvprintw(10,11,"xVelo%lf",mystruct.xvelocity);
mvprintw(11,11,"yVelo%lf",mystruct.yvelocity);
mvprintw(9,11,"Angle%lf",mystruct.rotation);
}
//************Checking if game end********
void endgame()
{
int xaxis,yaxis,nextx,nexty,x;
int lxaxis,lyaxis,lnextx,lnexty,y;
for (x=0; x!=4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	for (y=0; y !=mystruct.counter -1;y++)
		{
		lxaxis = (mystruct.xarray)[y];
		lyaxis = (mystruct.yarray)[y];
		lnextx = (mystruct.xarray)[y+1];
		lnexty = (mystruct.yarray)[y+1];
		lineSegmentIntersection(xaxis,yaxis,nextx,nexty,lxaxis,lyaxis,lnextx,lnexty);
		}

	if (trueorfalse == 0)
		{
		if ((mystruct.rotation == 0) && (20>mystruct.xvelocity) &&(-20< mystruct.xvelocity) && (20>mystruct.yvelocity) &&(-20< mystruct.yvelocity))
			{
			mvprintw (13, 11, "Landed!");
			win = 1;
			}
		else
			{
			mvprintw(13, 11,"CRASHED");
			}
		g_finished = 0;
		}
	}
}
//******Updating with gravity*********

void gravity()
{
int xaxis,yaxis,nextx,nexty,x;
for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"eraseSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}

for (x=0; x!= 3; x++)
	{
	mystruct.xshipflame[x] = mystruct.xshipflame[x]+(mystruct.xvelocity*0.05);
	mystruct.yshipflame[x] = mystruct.yshipflame[x]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
	}

mystruct.xship[0] = mystruct.xship[0]+(mystruct.xvelocity*0.05);
mystruct.yship[0] = mystruct.yship[0]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
mystruct.xship[1] = mystruct.xship[1]+(mystruct.xvelocity*0.05);
mystruct.yship[1] = mystruct.yship[1]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
mystruct.xship[2] = mystruct.xship[2]+(mystruct.xvelocity*0.05);
mystruct.yship[2] = mystruct.yship[2]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
mystruct.xship[3] = mystruct.xship[3]+(mystruct.xvelocity*0.05);
mystruct.yship[3] = mystruct.yship[3]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
mystruct.xship[4] = mystruct.xship[4]+(mystruct.xvelocity*0.05);
mystruct.yship[4] = mystruct.yship[4]+(mystruct.yvelocity*0.05) +(1/2 *gravitynumb);
mystruct.yvelocity = mystruct.yvelocity + (gravitynumb *.05);
for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	//fprintf(stdout,"%d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}

fflush(executable);
}



//Draw the Ship and Landscape *******************************

void draw()
{
if (improve == 1)
{
brown();
}
int xaxis,yaxis,nextx,nexty,x;
for (x=0;x!=mystruct.counter -1;x++)
	{
	xaxis = (mystruct.xarray)[x];
	yaxis = (mystruct.yarray)[x];
	nextx = (mystruct.xarray)[x+1];
	nexty = (mystruct.yarray)[x+1];
	fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}
/*
for (x=0; x!= 4; x++)
	{
	xaxis = (mystruct.xship)[x];
	yaxis = (mystruct.yship)[x];
	nextx = (mystruct.xship)[x+1];
	nexty = (mystruct.yship)[x+1];
	fprintf(executable,"drawSegment %d %d %d %d\n",xaxis,yaxis,nextx,nexty);
	}
*/
if (improve == 1)
{
blue();
}
}


//************Curses*******************
void init_ncurses()
{
  int r;

  // start up the ncurses environment
  initscr(); // nothing to check, initscr exits on error

  // don't wait for enter for keyboard input
  r = cbreak(); assert( r != ERR );

  // don't echo keypresses to screen
  r = noecho(); assert( r != ERR );

  r = nonl(); assert( r != ERR );

  // turn cursor off
  r = curs_set( 0 ); assert( r != ERR );

  // don't worry about cursor position
  r = leaveok( stdscr, TRUE ); assert( r != ERR );

  // slower handling of ^C but saner output
  r = intrflush( stdscr, FALSE ); assert( r != ERR );

  // translate movement espace codes into single keys
  r = keypad( stdscr, TRUE ); assert( r != ERR );
}

void shutdown_ncurses()
{
  endwin();
}
//**************Draw titlepage*****
void title()
{
red();
fprintf(executable,"drawSegment 10 10 10 30\n");
fprintf(executable,"drawSegment 10 30 20 30\n");
fprintf(executable,"drawSegment 30 10 35 30\n");
fprintf(executable,"drawSegment 35 30 40 10\n");

fprintf(executable,"drawSegment 50 30 50 10\n");
fprintf(executable,"drawSegment 50 10 60 30\n");
fprintf(executable,"drawSegment 60 30 60 10\n");

fprintf(executable,"drawSegment 70 30 75 10\n");
fprintf(executable,"drawSegment 75 10 80 30\n");

fprintf(executable,"drawSegment 90 10 90 30\n");
fprintf(executable,"drawSegment 90 20 100 30\n");
fprintf(executable,"drawSegment 90 20 100 15\n");
fprintf(executable,"drawSegment 90 10 100 15\n");

fprintf(executable,"drawSegment 10 50 10 70\n");
fprintf(executable,"drawSegment 10 70 20 70\n");

fprintf(executable,"drawSegment 30 70 35 50\n");
fprintf(executable,"drawSegment 35 50 40 70\n");

fprintf(executable,"drawSegment 50 70 50 50\n");
fprintf(executable,"drawSegment 50 50 60 70\n");
fprintf(executable,"drawSegment 60 70 60 50\n");

fprintf(executable,"drawSegment 70 70 70 50\n");
fprintf(executable,"drawSegment 70 50 80 60\n");
fprintf(executable,"drawSegment 70 70 80 60\n");

fprintf(executable,"drawSegment 90 70 90 50\n");
fprintf(executable,"drawSegment 90 50 100 50\n");
fprintf(executable,"drawSegment 90 60 100 60\n");
fprintf(executable,"drawSegment 90 70 100 70\n");

fprintf(executable,"drawSegment 110 50 110 70\n");
fprintf(executable,"drawSegment 110 60 120 70\n");
fprintf(executable,"drawSegment 110 60 120 55\n");
fprintf(executable,"drawSegment 110 50 120 55\n");

fprintf(executable,"pause 3\n");
fprintf(executable,"clearScreen\n");

}

 void brown()
{
fprintf(executable,"setColor 165 42 42\n");
} 

void red()
{
fprintf(executable,"setColor 255 0 0\n");
}

void blue()
{
fprintf(executable,"setColor 0 0 205\n");
}

//**************Line detection***************
int lineSegmentIntersection(
double Ax, double Ay,
double Bx, double By,
double Cx, double Cy,
double Dx, double Dy) {

  double  distAB, theCos, theSin, newX, ABpos ;

  //  Fail if either line segment is zero-length.
  if ((Ax==Bx && Ay==By) || (Cx==Dx && Cy==Dy)) return 1;

  //  Fail if the segments share an end-point.
  if ((Ax==Cx && Ay==Cy) || (Bx==Cx && By==Cy)
  ||  (Ax==Dx && Ay==Dy) || (Bx==Dx && By==Dy)) {
    return 1; }

  //  (1) Translate the system so that point A is on the origin.
  Bx-=Ax; By-=Ay;
  Cx-=Ax; Cy-=Ay;
  Dx-=Ax; Dy-=Ay;

  //  Discover the length of segment A-B.
  distAB=sqrt(Bx*Bx+By*By);

  //  (2) Rotate the system so that point B is on the positive X axis.
  theCos=Bx/distAB;
  theSin=By/distAB;
  newX=Cx*theCos+Cy*theSin;
  Cy  =Cy*theCos-Cx*theSin; Cx=newX;
  newX=Dx*theCos+Dy*theSin;
  Dy  =Dy*theCos-Dx*theSin; Dx=newX;

  //  Fail if segment C-D doesn't cross line A-B.
  if ((Cy<0. && Dy<0.) || (Cy>=0. && Dy>=0.)) return 1;

  //  (3) Discover the position of the intersection point along line A-B.
  ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);

  //  Fail if segment C-D crosses line A-B outside of segment A-B.
  if (ABpos<0. || ABpos>distAB) return 1;

  //  Success.
  //mvprintw(10, 10,"fjidglna");
  trueorfalse = 0;
  return 0; 
}
