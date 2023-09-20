# An assembly function which takes an integer and converts into in IEEE 754 single-preicision floating-point notation
# Lab 9.1 - Miro Manestar

	.data
prompt:	.asciiz "Enter an integer: "
	.text
main:
	la $a0, prompt # Print prompt
	li $v0, 4
	syscall
	
	li $v0, 5 # Take integer input
	syscall
	move $a0, $v0
	
	jal inttofloat
	move $a0, $v0 # Move output to input for next function
	
	jal print_hex
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	j main # Infinite loop
	
	li $v0, 10 # Exit (Not as if it'll ever run)
	syscall

#### INT_TO_FLOAT ROUTINE ####
# Input:  $a0: int
# Output: $v0: float
	
inttofloat:
	move $t0, $a0 # Load input integer into $t0
	
	li $t6, 0
	beqz $t0, end_inttofloat  # If input is zero, do nothing
	
	li $t7, 0 # Set sign bit to 0
	bgez $t0, iskip # If number is negative, we must grab its magnitude
	xori $t0, $t0, 0xFFFFFFFF # NOT the bits
	addi $t0, $t0, 1 # Add 1 to undo two's complement
	li $t7, 1 # Set sign bit to 1
iskip:
	li $t1, 31 # Keep track of the index of the current bit to check
	li $t2, 0 # Value of the current bit we're checking
ffor: # Calculate the exponent
	bgtz $t2, end_ffor # If we've checked all the bits, end
	beqz $t1, end_ffor # Alternatively, if the input is 0 then it doesn't matter
	
	srlv $t2, $t0, $t1 # Shift current bit to beginning
	
	bgtz $t2, end_ffor
	
	addi $t1, $t1, -1 # Deincrement index
	j ffor
end_ffor:
	li $t2, 32
	sub $t3, $t2, $t1 # Lop off the most significant bit
	sllv $t6, $t0, $t3 # Shift to actually lop it off
	
	srl $t6, $t6, 9 # Shift value so its it occupies bits 1-23
	
	addi $t1, $t1, 127 # Get the exponent section value
	sll $t1, $t1, 23 # Shfit the exponent into its proper position for the standard
	add $t6, $t6, $t1 # Add it into the final register
	
	sll $t7, $t7, 31 # Put the sign bit in the correct spot
	add $t6, $t6, $t7 # Add it into the final answer

	move $v0, $t6 # Return output
end_inttofloat:
	jr $ra

#### PRINT HEX ROUTINE ####
# Input:  $a0: int
# Output: none

	.data
pre:	.asciiz "0x"
	.align 2
map:	.word 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70
	.text
print_hex:
	move $t7, $a0 # Save integer input parameter to be translated
	
	la $a0, pre # Print pre
	li $v0, 4
	syscall
	
	bnez $t7, hskip # If zero, just print zero and exit
	li $a0, 0
	li $v0, 1
	syscall
hskip:
	li $t0, 28 # Begin at the last four bits of the word
	la $t1, map # Load map array
	li $t4, 0 # Register to check if we have encountered nonzero values yet
hfor:
	bltz $t0, end_hfor
	
	srlv $t2, $t7, $t0 # Set the four bits of interest to the beginning of $t1
	andi $t2, 0xF # Mask out everything except the first 4 bits
	or $t4, $t4, $t2 # Or to check if value has previously ever not been 0
	
	beqz $t4, pskip # Skip print if values have only been 0

	sll $t2, $t2, 2 # Multiply by four to stay on word boundary in map
	add $t3, $t1, $t2 # Get the address of what we want from the map
	
	lw $a0, 0($t3) # Print value from map
	li $v0, 11
	syscall
pskip:
	add $t0, $t0, -4	# Move to next four bits
	j hfor
end_hfor:
	jr $ra
