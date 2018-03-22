#Eric Hsueh
#1384955
#makefile for assignment 3

a3chat: a3chat.c
	gcc a3chat.c -o a3chat

clean:
	-rm -f a3chat core
	-rm -f submit.tar

tar:
	tar -cvf submit.tar a3chat.c Makefile ProjectReport.pdf
