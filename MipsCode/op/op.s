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
	lw $t0 0($sp)
	lw $t1 4($sp)
	sub $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	mul $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	div $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	rem $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	and $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	or $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	xor $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	not $t1 $t0
	move $a0 $t1
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 2
	sllv $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 2
	srav $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	slt $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sgt $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sle $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sge $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	seq $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sne $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sgtu $t0 $t0 $0
	sgtu $t1 $t1 $0
	and $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sgtu $t0 $t0 $0
	sgtu $t1 $t1 $0
	or $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	sleu $t1 $t0 $0
	move $a0 $t1
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 4($sp)
	li $t1 1
	sub $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 1
	sub $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 2
	mul $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 2
	div $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 31
	and $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 21
	or $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 3
	rem $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	li $t1 40
	xor $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 4($sp)
	li $t1 2
	sllv $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 4($sp)
	li $t1 2
	srav $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	addi $t0 $sp 0
	lw $t1 4($sp)
	sw $t1 0($t0)
	move $a0 $t1
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	seq $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sne $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sle $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	slt $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sge $t2 $t0 $t1
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	lw $t0 0($sp)
	lw $t1 4($sp)
	sgt $t2 $t0 $t1
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
