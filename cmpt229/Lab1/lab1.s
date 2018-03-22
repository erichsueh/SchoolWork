##########################
#Eric Hsueh
#1384955
#This program takes a int from the terminal, and then flips it from big endian to little endian
################

main:
	li $v0 5   #read
	syscall

	addi $a0 $v0 0 #add to a0

	srl $t0 $a0 24 #shift and then add to temp value $t0
	
	andi $t1 $a0 0xFF0000 #mask then shift and add to temp value $t1
	srl $t1 $t1 8
	
	andi $t2 $a0 0x00FF00 #mask then shift and add to temp value $t2
	sll $t2 $t2 8

	sll $t3 $a0 24 #shift then add to temp value $t3
	
	add $a0 $t0 $t1 #add values together at a0 to print
	add $a0 $a0 $t2
	add $a0 $a0 $t3
	
	li $v0 1 #print
	syscall
