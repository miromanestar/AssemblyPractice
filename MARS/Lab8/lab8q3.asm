# Function which returns the length of a char* array (string), excluding the null pointer
# Lab 8.3 - Miro Manestar

	.data
str:	.asciiz "Test abc"
	.text
	
main:
	la $a0, str
	
	jal strlen
	
	li $v0, 10 # Exit
	syscall

strlen:
	move $t7, $a0 # Move addr of str into $s0
	
	li $t0, 0 # Use $t0 as length counter

for:	
	add $t1, $t7, $t0 # Get address of character to be checked
	lbu $t2, 0($t1) # Load the character into $t2
	
	beqz $t2, endf # If char is 0, exit
	addi $t0, $t0, 1 # Increment length counter
	j for
endf:	
	move $v0, $t0 # Return value
	jr $ra