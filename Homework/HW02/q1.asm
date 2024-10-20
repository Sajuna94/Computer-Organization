.data
	underWeightMsg: .asciiz "underweight"
	overWeightMsg: .asciiz "overweight"
	newLine: .asciiz "\n"

.text
.globl main

main:
	loop:
		# input height
		li $v0, 5
		syscall
		move $s0, $v0
	
		# check exit input
		beq $s0, -1, EXIT
	
		# input weight
		li $v0, 5
		syscall
		move $s1, $v0
	
		# calculateBMI(height, weight)
		move $a0, $s0
		move $a1, $s1
		jal calculateBMI
		
		# printResult(bmi)
		move $a0, $v0
		jal printResult
		
		j loop
EXIT:
	li $v0, 10
	syscall
	
printResult:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	ble $a0, 17, IF_UNDER_WEIGHT
	bge $a0, 25, IF_OVER_WEIGHT
	
	li $v0, 1
	syscall
	j printNewLine
	
	IF_UNDER_WEIGHT:
		li $v0, 4
		la $a0, underWeightMsg
		syscall
		j printNewLine
	
	IF_OVER_WEIGHT:
		li $v0, 4
		la $a0, overWeightMsg
		syscall
		j printNewLine
	
	printNewLine:
		li $v0, 4
		la $a0, newLine
		syscall

	# return
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

calculateBMI:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# weight * 10000
	li $t0, 10000
	mul $t0, $a1, $t0
	
	# height * height
	mul $t1, $a0, $a0
	
	# (weight * 10000) / (height * height)
	div $t0, $t1
	mflo $v0 # get result

	# return
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
