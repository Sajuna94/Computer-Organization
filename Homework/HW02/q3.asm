.data
	array: .space 20
	nextLine: .asciiz ","

.text
.globl main

main:
	la $s0, array
	
	move $t0, $zero
	main_loop1:
		# input array[i]
		sll $t1, $t0, 2
		add $t1, $s0, $t1
		li $v0, 5
		syscall
		sw $v0, 0($t1)
		# i < 5
		addi $t0, $t0, 1
		blt $t0, 5, main_loop1
		
	move $a0, $s0
	li $a1, 5
	jal selectionSort
	
	move $t0, $zero
	main_loop2:
		sll $t1, $t0, 2
		add $t1, $s0, $t1
		lw $a0, 0($t1)
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, nextLine
		syscall
		
		addi $t0, $t0, 1
		blt $t0, 5, main_loop2
	
	li $v0, 10
	syscall
	
selectionSort:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)

	move $t0, $zero
	sort_loop1:
		move $s0, $t0 # min_idx = i
		
		addi $t1, $t0, 1 # j = i + 1
		sort_loop2:
			bge $t1, $a1, exit_sort_loop2
				
			sll $t2, $t1, 2
			add $t2, $a0, $t2
			lw $t2, 0($t2)
			
			sll $t3, $s0, 2
			add $t3, $a0, $t3
			lw $t3, 0($t3)
			
			blt $t2, $t3, UPDATE_MIN_INDEX
			j CONTINUE	
			UPDATE_MIN_INDEX:
				move $s0, $t1	
			CONTINUE:

			addi $t1, $t1, 1
			j sort_loop2
	
 		exit_sort_loop2:
 		
		# $t2 = &array[min_idx], $t3 = array[i]
		sll $t2, $s0, 2
		add $t2, $a0, $t2
		lw $t3, 0($t2)
		
		# $t4 = &array[i], $t5 = array[i]
		sll $t4, $t0, 2
		add $t4, $a0, $t4
		lw $t5, 0($t4)
		
		sw $t5, 0($t2)
		sw $t3, 0($t4)
		
		# i < n - 1, same i + 1 < n
		addi $t0, $t0, 1 # i = i + 1
		blt $t0, $a1, sort_loop1
		
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
		