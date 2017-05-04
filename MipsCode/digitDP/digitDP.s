	.data
newline:	.asciiz	"\n"
g_dp:	.word	0:520
g_digit:	.word	0:10
	.text
dfs:
	sw $ra -4($sp)
	addi $sp $sp -36
	addi $t0 $sp 0
	lw $t1 12($sp)
	sw $t1 0($t0)
	addi $t0 $sp 4
	lw $t1 16($sp)
	sw $t1 0($t0)
	addi $t0 $sp 8
	lw $t1 20($sp)
	sw $t1 0($t0)
	addi $t0 $sp 12
	lw $t1 24($sp)
	sw $t1 0($t0)
	addi $t0 $sp 16
	lw $t1 28($sp)
	sw $t1 0($t0)
	lw $t0 0($sp)
	sleu $t1 $t0 $0
	beq $t1 $0 if.1.end
	lw $t0 4($sp)
	li $t1 0
	seq $t2 $t0 $t1
	lw $t0 8($sp)
	sgtu $t2 $t2 $0
	sgtu $t0 $t0 $0
	and $t1 $t2 $t0
	beq $t1 $0 if.2.else
	li $v0 1
	addi $sp $sp 36
	lw $ra -4($sp)
	jr $ra
	j if.2.end
if.2.else:
	li $v0 0
	addi $sp $sp 36
	lw $ra -4($sp)
	jr $ra
if.2.end:
if.1.end:
	lw $t0 16($sp)
	sleu $t1 $t0 $0
	lw $t0 0($sp)
	li $t2 208
	mul $t3 $t0 $t2
	lw $t0 4($sp)
	li $t2 16
	mul $t4 $t0 $t2
	add $t0 $t4 $t3
	lw $t2 8($sp)
	li $t3 8
	mul $t4 $t2 $t3
	add $t2 $t4 $t0
	lw $t0 12($sp)
	li $t3 4
	mul $t4 $t0 $t3
	add $t0 $t4 $t2
	la $t2 g_dp
	add $t2 $t2 $t0
	lw $t3 0($t2)
	li $t0 1
	sub $t2 $0 $t0
	sne $t0 $t3 $t2
	sgtu $t1 $t1 $0
	sgtu $t0 $t0 $0
	and $t2 $t1 $t0
	beq $t2 $0 if.3.end
	lw $t0 0($sp)
	li $t1 208
	mul $t2 $t0 $t1
	lw $t0 4($sp)
	li $t1 16
	mul $t3 $t0 $t1
	add $t0 $t3 $t2
	lw $t1 8($sp)
	li $t2 8
	mul $t3 $t1 $t2
	add $t1 $t3 $t0
	lw $t0 12($sp)
	li $t2 4
	mul $t3 $t0 $t2
	add $t0 $t3 $t1
	la $t1 g_dp
	add $t1 $t1 $t0
	lw $t2 0($t1)
	move $v0 $t2
	addi $sp $sp 36
	lw $ra -4($sp)
	jr $ra
if.3.end:
	addi $t0 $sp 20
	li $t1 0
	sw $t1 0($t0)
	lw $t0 16($sp)
	beq $t0 $0 if.4.else
	lw $t0 0($sp)
	li $t1 4
	mul $t2 $t0 $t1
	la $t0 g_digit
	add $t0 $t0 $t2
	lw $t1 0($t0)
	addi $t0 $sp 24
	sw $t1 0($t0)
	j if.4.end
if.4.else:
	addi $t0 $sp 24
	li $t1 9
	sw $t1 0($t0)
if.4.end:
	addi $t0 $sp 28
	li $t1 0
	sw $t1 0($t0)
for.loop.1.start:
	lw $t0 28($sp)
	lw $t1 24($sp)
	sle $t2 $t0 $t1
	beq $t2 $0 for.loop.1.end
	lw $t0 0($sp)
	li $t1 1
	sub $t2 $t0 $t1
	addi $t0 $sp -24
	sw $t2 0($t0)
	lw $t0 4($sp)
	li $t1 10
	mul $t2 $t0 $t1
	lw $t0 28($sp)
	add $t1 $t2 $t0
	li $t0 13
	rem $t2 $t1 $t0
	addi $t0 $sp -20
	sw $t2 0($t0)
	lw $t0 28($sp)
	li $t1 3
	seq $t2 $t0 $t1
	lw $t0 12($sp)
	sgtu $t0 $t0 $0
	sgtu $t2 $t2 $0
	and $t1 $t0 $t2
	lw $t0 8($sp)
	sgtu $t0 $t0 $0
	sgtu $t1 $t1 $0
	or $t2 $t0 $t1
	addi $t0 $sp -16
	sw $t2 0($t0)
	lw $t0 28($sp)
	li $t1 1
	seq $t2 $t0 $t1
	addi $t0 $sp -12
	sw $t2 0($t0)
	lw $t0 28($sp)
	lw $t1 24($sp)
	seq $t2 $t0 $t1
	lw $t0 16($sp)
	sgtu $t0 $t0 $0
	sgtu $t2 $t2 $0
	and $t1 $t0 $t2
	addi $t0 $sp -8
	sw $t1 0($t0)
	jal dfs
	lw $t0 20($sp)
	add $t1 $t0 $v0
	addi $t0 $sp 20
	sw $t1 0($t0)
for.loop.1.next:
	lw $t0 28($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 28
	sw $t2 0($t0)
	j for.loop.1.start
for.loop.1.end:
	lw $t0 16($sp)
	sleu $t1 $t0 $0
	beq $t1 $0 if.5.end
	lw $t0 0($sp)
	li $t1 208
	mul $t2 $t0 $t1
	lw $t0 4($sp)
	li $t1 16
	mul $t3 $t0 $t1
	add $t0 $t3 $t2
	lw $t1 8($sp)
	li $t2 8
	mul $t3 $t1 $t2
	add $t1 $t3 $t0
	lw $t0 12($sp)
	li $t2 4
	mul $t3 $t0 $t2
	add $t0 $t3 $t1
	la $t1 g_dp
	add $t1 $t1 $t0
	lw $t0 20($sp)
	sw $t0 0($t1)
if.5.end:
	lw $t0 20($sp)
	move $v0 $t0
	addi $sp $sp 36
	lw $ra -4($sp)
	jr $ra
fun:
	sw $ra -4($sp)
	addi $sp $sp -12
	addi $t0 $sp 0
	lw $t1 4($sp)
	sw $t1 0($t0)
	addi $t0 $sp 4
	li $t1 0
	sw $t1 0($t0)
for.loop.2.start:
	lw $t0 0($sp)
	beq $t0 $0 for.loop.2.end
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	li $t0 4
	mul $t1 $t2 $t0
	la $t0 g_digit
	add $t0 $t0 $t1
	lw $t1 0($sp)
	li $t2 10
	rem $t3 $t1 $t2
	sw $t3 0($t0)
	lw $t0 0($sp)
	li $t1 10
	div $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
for.loop.2.next:
	j for.loop.2.start
for.loop.2.end:
	addi $t0 $sp -24
	lw $t1 4($sp)
	sw $t1 0($t0)
	addi $t0 $sp -20
	li $t1 0
	sw $t1 0($t0)
	addi $t0 $sp -16
	li $t1 0
	sw $t1 0($t0)
	addi $t0 $sp -12
	li $t1 0
	sw $t1 0($t0)
	addi $t0 $sp -8
	li $t1 1
	sw $t1 0($t0)
	jal dfs
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
main:
	sw $ra -4($sp)
	addi $sp $sp -24
	addi $t0 $sp 4
	li $t1 0
	sw $t1 0($t0)
for.loop.3.start:
	lw $t0 4($sp)
	li $t1 10
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.3.end
	addi $t0 $sp 8
	li $t1 0
	sw $t1 0($t0)
for.loop.4.start:
	lw $t0 8($sp)
	li $t1 13
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.4.end
	addi $t0 $sp 12
	li $t1 0
	sw $t1 0($t0)
for.loop.5.start:
	lw $t0 12($sp)
	li $t1 2
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.5.end
	addi $t0 $sp 16
	li $t1 0
	sw $t1 0($t0)
for.loop.6.start:
	lw $t0 16($sp)
	li $t1 2
	slt $t2 $t0 $t1
	beq $t2 $0 for.loop.6.end
	lw $t0 4($sp)
	li $t1 208
	mul $t2 $t0 $t1
	lw $t0 8($sp)
	li $t1 16
	mul $t3 $t0 $t1
	add $t0 $t3 $t2
	lw $t1 12($sp)
	li $t2 8
	mul $t3 $t1 $t2
	add $t1 $t3 $t0
	lw $t0 16($sp)
	li $t2 4
	mul $t3 $t0 $t2
	add $t0 $t3 $t1
	la $t1 g_dp
	add $t1 $t1 $t0
	li $t0 1
	sub $t2 $0 $t0
	sw $t2 0($t1)
for.loop.6.next:
	lw $t0 16($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 16
	sw $t2 0($t0)
	j for.loop.6.start
for.loop.6.end:
for.loop.5.next:
	lw $t0 12($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 12
	sw $t2 0($t0)
	j for.loop.5.start
for.loop.5.end:
for.loop.4.next:
	lw $t0 8($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 8
	sw $t2 0($t0)
	j for.loop.4.start
for.loop.4.end:
for.loop.3.next:
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
	j for.loop.3.start
for.loop.3.end:
for.loop.7.start:
	li $v0 5
	syscall
	addi $t0 $sp 0
	sw $v0 0($t0)
	li $t0 1
	sub $t1 $0 $t0
	lw $t0 0($sp)
	sle $t2 $t0 $t1
	beq $t2 $0 if.6.end
	j for.loop.7.end
if.6.end:
	addi $t0 $sp -8
	lw $t1 0($sp)
	sw $t1 0($t0)
	jal fun
	move $a0 $v0
	li $v0 1
	syscall
	li $v0 4
	la $a0 newline
	syscall
for.loop.7.next:
	j for.loop.7.start
for.loop.7.end:
	li $v0 0
	addi $sp $sp 24
	lw $ra -4($sp)
	jr $ra
