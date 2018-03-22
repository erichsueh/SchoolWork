#---------------------------------------------------------------
# Assignment:           TEST CASE 3 - LAB 5
# Due Date:             21/NOV/2012
#   Alejandro Ramirez
# Unix ID:              ramirezs
# Lecture Section:      TA  
# Instructor:           Nelson Amaral
# Lab Section:          All
# Teaching Assistant:   Alejandro Ramirez
#---------------------------------------------------------------

#---------------------------------------------------------------
# Endianness converter. Uses most logical operators. If the least
# significant byte != 0x00, then it sra by 16.  
#
# Expected output: 
#
# Step 1: run "spim -file test.s > output.out
# Step 2: run "diff -y --left-column TestCase1.out output.out"
#              (corroborate that both files are equal) 
#---------------------------------------------------------------


main:

srl $12, $12, 31 # Create the "zero" artificially 

addi  $s0, $12, 0xFF 
and $t1 $a0 $t0 
sll $v0 $t1 24 

addi  $s0, $12, 8 
sllv $t0 $t0 $s0 
and $t1 $a0 $t0 
sll $t1 $t1 8 
or $v0 $v0 $t1 

sll $t0 $t0 8 
and $t1 $a0 $t0 
srlv $t1 $t1 $s0 
or $v0 $v0 $t1 

sll $t0 $t0 8 
and $t1 $a0 $t0 
srl $t1 $t1 24 
or $v0 $v0 $t1

andi  $v0, $v0, 0xFF

beq  $8, $v0, shift
beq $8, $8, done

shift: 

sra  $v0, $v0, 16

done: 

jr $ra  # Return
