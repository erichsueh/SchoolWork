#---------------------------
#Eric Hsueh
#Array and Checking valid input
#Oct 2nd 2015
#
#--------------------------
.data					#my data
numarray:	.space 800
numcounter:	.space 200
programcounter:	.space 2
.align 2

readHex:				#read hex
	li $t0 0			#Clearing all registers
	li $t1 0
	li $t2 0
	li $t3 0
	li $t4 0
	li $t5 0
	li $t6 0
	li $t7 0
	addi $t0 $a0 0
	loop:				#loop
		lb $t1 0($t0)		#check numbers between 30-39
		slti $t6 $t1 48
		li $t2 57
		slt $t7 $t2 $t1
		or $v1 $t6 $t7
		beq $t5 $v1 numbers
	
		slti $t6 $t1 65 	#checks numbers between 41-46
		li $t2 70
		slt $t7 $t2 $t1
		or $v1 $t6 $t7
		beq $t5 $v1 capslet
	
		slti $t6 $t1 97		#checks numbers 61-66
		li $t2 103
		slt $t7 $t2 $t1
		or $v1 $t6 $t7
		beq $t5 $v1 smallet
	
	invalid:			#if invalid, exit
		jr $ra
	
	numbers:			#if its a number then set v0 to the number
		addi $t0 $t0 1
		addi $t3 $t3 1
		li $t4 8
		sll $v0 $v0 4
		addi $t5 $t1 -48
		add $v0 $v0 $t5
		li $t5 0
		bne $t4 $t3 loop
		jr $ra
	
	capslet:			#if capital letter, sets v0 to lowerlet
		addi $t0 $t0 1
		addi $t3 $t3 1
		li $t4 8
		sll $v0 $v0 4
		addi $t5 $t1 -55
		add $v0 $v0 $t5
		li $t5 0
		bne $t4 $t3 loop
		jr $ra
	
	smallet:			#if lowercase = v0 = lowercase
		addi $t0 $t0 1
		addi $t3 $t3 1
		li $t4 8
		sll $v0 $v0 4
		addi $t5 $t1 -87
		add $v0 $v0 $t5
		li $t5 0
		bne $t4 $t3 loop
		jr $ra


printHex:				#prints hexideciaml 1 at a time
	li $t0 0
	li $t1 0
	li $t2 9
	li $t3 0
	li $t4 32
	li $t5 0
	li $t6 0
	li $t7 0
	
	addi $t0 $a0 0
	
	la	$a0 oxStr
	li	$v0 4
	syscall

	loop2:				#loop
		li $t3 0		#if number is a str, then
		#li $t5 0		#jump to strprint
		li $t6 28		#else, jump to intprint
		li $t2 9		#then print out 1 int at a time
		
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
