.data
	matrixA: .space 36
	matrixA1: .space 36
	matrixA2: .space 36
	space: .asciiz " "
	nextLine: .asciiz "\n"
.text
.globl main

main:
	la $a0, matrixA
	jal inputMatrix
	
	la $a0, matrixA
	la $a1, matrixA1
	li $a2, 3
	jal transposeMatrixA1
	
	
	
	la $a0, matrixA
	la $a1, matrixA2
	la $a2, 3
	jal transposeMatrixA2
	
	la $a0, matrixA1
	jal outputMatrix
	la $a0, matrixA2
	jal outputMatrix
	
	li $v0, 10
	syscall

inputMatrix: # (A[3][3])
	move $t2, $a0

	move $t0, $zero
	input_loop1:
		move $t1, $zero
		input_loop2:
			li $v0, 5
			syscall
			sw $v0, 0($t2)
			
			addi $t2, $t2, 4
			addi $t1, $t1, 1
			blt $t1, 3, input_loop2
		addi $t0, $t0, 1
		blt $t0, 3, input_loop1
	jr $ra

transposeMatrixA1: # (int A[3][3], int T[3][3], int size)
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s1, 4($sp) # T
	sw $s0, 0($sp) # A

	move $s0, $a0
	move $s1, $a1

	move $t0, $zero
	A1_loop1:
		move $t1, $zero
		A1_loop2:
			# $t2 = A[i][j]
			mul $t2, $t0, $a2
			add $t2, $t2, $t1
			sll $t2, $t2, 2
			add $t2, $t2, $s0
			lw $t2, 0($t2)
			
			# $t3 = &T[i][j]
			mul $t3, $t1, $a2
			add $t3, $t3, $t0
			sll $t3, $t3, 2
			add $t3, $t3, $s1
			
			# T[j][i] = A[i][j]
			sw $t2, 0($t3), 
	
			addi $t1, $t1, 1
			blt $t1, $a2, A1_loop2
		addi $t0, $t0, 1
		blt $t0, $a2, A1_loop1
	
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra

transposeMatrixA2: #(int *B, int*T, int size)
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s1, 4($sp) 
	sw $s0, 0($sp) 

	move $s0, $a0 # ptrB
	move $s1, $a1 # prtT
	addi $t0, $zero, 1
	
	A2_loop:
		# $t2 = B + (size + size)
		mul $t2, $a2, $a2
		sll $t2, $t2, 2
		add $t2, $a0, $t2
		
		lw $t4, 0($s0)
		sw $t4, 0($s1) # ptrT = ptrB
		
		blt $t0, $a2, THEN
		j ELSE
		THEN:
			sll $t5, $a2, 2
			add $s1, $s1, $t5 # ptrT += size
			addi $t0, $t0, 1
			j END_IF
		ELSE:
			# $t3 = (size * (size - 1) - 1)
			addi $t3, $a2, -1
			mul $t3, $t3, $a2
			addi $t3, $t3, -1
			sll $t3, $t3, 2
			# ptrT -= $t3
			sub $s1, $s1, $t3
			# i = 1
			li $t0, 1
		END_IF:		
		# ptrB++ & check next loop
		addi $s0, $s0, 4
		blt $s0, $t2, A2_loop
	
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra


outputMatrix:
	move $t2, $a0

	move $t0, $zero
	output_loop1:
		move $t1, $zero
		output_loop2:
			
			li $v0, 1
			lw $a0, 0($t2)
			syscall
			
			li $v0, 4
			la $a0, space
			syscall
	
			addi $t2, $t2, 4
		
			addi $t1, $t1, 1
			blt $t1, 3, output_loop2
		
		li $v0, 4
		la $a0, nextLine
		syscall
		
		addi $t0, $t0, 1
		blt $t0, 3, output_loop1
	jr $ra

	