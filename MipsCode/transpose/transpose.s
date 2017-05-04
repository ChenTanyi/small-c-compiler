	.data
newline:	.asciiz	"\n"
g_s:	.word	0:25
	.text
transpose:
	sw $ra -4($sp)
	addi $sp $sp -116
	addi $t0 $sp 0
	lw $t1 108($sp)
	sw $t1 0($t0)
	addi $t0 $sp 104
	li $t1 0
	sw $t1 0($t0)
for.loop.1.start:
	lw $t0 104($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.1.end
	addi $t0 $sp 108
	li $t1 0
	sw $t1 0($t0)
for.loop.2.start:
	lw $t0 108($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.2.end
	lw $t0 104($sp)
	li $t1 20
	mul $t2 $t0 $t1
	lw $t0 108($sp)
	li $t1 4
	mul $t3 $t0 $t1
	add $t0 $t3 $t2
	addi $t1 $sp 4
	add $t1 $t1 $t0
	lw $t0 108($sp)
	li $t2 20
	mul $t3 $t0 $t2
	lw $t0 104($sp)
	li $t2 4
	mul $t4 $t0 $t2
	add $t0 $t4 $t3
	la $t2 g_s
	add $t2 $t2 $t0
	lw $t3 0($t2)
	sw $t3 0($t1)
for.loop.2.next:
	lw $t0 108($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 108
	sw $t2 0($t0)
	j for.loop.2.start
for.loop.2.end:
for.loop.1.next:
	lw $t0 104($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 104
	sw $t2 0($t0)
	j for.loop.1.start
for.loop.1.end:
	addi $t0 $sp 104
	li $t1 0
	sw $t1 0($t0)
for.loop.3.start:
	lw $t0 104($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.3.end
	addi $t0 $sp 108
	li $t1 0
	sw $t1 0($t0)
for.loop.4.start:
	lw $t0 108($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.4.end
	lw $t0 104($sp)
	li $t1 20
	mul $t2 $t0 $t1
	lw $t0 108($sp)
	li $t1 4
	mul $t3 $t0 $t1
	add $t0 $t3 $t2
	la $t1 g_s
	add $t1 $t1 $t0
	lw $t0 104($sp)
	li $t2 20
	mul $t3 $t0 $t2
	lw $t0 108($sp)
	li $t2 4
	mul $t4 $t0 $t2
	add $t0 $t4 $t3
	addi $t2 $sp 4
	add $t2 $t2 $t0
	lw $t3 0($t2)
	sw $t3 0($t1)
for.loop.4.next:
	lw $t0 108($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 108
	sw $t2 0($t0)
	j for.loop.4.start
for.loop.4.end:
for.loop.3.next:
	lw $t0 104($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 104
	sw $t2 0($t0)
	j for.loop.3.start
for.loop.3.end:
	li $v0 0
	addi $sp $sp 116
	lw $ra -4($sp)
	jr $ra
main:
	sw $ra -4($sp)
	la $t0 g_s
	addi $t0 $t0 0
	li $t1 1
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 4
	li $t1 2
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 8
	li $t1 3
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 12
	li $t1 4
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 16
	li $t1 5
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 20
	li $t1 6
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 24
	li $t1 7
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 28
	li $t1 8
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 32
	li $t1 9
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 36
	li $t1 10
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 40
	li $t1 11
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 44
	li $t1 12
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 48
	li $t1 13
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 52
	li $t1 14
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 56
	li $t1 15
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 60
	li $t1 16
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 64
	li $t1 17
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 68
	li $t1 18
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 72
	li $t1 19
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 76
	li $t1 20
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 80
	li $t1 21
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 84
	li $t1 22
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 88
	li $t1 23
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 92
	li $t1 24
	sw $t1 0($t0)
	la $t0 g_s
	addi $t0 $t0 96
	li $t1 25
	sw $t1 0($t0)
	addi $sp $sp -16
	li $v0 5
	syscall
	addi $t0 $sp 0
	sw $v0 0($t0)
	addi $t0 $sp -8
	lw $t1 0($sp)
	sw $t1 0($t0)
	jal transpose
	addi $t0 $sp 4
	li $t1 0
	sw $t1 0($t0)
for.loop.5.start:
	lw $t0 4($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.5.end
	addi $t0 $sp 8
	li $t1 0
	sw $t1 0($t0)
for.loop.6.start:
	lw $t0 8($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.6.end
	lw $t0 4($sp)
	li $t1 20
	mul $t2 $t0 $t1
	lw $t0 8($sp)
	li $t1 4
	mul $t3 $t0 $t1
	add $t0 $t3 $t2
	la $t1 g_s
	add $t1 $t1 $t0
	lw $t2 0($t1)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
for.loop.6.next:
	lw $t0 8($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 8
	sw $t2 0($t0)
	j for.loop.6.start
for.loop.6.end:
for.loop.5.next:
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	j for.loop.5.start
for.loop.5.end:
	li $v0 0
	addi $sp $sp 16
	lw $ra -4($sp)
	jr $ra
