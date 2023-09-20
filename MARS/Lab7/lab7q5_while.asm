# While loop implementation
# Lab 7.5 - Miro Manestar

# Implement the following
# int space_count(char* mystr) {
#	while (mystr[i] != 0) {
#		if (mystr[i] == 0x20)
#			count++;
#		i++;
#	}
#	return count;
# }

	.data
test:	.asciiz "HELLO I AM BOB"
	.text
	
main:
	la $a0, test
	jal space_count
	
	li $v0, 10
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