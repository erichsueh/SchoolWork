#-------------------------------
# Timer countdown
# Author: Eric Hsueh
# Date: November 16th, 2015
#
#-------------------------------


.data
str:	.asciiz "Seconds="
sline:	.asciiz "\n"
time:	.byte 8,8,8,8,8,'0','0',':','0','0'

.text
	.globl __start
__start:	#write seconds to screen using poll
	la $t0 str
loop:
	lb $t1 0($t0)
	beqz $t1 readpoll
	
writepoll:
	lw $t2 0xffff0008
	andi $t2 $t2 0x01
	beqz $t2 writepoll
	sw $t1 0xffff000C
	addi $t0 $t0 1
	j loop
	
readpoll:	#read seconds to screen using poll
	lw $t2 0xffff0000
	andi $t2 $t2 0x01
	beqz $t2 readpoll
	lw $t1 0xffff0004
	li $t0 10
	beq $t0 $t1 done
	addi $t3 $t1 -47
	blez $t3 readpoll
	addi $t3 $t1 -58
	bgez $t3 readpoll
	
writepolltwo:	#write what you typed
	lw $t2 0xffff0008
	andi $t2 $t2 0x01
	beqz $t2 writepolltwo
	sw $t1 0xffff000C
	addi $t1 $t1 -48
	add $t4 $t4 $t1
	mult $t0 $t4
	mflo $t4
	j readpoll
	
done:	#finished input, now processing it and printing new line
	li $t3 0
	div $t4 $t0
	mflo $t4
	la $t0 sline
	
printnew:	
	lb $t1 0($t0)
	beqz $t1 initialtime	
looppoll:
	lw $t2 0xffff0008
	andi $t2 $t2 0x01
	beqz $t2 looppoll
	sw $t1 0xffff000C
	addi $t0 $t0 1
	j printnew
	
initialtime:	#finish input and set the initial time for the number in $t4
	la $a0 time
	li $t0 60
	div $t4 $t0
	mfhi $t2
	mflo $t1
	
	li $t0 10
	
	div $t1 $t0
	mflo $t1
	addi $t1 $t1 48
	sb $t1 5($a0)
	mfhi $t1
	addi $t1 $t1 48
	sb $t1 6($a0)
	
	div $t2 $t0
	mflo $t1
	addi $t1 $t1 48
	sb $t1 8($a0)
	mfhi $t1
	addi $t1 $t1 48
	sb $t1 9($a0)
	
starttimer:	#print out the first timer
	lb $t1 0($a0)
	beqz $t1 timer
	
pollloop2:
	lw $t2 0xffff0008
	andi $t2 $t2 0x01
	beqz $t2 pollloop2
	sw $t1 0xffff000C
	addi $a0 $a0 1
	j starttimer
	
timer:	#start timer	
	
	beqz $t4 exitprogram
	li $t0 100
	mtc0 $t0 $11
	li $t0 0
	mtc0 $t0 $9
	
	mfc0 $9 $t6
	
	li $t7 100
	li $t6 0


timeloop: #loop to check for timer = 1 second or keypresses
	mfc0 $t6 $9
	beq $t7 $t6 donetime

	lw $t2 0xffff0000
	andi $t2 $t2 0x01
	beqz $t2 timeloop
	lw $t1 0xffff0004
	li $t0 113
	beq $t0 $t1 exitprogram

	j timeloop
	
donetime:#time = 1 second later
	la $a0 time
	li $t0 60
	div $t4 $t0
	mfhi $t2
	mflo $t1
	
	li $t0 10
	
	div $t1 $t0
	mflo $t1
	addi $t1 $t1 48
	sb $t1 5($a0)
	mfhi $t1
	addi $t1 $t1 48
	sb $t1 6($a0)
	
	div $t2 $t0
	mflo $t1
	addi $t1 $t1 48
	sb $t1 8($a0)
	mfhi $t1
	addi $t1 $t1 48
	sb $t1 9($a0)
	addi $t4 $t4 -1

updatetimer:	#print out the new timer
	lb $t1 0($a0)
	beqz $t1 doneupdate
	
loopfortimerpol: 
	lw $t2 0xffff0008
	andi $t2 $t2 0x01
	beqz $t2 loopfortimerpol
	sw $t1 0xffff000C
	addi $a0 $a0 1
	j updatetimer
	
doneupdate:#check if timer == 0 and if so then quit
	#lw $t2 0xffff0000
	#andi $t2 $t2 0x01
	beqz $t4 exitprogram
	li $t0 100
	mtc0 $t0 $11
	mtc0 $zero $9
	j timeloop
exitprogram:	
	li $v0 10
	syscall



#didn't actually use kdata
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
	
	li $v0 10
	syscall
