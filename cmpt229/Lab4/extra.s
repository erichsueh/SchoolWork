
	.kdata
s1:	.word 0
s2:	.word 0
	.ktext 0x80000180
# Select the appropriate one for the mode in which SPIM is compiled.
	.set noat
	move $k1 $at		# Save $at
	.set at
	sw $v0 s1		# Not re-entrant and we can't trust $sp
	sw $a0 s2		# But we need to use these registers

	#mfc0 $k0 $13		# Cause register
	#srl $a0 $k0 2		# Extract ExcCode Field
	#andi $a0 $a0 0x1f

	li $v0 60
	div $k0 $v0
	mflo $k1
	
	li $v0 10
printtext:	
	div $k1 $v0
	mflo $k1
	addi $k1 $k1 48
	sb $k1 5($a0)
	mfhi $k1
	addi $k1 $k1 48
	sb $k1 6($a0)

	div $k0 $v0
	mfhi $k1
	div $k1 $v0
	mflo $k1
	addi $k1 $k1 48
	sb $k1 8($a0)
	mfhi $k1
	addi $k1 $k1 48
	sb $k1 9($a0)

ktexttime:	#print out the first timer
	lb $k1 0($a0)
	beqz $k1 ktextdone
	
ktextloop:
	lw $v0 0xffff0008
	andi $v0 $v0 0x01
	beqz $v0 ktextloop
	sw $k1 0xffff000C
	addi $a0 $a0 1
	j ktexttime
ktextdone:	
	
	lw $v0 s1
	lw $a0 s2
	addi $k0 $k0 -1	
	
	li $t0 100
	mtc0 $t0 $11
	li $t0 0
	mtc0 $t0 $t9

	eret
