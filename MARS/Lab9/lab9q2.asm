# Takes two floating-point variables and adds them together
# Lab 9.2 - Miro Manestar

	.data
prompt:	.asciiz "Enter a decimal number: "
	.text
	
main:
	la $a0, prompt # Print prompt
	li $v0, 4
	syscall
	
	addi $sp, $sp, -12
	
	li $v0, 6 # Take first floating point
	syscall
	swc1 $f0, 4($sp) # Push floating point to stack
	
	la $a0, prompt # Print prompt
	li $v0, 4
	syscall
	
	li $v0, 6 # Take second floating point
	syscall
	swc1 $f0, 8($sp) # Push floating point to stack
	
	lw $a0, 4($sp) # Get the floats ready for input to addition function
	lw $a1, 8($sp)
	
	jal addf
	sw $v0, 12($sp) 
	
	lwc1 $f12, 12($sp) # Print result
	li $v0, 2
	syscall
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	addi $sp, $sp, 12 # Move back stack pointer
	li $v0, 10 # Exit
	syscall
	
#### ADDITION FUNCTION ROUTINE ####
# Input:	  $a0: float
#	  $a1: float
# Output: $v0: float

addf:
	addi $sp, $sp, -8 # Save s registers in use to stack
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	addu $t0, $a0, $a1 # Add the two inptus together
	beqz $t0, skip_f # If zero, skip to the end
	
	andi $t6, $a0, 0x7FFFFFFF # Remove sign bit
	andi $t7, $a1, 0x7FFFFFFF # Remove sign bit
		
	bge $t6, $t7, setgreater # Which float is larger?
	
	move $s0, $a1
	move $s1, $a0
	j skip0
setgreater:
	move $s0, $a0 # Load floating point values to be added
	move $s1, $a1
skip0:
	andi $t0, $s0, 0x7f800000 # Isolate exponent value from larger float
	andi $t1, $s1, 0x7f800000 # Isolate exponent value from smaller float
	
	sub $t7, $t0, $t1 # Get the exponent difference
	srl $t7, $t7, 23 # Shift the difference so it's the actual value
	
	bgt $t7, 31, skip_overflow # Return larger value if exp diff is greater than 31
	
	andi $t2, $s0, 0x007fffff # Isolate the significand from the larger number
	andi $t3, $s1, 0x007fffff # Isolate the significand from the smaller number
	
	addi $t2, $t2, 0x00800000 # Ensure the implied bit at the end is inserted
	addi $t3, $t3, 0x00800000 # Ensure the implied bit at the end is inserted
	srlv $t3, $t3, $t7 # Shift the smaller float to match exponent of larger float
	
	andi $t0, $s0, 0x80000000 # Isolate the sign bit
	andi $t1, $s1, 0x80000000
	
	beq $t0, $t1, signs_equal # If the sign bit is the same, add, otherwise subtract
	
	andi $t4, $s0, 0x7FFFFFFF # Remove sign bit
	andi $t5, $s1, 0x7FFFFFFF # Remove sign bit
	beq $t4, $t5, skip_f # If the floats have have value but different sign, return 0
	
	subu $t6, $t2, $t3 # Subtract the significands
	j skip_signs
signs_equal:
	add $t6, $t3, $t2 # Add the significands
skip_signs:
	andi $t0, $s0, 0x7f800000 # Isolate the larger exponent (Again...)
	srl $t0, $t0, 23 # Shift to the beginning
	subi $t0, $t0, 127 # Remove bias
	
	li $t1, 31 # Keep track of the index of the current bit to check
	li $t2, 0 # Value of the current bit we're checking
ffor: # Calculate the exponent offset
	srlv $t2, $t6, $t1 # Shift current bit to beginning
	
	bgtz $t2, end_ffor
	
	addi $t1, $t1, -1 # Deincrement index
	j ffor
end_ffor:
	addi $t2, $t1, -23 # Figure out how much to shift by to get most significant bit into 24th slot
	
	bgez $t2, positive # Determine which direction to shift by
	
	abs $t2, $t2
	sllv $t6, $t6, $t2 # Shift most significant bit into 24th slot
	sub $t0, $t0, $t2 # Get new exponent value
	j skip_pos
positive:
	srlv $t6, $t6, $t2 # Shift most significant bit into 24th slot
	add $t0, $t0, $t2 # Get new exponent value
skip_pos:
	addi $t0, $t0, 127 # Add bias to new exponent
	andi $t6, $t6, 0x007fffff # Ensure the significand is by itself and clear implied bit
	
	sll $t0, $t0, 23 # Shift exponent into correct position
	add $t6, $t6, $t0 # Add exponent onto significand
	
	andi $t4, $s0, 0x80000000 # Isolate sign bit
	add $t6, $t6, $t4 # Add the sign bit 
	
	move $v0, $t6
	j end_f
skip_f:
	li $v0, 0
	j end_f
skip_overflow:

	move $v0, $s0
	j end_f
end_f:
	lw $s0, 4($sp) # Reload s registers saved in stack
	lw $s1, 8($sp)
	addi $sp, $sp, 8
	
	jr $ra