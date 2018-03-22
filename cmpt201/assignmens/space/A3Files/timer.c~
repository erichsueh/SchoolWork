// Illustrates how to use a timer to print something every x seconds,
// and how to block code from being interrupted by this timer

// define this macro as we're using some UNIX functions outside of C99
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <signal.h> // for signal handling
#include <sys/time.h> // for the timer


// global value which our signal handler will use to communicate we're finished
static int g_finished = 0;


// our signal handler function which will be called whenever the timer expires
void handle_timeout( int signal );


int main()
{
  struct sigaction handler;

  // set up signal handler (man 2 sigaction)
  /* *********************************************************** */

  // handle_timeout is function to call when signal is sent
  handler.sa_handler = handle_timeout;
  // empties sa_mask, meaning no signals will be blocked while our
  // signal handler (handle_timeout) is executing
  sigemptyset( &handler.sa_mask );
  // various options. we don't need any for this program
  handler.sa_flags = 0;

  // use signal handler defined in handler to handle SIGALRM signals
  if( sigaction( SIGALRM, &handler, NULL ) < 0 ) {
    exit( EXIT_FAILURE );
  }
  // when SIGALRM occurs (set up below), handle_timeout will now be called.


  // set up timer  (sends SIGLARM)
  /* *********************************************************** */

  // sets up values for timer (intervals between sending SIGALRM).
  // times are in seconds+microseconds (1/1 millionth of a second).
  // note although close enough for us, this is only approximate.
  // (man 2 setitimer)
  // Turn of the interval timer by setting the timer to 0/0
  // The sample program set tv_sec to 0 and tv_usec to 50000, which
  // meant the ship was redrawn approximately every 50000 microseconds
  struct itimerval timer;

  // value for time until first SIGALRM
  timer.it_value.tv_sec = 3;  // 0 in the example lander program
  timer.it_value.tv_usec = 0; // 50000 in the example lander program
  // interval between subsequent alarms
  timer.it_interval.tv_sec = 1;  // 0 in the example lander program
  timer.it_interval.tv_usec = 0; // 50000 in the example lander program

  // will execute repeatedly, sending SIGALRM every timer.it_interval
  // seconds/microseconds, with an inital delay of timer.it_value.
  if( setitimer( ITIMER_REAL, &timer, NULL ) < 0 ) {
    exit( EXIT_FAILURE );
  }

  // loop until we're done
  while( !g_finished ) {

    // do other things while we're wating for the timer to expire
    // ...
  }
  // done!
  exit( EXIT_SUCCESS );
}


// our handler for SIGALRM.
// In general, signal handlers can handle multiple signals, so they have
// a parameter which indicates which signal activated the handler function
void handle_timeout(int signal)
{
  static int called = 0;

  // check that we were called because of SIGALRM
  if( signal == SIGALRM ) {

    called++;

    printf( "called %d times\n", called );

    // stops timer on 5th call.  In asn3, you should stop when the
    // game is done instead (e.g., ship has crashed or landed)
    if( called == 5 ) {
      struct itimerval timer;

      // turn the timer off by setting the values to 0/0
      timer.it_interval.tv_sec = 0;
      timer.it_interval.tv_usec = 0;
      timer.it_value.tv_sec = 0;
      timer.it_value.tv_usec = 0;
      if( setitimer( ITIMER_REAL, &timer, NULL ) < 0 ) {
	exit( EXIT_FAILURE );
      }

      // notify the main program that we're done
      g_finished = 1;
    }
  }
}

// critical code is code that must not be interrupted.  In your asn3,
// examples will include code that updates global data structures, and
// code that erases an old ship and draws a new ship (i.e., moves the
// ship).
//
// The only way code can be interrupted in asn3 code is via our timer
// (i.e., by SIGALRM).
//
// We protect critical code by blocking the signal.
//
// The following is just an example of signal blocking; there is not
// critical code to block.
void example_of_blocking_a_signal()
{
  // signals we want to block (only SIGALM in our case)
  sigset_t block_mask;
  // set of previously blocked signals
  sigset_t old_mask;

  // set up set of signals to block: start with empty set, add SIGALRM
  sigemptyset( &block_mask );
  sigaddset( &block_mask, SIGALRM );
  // NOTE: more complicated code might start by calling sigprocmask to
  // get the current blocked signals and adding the new signal

  // set blocked signal set to block_mask (man 2 sigprocmask) to block SIGALRM.
  // returns previously blocked signals in old_mask.
  if( sigprocmask( SIG_BLOCK, &block_mask, &old_mask ) < 0 ) {
    exit( EXIT_FAILURE );
  }

  // CRITICAL CODE GOES HERE
  // can call other functions here, and they will not be interrupted
  // ...

  // unblock signal by setting mask to old value from before we added SIGALRM
  if( sigprocmask( SIG_SETMASK, &old_mask, NULL ) < 0 ) {
    exit( EXIT_FAILURE );
  }
}
