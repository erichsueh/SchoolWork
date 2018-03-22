// brief example of using ncurses. For more information, look at
// http://invisible-island.net/ncurses/man/ncurses.3x.html
// for the online version of the ncurses man pages.

#define _XOPEN_SOURCE 700
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <ncurses.h>


void init_ncurses();
void shutdown_ncurses();


int main()
{
  int running, c;

  init_ncurses();

  mvprintw( 5, 10, "Press any key to start." );
  refresh(); // printed output doesn't appear until we refresh
  c = getch();

  nodelay( stdscr, TRUE ); // have getch() return ERR if input isn't ready

  erase();
  mvprintw( 5, 10, "Press arrow keys, 'q' to quit." );
  refresh();

  running = 1;
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
      break;

    case KEY_RIGHT:
      printw( "right key pressed" );
      break;

    case KEY_UP:
      printw( "up key pressed" );
      break;

    case 'q':
      running = 0;
      break;

    default:
      // do nothing
      break;
    }
    refresh();
  } while( running );

  // must do this or else the terminal will be unusable
  shutdown_ncurses();

  return EXIT_SUCCESS;
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
