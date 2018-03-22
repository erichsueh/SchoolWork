#include <stdio.h>
#include "stack.h"

/* Driver class to test the stack. */
int main(void) {
  
  char input;
  int toBePushed, popped, running, pushVal, mode;
  printf("Welcome to the stack program.\n\n");
  mode = 0;
  running = 0;
  while (running == 0) {
    printf("Enter option: ");
    scanf("%s", &input);
    switch (input) {
    case 'u':
      printf("What number? ");
      scanf("%d", &toBePushed);
      pushVal = push(toBePushed);
      if (pushVal == 1) {
	printf("Overflow!!!");
	printf("\nStack: ");
	printStack(mode);
	printf("\n");
      } else {
	printf("Stack: ");
	printStack(mode);
	printf("\n");
      }
      break;
    case 'o':
      popped = pop(&toBePushed);
      if (popped == 1) {
	printf("Underflow!!!");
	printf("\nStack: ");
	printStack(mode);
	printf("\n");
      } else {
	printf("Popped %d\n", toBePushed);
	printf("Stack: ");
	printStack(mode);
	printf("\n");

      }
      break;
    case 'x':
      printf("Goodbye!");
      running = 1;
      printf("\n");
      break;
    case 'h':
      mode = 1;
      printf("Stack: ");
      printStack(mode);
      printf("\n");
      break;
    case 'c':
      mode = 2;
      printf("Stack: ");
      printStack(mode);
      printf("\n");
      break;
    case 'd':
      mode = 0;
      printf("Stack: ");
      printStack(0);
      printf("\n");
      break;
    default:
      printf("\n");
      printf("\n");
      break;

    }
  }
  
  return 0;
}
