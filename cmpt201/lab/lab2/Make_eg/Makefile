#
# Creates draw1 executable.  'make clean' will rm all object files,
# the executable and a core file.
#
# Style is not what is expected for asn1 (e.g., no header in this
# comment), and this Makefile is not guaranteed to work with your
# code.  Feel free to use it as a template, though. Don't forget
# that you'll need to change draw0 to draw1.
#
# -lm used here only so Makefile looks closer to proper asn1 Makefile

draw0: draw0.o
	gcc -Wall -std=c99 -o draw0 draw0.o -lm

draw0.o: draw0.c draw0.h
	gcc -Wall -std=c99 -c draw0.c -g

clean:
	-rm -f *.o draw0 core
