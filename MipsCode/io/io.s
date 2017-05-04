	.data
newline:	.asciiz	"\n"
	.text
main:
	sw $ra -4($sp)
	addi $sp $sp -12
	li $v0 5
	syscall
	addi $t0 $sp 0
	sw $v0 0($t0)
	li $v0 5
	syscall
	addi $t0 $sp 4
	sw $v0 0($t0)
	lw $t0 0($sp)
	lw $t1 4($sp)
	add $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	li $v0 0
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
