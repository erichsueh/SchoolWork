#---------------------------------------------------------------
# Assignment:           TEST CASE 2 - LAB 5
# Due Date:             21/NOV/2012
#			Alejandro Ramirez
# Unix ID:              ramirezs
# Lecture Section:      TA 	
# Instructor:           Nelson Amaral
# Lab Section:          All
# Teaching Assistant:   Alejandro Ramirez
#---------------------------------------------------------------

#---------------------------------------------------------------
# n! calculator. Uses most of the instructions except logical
# operators and some shift instructions
#
# Expected output: 
#
# Step 1: run "spim -file test.s > output.out
# Step 2: run "diff -y --left-column TestCase1.out output.out"
#              (corroborate that both files are equal) 
#---------------------------------------------------------------


.data
.text
.globl main   

main:	

srl $8, $8, 31 # Create the "zero" artificially 
addi $9, $8, 10	# (n)
addi $a1, $8, 1 #Constant 1
sub $a0, $9, $a1 # (n-1)
		


addi $v0, $8, 0 #Init return value


factorial:

addi $t4, $8, 0
add $a3, $8, $a0

multi:

add $t4, $t4, $9    #multiply n ($9) times n-1 ($a0)
sub $a3, $a3, $a1
beq $a3, $8, cont
beq $8, $8, multi

cont:
add $v0, $8, $t4

add $9, $8, $2     # set n and n-1 with the new values
sub $a0, $a0, $a1
sub $a2, $a0, $a1

bgez $a2, factorial #branch if we still got iterations to go

add $4, $8, $2   #print the number
addi $2, $8, 1
syscall
	
jr $ra
