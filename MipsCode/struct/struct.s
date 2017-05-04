	.data
newline:	.asciiz	"\n"
g_c.a:	.word	0
g_c.x:	.word	0
g_d.w:	.word	0
g_l:	.word	0
	.text
main:
	sw $ra -4($sp)
	addi $sp $sp -36
	la $t0 g_c.a
	li $t1 1
	sw $t1 0($t0)
	la $t0 g_c.x
	li $t1 2
	sw $t1 0($t0)
	la $t0 g_d.w
	li $t1 3
	sw $t1 0($t0)
	addi $t0 $sp 4
	li $t1 4
	sw $t1 0($t0)
	addi $t0 $sp 8
	li $t1 5
	sw $t1 0($t0)
	addi $t0 $sp 12
	li $t1 6
	sw $t1 0($t0)
	addi $t0 $sp 16
	li $t1 7
	sw $t1 0($t0)
	addi $t0 $sp 20
	li $t1 8
	sw $t1 0($t0)
	addi $t0 $sp 24
	li $t1 9
	sw $t1 0($t0)
	addi $t0 $sp 28
	li $t1 10
	sw $t1 0($t0)
	lw $t0 g_c.a
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 g_c.x
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 g_d.w
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 4($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 8($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 12($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 16($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 20($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 24($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 28($sp)
	move $a0 $t0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	li $v0 0
	addi $sp $sp 36
	lw $ra -4($sp)
	jr $ra
