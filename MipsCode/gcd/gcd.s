	.data
newline:	.asciiz	"\n"
	.text
gcd:
	sw $ra -4($sp)
	addi $sp $sp -12
	lw $t0 4($sp)
	sleu $t1 $t0 $0
	beq $t1 $0 if.1.end
	lw $t0 0($sp)
	move $v0 $t0
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
if.1.end:
	addi $t0 $sp -12
	lw $t1 4($sp)
	sw $t1 0($t0)
	lw $t0 0($sp)
	lw $t1 4($sp)
	rem $t2 $t0 $t1
	addi $t0 $sp -8
	sw $t2 0($t0)
	jal gcd
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
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
	addi $t0 $sp -12
	lw $t1 0($sp)
	sw $t1 0($t0)
	addi $t0 $sp -8
	lw $t1 4($sp)
	sw $t1 0($t0)
	jal gcd
	move $a0 $v0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	li $v0 0
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
