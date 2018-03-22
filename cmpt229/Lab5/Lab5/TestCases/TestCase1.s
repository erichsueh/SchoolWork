#---------------------------------------------------------------
# Assignment:           TEST CASE 1 - LAB 4
# Due Date:             21/NOV/2012
#			Alejandro Ramirez
# Unix ID:              ramirezs
# Lecture Section:      TA 	
# Instructor:           Nelson Amaral
# Lab Section:          All
# Teaching Assistant:   Alejandro Ramirez
#---------------------------------------------------------------

#---------------------------------------------------------------
# A simple average calculator for two different numbers.
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
	
addi $9, $8, 2			
addi $10, $8, 8

add $4, $10, $9

srl $4, $4, 2

addi $2, $8, 1
syscall
	
jr $ra

