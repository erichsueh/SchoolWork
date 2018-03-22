// modified from test_ncurses.c, timer.c and
// https://viget.com/extend/game-programming-in-c-with-the-ncurses-library

#define _XOPEN_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <ncurses.h>
#include <signal.h>
#include <sys/time.h>


typedef struct {
  double pos;
  double vel;
} PosVelocity;

typedef struct {
  PosVelocity x;
  PosVelocity y;
} State;


State g_state;


// update a position given its current velocity
// bounce off of min/max value
void updatePosVelocity( PosVelocity *pv, double min, double max );

// setup/shutdown functions for ncurses
void init_ncurses();
void shutdown_ncurses();


// handle the alarm signal, updates ball position and re-draws
void handle_signal( int signal )
{
  int maxy, maxx;
  if( signal != SIGALRM ) { return; }

  // update the ball position
  getmaxyx( stdscr, maxy, maxx );
  updatePosVelocity( &g_state.x, 0, (double)maxx );
  updatePosVelocity( &g_state.y, 0, (double)maxy );

  // re-draw
  erase();
  mvprintw( (int)g_state.y.pos, (int)g_state.x.pos, "O" );
  refresh();
}

int main()
{
  int running, c;
  struct sigaction handler;
  struct itimerval timer;

  // set up initial position and velocity of ball
  g_state.x.pos = 0;
  g_state.x.vel = 1;
  g_state.y.pos = 0;
  g_state.y.vel = 0.5;

  // start ncurses
  init_ncurses();

  // set up signal handler for alarm
  handler.sa_handler = handle_signal;
  sigemptyset( &handler.sa_mask );
  handler.sa_flags = 0;
  if( sigaction( SIGALRM, &handler, NULL ) < 0 ) {
    exit( EXIT_FAILURE );
  }

  // set up alarm timer
  timer.it_value.tv_sec = 0;
  timer.it_value.tv_usec = 20000;
  timer.it_interval.tv_sec = 0;
  timer.it_interval.tv_usec = 20000;
  if( setitimer( ITIMER_REAL, &timer, NULL ) < 0 ) {
    exit( EXIT_FAILURE );
  }

  // sit in a loop, waiting on input
  running = 1;
  while( running ) {

    c = getch(); // pause, waiting for a character
    if( c == ERR ) { continue; } // pause might have been interrupted by alarm

    // handle the input
    switch( c ) {
    case KEY_LEFT:
      g_state.x.vel -= 0.1;
      break;

    case KEY_RIGHT:
      g_state.x.vel += 0.1;
      break;

    case KEY_UP:
      g_state.y.vel -= 0.1;
      break;

    case KEY_DOWN:
      g_state.y.vel += 0.1;
      break;

    case 'q':
      running = 0;
      break;

    default:
      break;
    }
  }

  // need to close ncurses cleanly to recover the terminal
  shutdown_ncurses();
}


// update a position given its current velocity
// bounce off of min/max value
void updatePosVelocity( PosVelocity *pv, double min, double max )
{
  if( pv->pos < min ) {
    pv->pos = min;
    pv->vel = fabs( pv->vel );
  } else if( pv->pos > max ) {
    pv->pos = max;
    pv->vel = -fabs( pv->vel );
  } else {
    if( pv->pos + pv->vel < min ) {
      pv->pos = min + min - ( pv->pos + pv->vel );
      pv->vel = -pv->vel;
    } else if( pv->pos + pv->vel > max ) {
      pv->pos = max + max - ( pv->pos + pv->vel );
      pv->vel = -pv->vel;
    } else {
      pv->pos = pv->pos + pv->vel;
    }
  }
}


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
