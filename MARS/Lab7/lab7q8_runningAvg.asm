# Moving 4 average implementing in assembly
# Lab 7.8 - Miro Manestar

	.data
arr:	.word 1, 2, 3, 4, 2, 8, 3, 1, 9, 10, 11, 13, 14, 15, 18, 27, 4, 9, 1, 19
len:	.word 20
space:	.asciiz  " "          # space to insert between numbers"
	.text
	
main:
	la $a0, arr
	lw $a1, len
	
	move $s0, $a0
	move $s1, $a1
	
	jal printr
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	move $a0, $s0
	
	jal run_avg
	jal printr
	
	move $s0, $a0
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	move $a0, $s0
	
	li $v0, 10
	syscall
	
run_avg:	# Takes the running avg of the last 4 values in an array and replaces it
	addi $t0, $a0, 8 # Set t0 to 3rd item in array (Bottom bound)
	sll $t7, $a1, 2 # Multiply length by 4
	add $t1, $t7, $a0 # Set t1 to address of last item in array (Index value)
for:	
	ble $t1, $t0, endf # If t0 gets beyond it's bounds, exit
	
	lw $t2, ($t1) # Load value of arr[i]
	lw $t3, -4($t1) # arr[i - 1]
	lw $t4, -8($t1) # arr[i - 2]
	lw $t5, -12($t1) # arr[i - 3
	
	add $t2, $t2, $t3 # Add arr[i] ... arr[i - 3] together
	add $t2, $t2, $t4
	add $t2, $t2, $t5
	
	srl $t2, $t2, 2 # Divide the result by 2
	sw $t2, 0($t1) # Replace the value at arr[i] with the runningFourAvg
	
	addi $t1, $t1, -4 # Deincrement the index to arr[i - 1]
	j for
endf:
	jr $ra
	
	
### PRINT ARRAY ROUTINE

printr:	# Routine to print array
	add $t0, $a0, $zero # Set t0 to array addr
	add $t1, $a1, $zero # Set t1 to length of array
out:
	lw $a0, 0($t0) # Print current item in array
	li $v0, 1
	syscall
	
	la $a0, space # Print a space
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4 # Increment address to print from
	addi $t1, $t1, -1 # Deincrement counter
	bgtz $t1, out # If counter is 0 or less, exit
	
	jr $ra
