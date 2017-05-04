	.data
newline:	.asciiz	"\n"
g_s:	.word	0:50
g_a:	.word	2147483647
	.text
part:
	sw $ra -4($sp)
	addi $sp $sp -28
	addi $t0 $sp 0
	lw $t1 16($sp)
	sw $t1 0($t0)
	addi $t0 $sp 4
	lw $t1 20($sp)
	sw $t1 0($t0)
	lw $t0 0($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 0($t0)
	addi $t0 $sp 8
	sw $t1 0($t0)
	addi $t0 $sp 16
	lw $t1 0($sp)
	sw $t1 0($t0)
	addi $t0 $sp 20
	lw $t1 4($sp)
	sw $t1 0($t0)
for.loop.1.start:
for.loop.2.start:
	lw $t0 16($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 0($t0)
	lw $t0 8($sp)
	slt $t2 $t1 $t0
	beq $t2 $0 for.loop.2.end
for.loop.2.next:
	lw $t0 16($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 16
	sw $t2 0($t0)
	j for.loop.2.start
for.loop.2.end:
for.loop.3.start:
	lw $t0 20($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 0($t0)
	lw $t0 8($sp)
	sgt $t2 $t1 $t0
	beq $t2 $0 for.loop.3.end
for.loop.3.next:
	lw $t0 20($sp)
	li $t1 1
	sub $t2 $t0 $t1
	addi $t0 $sp 20
	sw $t2 0($t0)
	j for.loop.3.start
for.loop.3.end:
	lw $t0 16($sp)
	lw $t1 20($sp)
	sge $t2 $t0 $t1
	beq $t2 $0 if.1.end
	lw $t0 20($sp)
	move $v0 $t0
	addi $sp $sp 28
	lw $ra -4($sp)
	jr $ra
if.1.end:
	lw $t0 16($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 0($t0)
	addi $t0 $sp 12
	sw $t1 0($t0)
	lw $t0 16($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 20($sp)
	li $t2 4
	mul $t3 $t1 $t2
	la $t1 g_s
	add $t1 $t1 $t3
	lw $t2 0($t1)
	sw $t2 0($t0)
	lw $t0 20($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 12($sp)
	sw $t1 0($t0)
for.loop.1.next:
	j for.loop.1.start
for.loop.1.end:
	li $v0 0
	addi $sp $sp 28
	lw $ra -4($sp)
	jr $ra
qsort:
	sw $ra -4($sp)
	addi $sp $sp -16
	addi $t0 $sp 0
	lw $t1 4($sp)
	sw $t1 0($t0)
	addi $t0 $sp 4
	lw $t1 8($sp)
	sw $t1 0($t0)
	lw $t0 0($sp)
	lw $t1 4($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 if.2.end
	addi $t0 $sp -12
	lw $t1 0($sp)
	sw $t1 0($t0)
	addi $t0 $sp -8
	lw $t1 4($sp)
	sw $t1 0($t0)
	jal part
	addi $t0 $sp 8
	sw $v0 0($t0)
	addi $t0 $sp -12
	lw $t1 0($sp)
	sw $t1 0($t0)
	addi $t0 $sp -8
	lw $t1 8($sp)
	sw $t1 0($t0)
	jal qsort
	lw $t0 8($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp -12
	sw $t2 0($t0)
	addi $t0 $sp -8
	lw $t1 4($sp)
	sw $t1 0($t0)
	jal qsort
if.2.end:
	li $v0 0
	addi $sp $sp 16
	lw $ra -4($sp)
	jr $ra
main:
	sw $ra -4($sp)
	addi $sp $sp -12
	li $v0 5
	syscall
	addi $t0 $sp 0
	sw $v0 0($t0)
	addi $t0 $sp 4
	li $t1 0
	sw $t1 0($t0)
for.loop.4.start:
	lw $t0 4($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.4.end
	lw $t0 4($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	li $v0 5
	syscall
	sw $v0 0($t0)
for.loop.4.next:
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	j for.loop.4.start
for.loop.4.end:
	addi $t0 $sp -12
	li $t1 0
	sw $t1 0($t0)
	lw $t0 0($sp)
	li $t1 1
	sub $t2 $t0 $t1
	addi $t0 $sp -8
	sw $t2 0($t0)
	jal qsort
	addi $t0 $sp 4
	li $t1 0
	sw $t1 0($t0)
for.loop.5.start:
	lw $t0 4($sp)
	lw $t1 0($sp)
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.5.end
	lw $t0 4($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_s
	add $t0 $t0 $t2
	lw $t1 0($t0)
	move $a0 $t1
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
for.loop.5.next:
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	j for.loop.5.start
for.loop.5.end:
	li $v0 0
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
