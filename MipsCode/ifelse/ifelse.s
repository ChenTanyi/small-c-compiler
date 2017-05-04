	.data
newline:	.asciiz	"\n"
g_s:	.word	0:50
	.text
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
for.loop.1.start:
	li $t0 1
	beq $t0 $0 for.loop.1.end
	lw $t0 0($sp)
	li $t1 10
	sle $t2 $t0 $t1
	beq $t2 $0 if.1.end
	lw $t0 4($sp)
	lw $t1 0($sp)
	sgt $t2 $t0 $t1
	beq $t2 $0 if.2.else
	j for.loop.1.end
	j if.2.end
if.2.else:
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
if.2.end:
if.1.end:
	lw $t0 0($sp)
	li $t1 1
	sub $t2 $t0 $t1
	addi $t0 $sp 0
	sw $t2 0($t0)
	lw $t0 4($sp)
	li $t1 1
	add $t2 $t0 $t1
	addi $t0 $sp 4
	sw $t2 0($t0)
for.loop.1.next:
	j for.loop.1.start
for.loop.1.end:
	lw $t0 0($sp)
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
	li $v0 0
	addi $sp $sp 12
	lw $ra -4($sp)
	jr $ra
