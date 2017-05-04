	.data
newline:	.asciiz	"\n"
g_a:	.word	0:5000
g_mod:	.word	1000000007
g_n:	.word	0
	.text
main:
	sw $ra -4($sp)
	la $t0 g_a
	addi $t0 $t0 0
	li $t1 1
	sw $t1 0($t0)
	la $t0 g_a
	addi $t0 $t0 4
	li $t1 1
	sw $t1 0($t0)
	addi $sp $sp -8
	li $v0 5
	syscall
	la $t0 g_n
	sw $v0 0($t0)
	addi $t0 $sp 0
	li $t1 2
	sw $t1 0($t0)
for.loop.1.start:
	lw $t0 0($sp)
	lw $t1 g_n
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.1.end
	lw $t0 0($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_a
	add $t0 $t0 $t2
	lw $t1 0($sp)
	li $t2 2
	sub $t3 $t1 $t2
	li $t1 4
	mul $t2 $t3 $t1
	la $t1 g_a
	add $t1 $t1 $t2
	lw $t3 0($t1)
	lw $t1 0($sp)
	li $t2 1
	sub $t4 $t1 $t2
	li $t1 4
	mul $t2 $t4 $t1
	la $t1 g_a
	add $t1 $t1 $t2
	lw $t4 0($t1)
	add $t1 $t3 $t4
	lw $t2 g_mod
	rem $t3 $t1 $t2
	sw $t3 0($t0)
for.loop.1.next:
	lw $t0 0($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	j for.loop.1.start
for.loop.1.end:
	lw $t0 g_n
	li $t1 1
	sub $t2 $t0 $t1
	li $t0 4
	mul $t1 $t2 $t0
	la $t0 g_a
	add $t0 $t0 $t1
	lw $t2 0($t0)
	move $a0 $t2
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
	li $v0 0
	addi $sp $sp 8
	lw $ra -4($sp)
	jr $ra
