# Simple for loop implementation
# Lab 7.2 - Miro Manestar

# C CODE TO BE IMPLEMENTED IN ASSEMBLY
# int sum = 0;
# for (int i = 0; i < 10; i++)
#	sum +=i;

main:
	add $s0, $zero, $zero # Set i to 0
	add $s1, $zero, $zero # Set sum to 0
for:
	bge $s0, 10, end_for # Jump to end_for if 
	add $s1, $s1, $s0 # sum += i
	add $s0, $s0, 1 # i++
	j for
end_for:
	li $v0, 10
	syscall