#-------------------------------
# Student MIPStoARM Testing file
# Author: Taylor Lloyd
# Date: July 4, 2012
#
#-------------------------------

.data
	.align 2
binary:
	.space 2052
noFileStr:
	.asciiz "Couldn't open specified file.\n"
.text
main:
	lw	$a0 4($a1)	# Put the filename pointer into $a0
	li	$a1 0		# Read Only
	li	$a2 0		# No Mode Specified
	li	$v0 13		# Open File
	syscall
	bltz	$v0 main_err	# Negative means open failed

	move	$a0 $v0		#point at open file
	la	$a1 binary	# write into my binary space
	li	$a2 2048	# read a file of at max 2kb
	li	$v0 14		# Read File Syscall
	syscall
	la	$t0 binary
	add	$t0 $t0 $v0	#point to end of binary space

	li	$t1 0xFFFFFFFF	#Place ending sentinel
	sw	$t1 0($t0)

	la	$a0 binary	#prepare pointer for assignment
	jal	MIPStoARM

	sll	$v0 $v0 2	# instructions are words (*4)
	add	$s0 $v0 $v1	# $s0 = last instruction

	main_parseLoop:
		bgt	$v1 $s0 main_doneParse	# If we're done, jump to complete
		lw	$a0 0($v1)		# Load the word to parse

		addi	$sp $sp -8
		sw	$s0 4($sp)
		sw	$v1 0($sp)

		jal	parseARM

		lw	$s0 4($sp)
		lw	$v1 0($sp)
		addi	$sp $sp 8

		addi	$v1 $v1 4

		j	main_parseLoop

	main_doneParse:
		j	main_done
	main_err:
		la	$a0 noFileStr
		li	$v0 4
		syscall
	main_done:
		li	$v0 10
		syscall
.data
	andStr: .asciiz "AND"
	orStr: .asciiz "OR"
	addStr: .asciiz "ADD"
	subStr: .asciiz "SUB"
	movStr: .asciiz "MOV"
	cmpStr: .asciiz "CMP"
	bxStr: .asciiz "BX"
	bStr: .asciiz "B"
	balStr: .asciiz "BAL"
	unkStr: .asciiz "???"

	eqStr: .asciiz "EQ "
	geStr: .asciiz "GE "
	gtStr: .asciiz "GT "
	blankStr: .asciiz " "
	rStr: .asciiz "R"
	sStr: .asciiz "S "

	arStr: .asciiz " AR "
	lrStr: .asciiz " LR "
	llStr: .asciiz " LL "
	rorStr: .asciiz " ROR "
	
	sepStr: .asciiz ", "
	nlStr: .asciiz "\n"

.text

#-----------
# parseARM
#
# ARGS: a0=ARM instruction
#
# t8 = (0=data processing)/(1=branch)/(2=bx)
# s0 = instruction
#
#-----------
parseARM:
	move	$s0 $a0

	#ID Branches
	li	$t8 2

	sll	$t0 $a0 4
	srl	$t0 $t0 28

	#B
	la	$t9 bStr
	li	$t1 0x0A
	beq	$t0 $t1 parseARM_pOp
	
	#BAL
	la	$t9 balStr
	li	$t1 0x0A
	beq	$t0 $t1 parseARM_pOp

	#Isolate and identify DataProc OpCodes
	sll	$t0 $a0 7
	srl	$t0 $t0 28	#Isolate opCode

	li	$t8 0
	
	#AND
	la	$t9 andStr
	li	$t1 0x00
	beq	$t0 $t1 parseARM_pOp
	
	#OR
	la	$t9 orStr
	li	$t1 0x0C
	beq	$t0 $t1 parseARM_pOp

	#ADD
	la	$t9 addStr
	li	$t1 0x04
	beq	$t0 $t1 parseARM_pOp

	#SUB
	la	$t9 subStr
	li	$t1 0x02
	beq	$t0 $t1 parseARM_pOp

	#MOV
	la	$t9 movStr
	li	$t1 0x0D
	beq	$t0 $t1 parseARM_pOp

	#CMP
	la	$t9 cmpStr
	li	$t1 0x0A
	beq	$t0 $t1 parseARM_pOp

	li	$t8 1

	#BX
	la	$t9 bxStr
	li	$t1 0x09
	beq	$t0 $t1 parseARM_pOp

	li	$t8 0
	la	$t9 unkStr

	parseARM_pOp:
		move	$a0 $t9
		li	$v0 4
		syscall

# ID the condition
	srl	$t0 $s0 28

	#Always
	la	$t9 blankStr
	li	$t1 0x0E
	beq	$t0 $t1 parseARM_pCond

	#Equals
	la	$t9 eqStr
	li	$t1 0x00
	beq	$t0 $t1 parseARM_pCond

	#GreaterThan
	la	$t9 gtStr
	li	$t1 0x0C
	beq	$t0 $t1 parseARM_pCond

	#GreaterThan
	la	$t9 geStr
	li	$t1 0x0A
	beq	$t0 $t1 parseARM_pCond

	la	$t9 unkStr

	parseARM_pCond:
		move	$a0 $t9
		li	$v0 4
		syscall
	
	beqz	$t8 parseARM_DataProc
	li	$t0 2
	beq	$t8 $t0 parseARM_Branch
	j	parseARM_BX

parseARM_DataProc:
	lui	$t0 0x0010
	and	$t0 $t0 $s0	#mask out sign bit
	beqz	$t0 padp_noStat
	
	la	$a0 sStr
	li	$v0 4
	syscall	
	
	padp_noStat:

	#If CMP, don't print Dest
	sll	$t0 $s0 7
	srl	$t0 $t0 28
	li	$t1 0x0A
	beq	$t0 $t1 padp_noDest
	#Otherwise go ahead

	sll	$t0 $s0 16
	srl	$t0 $t0 28	#isolate Destination
	
	la	$a0 rStr
	li	$v0 4
	syscall

	move	$a0 $t0
	li	$v0 1
	syscall			#print register

	la	$a0 sepStr
	li	$v0 4
	syscall			#space for next
	
	padp_noDest:

	#If MOV, don't print Operand 1
	sll	$t0 $s0 7
	srl	$t0 $t0 28
	li	$t1 0x0D
	beq	$t0 $t1 padp_noOp1
	#Otherwise go ahead

	sll	$t0 $s0 12
	srl	$t0 $t0 28	#isolate operand 1
	
	la	$a0 rStr
	li	$v0 4
	syscall

	move	$a0 $t0
	li	$v0 1
	syscall			#print register

	la	$a0 sepStr
	li	$v0 4
	syscall			#space for next

	padp_noOp1:
	lui	$t0 0x0200	#mask out immediate indicator
	and	$t0 $t0 $s0
	
	bnez	$t0 padp_imm
	j	padp_reg


	padp_imm:
		andi	$t0 $s0 0x00FF	#immediate value
		srl	$t1 $s0 8	
		andi	$t1 $t1 0x0F	#Rotation value
		sll	$t1 $t1 1	#double it
		
		ror	$a0 $t0 $t1
		li	$v0 1
		syscall
		j	parseARM_done

	padp_reg:
		andi	$t0 $s0 0x0F	#mask out last register
		la	$a0 rStr
		li	$v0 4
		syscall

		move	$a0 $t0
		li	$v0 1
		syscall			#print register
		
		sll	$t0 $s0 25	#isolate shift type
		srl	$t0 $t0 30

		li	$t1 0x00	#logical left
		la	$a0 llStr
		beq	$t0 $t1 padp_shift

		li	$t1 0x01	#logical right
		la	$a0 lrStr
		beq	$t0 $t1 padp_shift

		li	$t1 0x02	#arithmetic right
		la	$a0 arStr
		beq	$t0 $t1 padp_shift

		li	$t1 0x03	#rotate right
		la	$a0 rorStr
		beq	$t0 $t1 padp_shift

		la	$a0 unkStr	

	padp_shift:
		#Don't print if we're shifting 0
		andi	$t0 $s0 0x0010	#isolate reg/imm
		bnez	$t0 padp_pShift	#always print if register
		sll	$t0 $s0 20	#isolate shift amount
		srl	$t0 $t0 27
		beqz	$t0 parseARM_done

	padp_pShift:
		#Now we definitely want to print
		li	$v0 4		#print rotation type
		syscall

		andi	$t0 $s0 0x0010	#isolate reg/imm
		bnez	$t0 padp_shiftReg

	padp_shiftVal:
		sll	$t0 $s0 20	#isolate shift amount
		srl	$a0 $t0 27

		li	$v0 1
		syscall

		j	parseARM_done

	padp_shiftReg:
		la	$a0 rStr
		li	$v0 4
		syscall			#print register 'R'

		sll	$t0 $s0 20	#isolate shift register
		srl	$a0 $t0 28

		li	$v0 1
		syscall			#print register value

		j	parseARM_done

parseARM_Branch:
	li	$t0 0x00FFFFFF		#mask lower 24 bits
	and	$t0 $t0 $s0		#branch offset

	sll	$t0 $t0 8
	sra	$a0 $t0 6		#sign extend, *4

	li	$v0 1
	syscall				#print the branch offset

	j	parseARM_done
parseARM_BX:
	la	$a0 rStr
	li	$v0 4
	syscall			#print register 'R'

	andi	$a0 $s0 0x0F	#isolate the register
	li	$v0 1
	syscall

	j	parseARM_done
parseARM_done:
	la	$a0 nlStr
	li	$v0 4
	syscall

	jr	$ra

######################### Student Code Begins Here #########################

