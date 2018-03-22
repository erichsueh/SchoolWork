#include <stdio.h>


#define MAX_SIZE 10

int arr[MAX_SIZE];
int size = 0;

/* Adds a value to the stack */
int push(int value) {
  if (size == MAX_SIZE) {
    /*printf("Size: %d\n",size);*/
    return 1;
  } else {
    arr[size] = value;
    size++;
    /*printf("Size: %d\n",size);*/
    return 0;
  }
}

/* removes a value from a stack */
int pop (int *value) {
  if (size == 0) {
    /*printf("Size: %d\n",size);*/
    return 1;
  } else {
    /* save the value to be returned */
    int returnVal;
    returnVal = arr[size - 1];
    size--;
    /*printf("Size if not empty: %d\n",size); */
    *value = returnVal;
    return returnVal;
  }
}

/* prints the stack in 3 formats: decimal, hex, and character */
void printStack(int format) {
  if (format == 0) {
    int i;
    for (i = 0; i < size; i++)
      printf("%d ", (int) arr[i]);
    printf("\n");
  } else if (format == 1) {
    int j;
    for (j = 0; j < size; j++)
      printf("%x ", arr[j]);
    printf("\n");
  } else if (format == 2) {
    int k;
    for (k = 0; k < size; k++)
      printf("%c ", arr[k]);
    printf("\n");
  } 
}
