# Takes a number input and converts it into hexadecimal
# Lab 8.1 - Miro Manestar
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
	
	jal print_hex
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	li $v0, 10 # Exit
	syscall


##### PRINT HEX ROUTINE ###########
	.data
pre:	.asciiz "0x"
map:	.word 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70
	.text
print_hex:
	move $t7, $a0 # Save integer input parameter to be translated
	
	la $a0, pre # Print pre
	li $v0, 4
	syscall
	
	li $t0, 28
	la $t1, map
	li $t4, 0
for:
	bltz $t0, endf
	
	srlv $t2, $t7, $t0 # Set the four bits of interest to the beginning of $t1
	andi $t2, 0xF # Mask out everything except the first 4 bits
	or $t4, $t4, $t2
	
	beqz $t4, skip

	sll $t2, $t2, 2 # Multiply by four to stay on word boundary in map
	add $t3, $t1, $t2 # Get the address of what we want from the map
	lw $a0, 0($t3) # Print value from map
	li $v0, 11
	syscall
skip:
	add $t0, $t0, -4	
	j for
endf:
	jr $ra