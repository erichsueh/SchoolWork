#---------------------------------------------------------------
# Assignment:           TEST CASE 1 - LAB 3
# Due Date:             29/OCT/2012
# Name:                 Taylor Lloyd
#			Alejandro Ramirez
# Unix ID:              ramirezs
# Lecture Section:      TA 	
# Instructor:           Nelson Amaral
# Lab Section:          All
# Teaching Assistant:   Alejandro Ramirez
#---------------------------------------------------------------

#---------------------------------------------------------------
# This is one test case to test for a program that does nothing
# except initializing the cache. 
#
# Register Usage:
#
#       N/A
#
# Expected Output (other than not having any load/run errors):
#
# 	N/A
#
# INSTRUCTIONS: Paste your code at the end and execute. 
#---------------------------------------------------------------



#------------------------------
# Associative Cache Common Testing Environment
# Author: Taylor Lloyd
# Date: June 14, 2012
#------------------------------

.data
	newline: .asciiz "\n"
	space: .asciiz " "
	lruMsg: .asciiz "Current LRU:\n"

	.align 2

	commonAssociativity: .word 8
.text

main:
	#Start the lab's cache system
	lw	$a0 commonAssociativity
	jal	startCache
	


	#Die
	li	$v0 10
	syscall

#-----------
# printBinary
# 
# Prints the binary value of a register
#
# ARGS: $a0 = the register to print
#-----------
printBinary:
	move	$t0 $a0
	li	$t2 0
	li	$t3 32
	j	printBinary_loop

	printBinary_space:
		srl	$t4 $t2 2
		sll	$t4 $t4 2
		bne	$t2 $t4 printBinary_loop
		
		#If we got here, print a space
		la	$a0 space
		li	$v0 4
		syscall

	printBinary_loop:
		srl	$a0 $t0 31
		sll	$t0 $t0 1
		li	$v0 1
		syscall
		addi	$t2 $t2 1
		bne	$t2 $t3 printBinary_space

	la	$a0 newline
	li	$v0 4
	syscall
	jr	$ra

#-----------
# printLRU
# ARGS: $a0 = bitstream, $a1 = entry count
# Asks for the LRU and then prints it to screen in Binary
#
#-----------
printLRU:
	move	$t0 $a0
	la	$a0 lruMsg
	li	$v0 4
	syscall
	move	$a0 $t0

	addi	$sp $sp -4
	sw	$ra 0($sp)

	#implicitly passes arguments through
	jal	getLRU
	
	move	$a0 $v0

	jal	printBinary

	lw	$ra 0($sp)
	addi	$sp $sp 4
	
	jr	$ra

#---------------------------------------------------------------
# Paste your code below
#        ||
#       _||_
#       \  /
#        \/
#---------------------------------------------------------------
