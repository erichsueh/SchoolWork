#Eric Hsueh
#1384955
#makefile for assignment 4

a4vmsim: a4vmsim.c
	g++ -Wall -o a4vmsim a4vmsim.c -lm

clean:
	-rm -f a4vmsim core
	-rm -f submit.tar

tar:
	tar -cvf submit.tar a4vmsim.c Makefile ProjectReport.pdf

