#	Does not have the style and quality required for the 201 assignments.

CC = gcc
CFLAGS = -Wall -std=c99

both: eg1 eg2

eg1: eg.c
	$(CC) $(CFLAGS) -o eg1 eg.c
eg2: eg.c
	$(CC) $(CFLAGS) -DMAKECOPY  -o eg2 eg.c

clean:
	-rm -f eg1 eg2
