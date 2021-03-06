#-------------------------------
# Tables lab Student Testbed
# Author: Eric Hsueh
# Date: Sept 23rd, 2015
#
#-------------------------------

.data
	
oxStr:		.asciiz "0x"
nlStr:  	.asciiz "\n"
countStr1:	.asciiz " occurred "
countStr2: 	.asciiz " times.\n"
badHexStr:	.asciiz "Value entered is not a proper hexadecimal number.\n"
val:		.word 0x00
input:		.space 20
numarray:	.space 800
numcounter:	.space 200
programcounter:	.space 2
.align 2

.text

main:
	#Initialize the counts table
	jal	createCountTable

nextNumber:	
	#Print '0x' as a prompt
	la	$a0 oxStr
	li	$v0 4
	syscall	

	#Read in a number
	la	$a0 input
	li	$a1 20
	li	$v0 8
	syscall
	
	#Call student code to parse it
	jal	readHex
#	li $v0 12345678
	sw	$v0 val
	beq     $v1, $zero, goodHex

	#Bad hexdecimal value: print error message and go back for another number
	la      $a0, badHexStr
	li      $v0, 4
	syscall
	j       nextNumber

goodHex:	
	#Print the hex number using student code
	move	$a0 $v0
	jal printHex

	#Print the count info
	li	$v0 4
	la	$a0 countStr1
	syscall

	#Call student code to get the count for this one
	lw	$a0 val
	jal	countIntegerAccess	

	#Print out the remainder
	move	$a0 $v0
	li	$v0 1
	syscall
	
	li	$v0 4
	la 	$a0 countStr2
	syscall
	
	#Loop back for another go!
	j	nextNumber
	
readHex:
	li $t0 0	#clearing all registers
	li $t1 0
	li $t2 0
	li $t3 0
	li $t4 0
	li $t5 0
	li $t6 0
	li $t7 0
	addi $t0 $a0 0
	loop:	
		lb $t1 0($t0)
		slti $t6 $t1 48
		li $t2 57
		slt $t7 $t2 $t1
		or $v1 $t6 $t7
		beq $t5 $v1 numbers
	
		slti $t6 $t1 65 
		li $t2 70
		slt $t7 $t2 $t1
		or $v1 $t6 $t7
		beq $t5 $v1 capslet
	
		slti $t6 $t1 97
		li $t2 103
		slt $t7 $t2 $t1
		or $v1 $t6 $t7
		beq $t5 $v1 smallet
	
	invalid:
		jr $ra
	
	numbers:
		addi $t0 $t0 1
		addi $t3 $t3 1
		li $t4 8
		sll $v0 $v0 4
		addi $t5 $t1 -48
		add $v0 $v0 $t5
		li $t5 0
		bne $t4 $t3 loop
		jr $ra
	
	capslet:
		addi $t0 $t0 1
		addi $t3 $t3 1
		li $t4 8
		sll $v0 $v0 4
		addi $t5 $t1 -55
		add $v0 $v0 $t5
		li $t5 0
		bne $t4 $t3 loop
		jr $ra
	
	smallet:
		addi $t0 $t0 1
		addi $t3 $t3 1
		li $t4 8
		sll $v0 $v0 4
		addi $t5 $t1 -87
		add $v0 $v0 $t5
		li $t5 0
		bne $t4 $t3 loop
		jr $ra

printHex:
	li $t0 0	#clearing all registers and setting some values
	li $t1 0
	li $t2 9
	li $t4 32
	li $t5 0
	li $t7 0
	
	addi $t0 $a0 0
	
	la	$a0 oxStr
	li	$v0 4
	syscall

	loop2:
		li $t3 0
		#li $t5 0
		li $t6 28
		li $t2 9
		
		#add $t5 $t5 $t7
		#sub $t6 $t6 $t7
		
		sllv $t1 $t0 $t7
		srlv $t1 $t1 $t6
		
		slt $t2 $t1 $t2
		bne $t2 $t3 numbprint
		beq $t2 $t3 strprint
	
	strprint:
		addi $t7 $t7 4
		move $a0 $t1
		addi $a0 $a0 87
		li $v0 11
		syscall
		bne $t7 $t4 loop2
		jr $ra
	numbprint:
		addi $t7 $t7 4
		move $a0 $t1
		addi $a0 $a0 48
		li $v0 11
		syscall
		bne $t7 $t4 loop2
		jr $ra

createCountTable:
	
	jr $ra

countIntegerAccess:
	li $t0 0
	lb $t6 programcounter
	la $t7 numarray
	la $t5 numcounter
	addi $t6 $t6 4
	loop3: #start of loop
		li $t1 0
		add $t1 $t1 $t7
		add $t1 $t1 $t0
		lw $t2 0($t1)
		beq $t2 $a0 isin 	#if value in array, jump to isin
		addi $t0 $t0 4
	
		bne $t0 $t6 loop3 	#loop back if not null
		
		sw $a0 0($t1)		#save a0 into array
		li $v0 1		#set $v0 as 1

		addi $t0 $t0 -4
		li $t1 4
		div $t0 $t1
		mflo $t0

		add $t5 $t5 $t0
		sb $v0 0($t5)		#the counter to 1 and save
		#addi $t6 $t6 4
		sb $t6 programcounter
		jr $ra

	isin:				#if variable is already in array
		li $t1 4		#divide counter by 4
		div $t0 $t1
		mflo $t0

		add $t5 $t5 $t0
		lb $v0 0($t5)
		addi $v0 $v0 1
		sb $v0 0($t5)

		jr $ra
