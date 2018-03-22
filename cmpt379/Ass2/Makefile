#Eric Hsueh
#1384955
#makefile for assignment 2

a2rchat: a2rchat.c
	gcc a2rchat.c -o a2rchat

clean:
	-rm -f a2rchat core
	-rm -f submit.tar

tar:
	tar -cvf submit.tar a2rchat.c Makefile Readme.txt a2answers.pdf
