# Function to count the number of spaces in a string
# Lab 7.6 - Miro Manestar

	.data
str1:	.asciiz "The quick brown fox jumps over the dog. ad df dfad"
str2:	.asciiz "My name is Miro Manestar."
	.text

main:
	la $a0, str1 # Load addr of str into $a0
	jal space_count
	
	move $a0, $v0 # Print count of str1
	li $v0, 1
	syscall
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	la $a0, str2
	jal space_count
	
	move $a0, $v0 # Print count of str2
	li $v0, 1
	syscall
	
	li $v0, 10 # Exit
	syscall

space_count:
	add $t0, $zero, $zero # Count
	add $t1, $a0, $zero # i
while:
	
	lbu $t2, ($t1) # Load value of mystr[i] into $t2
	beq $t2, $zero, end_w # If mystr[i] == 0, go to end_w
	bne $t2, 0x20, endif # If mystr[i] is a space, increment
	addi $t0, $t0, 1 # Increment count by 1
endif:	
	addi $t1, $t1, 1 # Increment i by 1
	j while
end_w:
	addi $v0, $t0, 0 # Return count
	jr $ra
