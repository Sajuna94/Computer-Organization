.data
	xList: .space 400
	dot: .ascii ","

.text
.globl main

main:
	
	la $s0, xList
	
	# int i = 0
	li $t0, 1
	# x[0] = 1
	sw $t0, 0($s0)
	# set x[1~100] = 0
	main_loop:
		sll $t1, $t0, 2
		add $t1, $s0, $t1
		sw $zero, 0($t1)
		
		add $t0, $t0, 1
		blt $t0, 100, main_loop
	
	# input n
	li $v0, 5
	syscall
	move $s1, $v0
	
	# start rec
	move $a0, $s1
	move $a1, $s0
	jal fact
	
	# print
	move $a0, $s1
	move $a1, $s0
	jal print
	
	# exit
	li $v0, 10
	syscall
	
print:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0
	move $t0, $zero
	print_loop:
		sll $t1, $t0, 2
		add $t1, $a1, $t1
		
		lw $a0, 0($t1)
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, dot
		syscall
		
		addi $t0, $t0, 1
		blt $t0, $s0, print_loop
	
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
fact:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	# $s0 = n
	move $s0, $a0

	# if n < 2
	blt $s0, 2, LESS_THAN_2
	
	# if x[n] != 0, return x[n]
	sll $t0, $s0, 2
	add $t0, $a1, $t0
	lw $v0, 0($t0)
	bne $v0, $zero, exit_fact

	# $s1 = f(n - 1)
	addi $a0, $s0, -1
	jal fact
	move $s1, $v0

	# $s1 = $s1 + f(n - 2)
	addi $a0, $s0, -2
	jal fact
	add $v0, $s1, $v0
	
	set_value:
		# x[n] = $s1
		sll $t1, $s0, 2
		add $t1, $a1, $t1
		sw $v0, 0($t1)
	exit_fact:
		# return
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		
	LESS_THAN_2:
		li $v0, 1
		j set_value