	.text	
	li		$v0, 4
	la		$a0, _STR_1
	syscall	
	li		$v0, 5
	syscall	
	addi		$t3, $v0, 0
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	sw		$t1, _x
	li		$v0, 4
	la		$a0, _STR_2
	syscall	
	li		$v0, 5
	syscall	
	addi		$t3, $v0, 0
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	sw		$t1, _y
	li		$v0, 4
	la		$a0, _STR_3
	syscall	
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$a0, $t1, 0
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_4
	syscall	
	li		$v0, 4
	la		$a0, _STR_5
	syscall	
	lw		$t3, _y
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$a0, $t1, 0
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_6
	syscall	
L3:
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$t4, $t1, 0
	lw		$t3, _y
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	sne		$t4, $t4, $t1
	beq		$t4, $zero, L4
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$t4, $t1, 0
	lw		$t3, _y
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	slt		$t4, $t4, $t1
	beq		$t4, $zero, L1
	lw		$t3, _y
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	lw		$t3, _x
	addi		$t2, $t3, 0
	sub		$t1, $t1, $t2
	sw		$t1, _y
	b		L2
L1:
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	lw		$t3, _y
	addi		$t2, $t3, 0
	sub		$t1, $t1, $t2
	sw		$t1, _x
L2:
	b		L3
L4:
	li		$v0, 4
	la		$a0, _STR_7
	syscall	
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$a0, $t1, 0
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_8
	syscall	
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$t4, $t1, 0
	li		$t3, 5
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	seq		$t4, $t4, $t1
	beq		$t4, $zero, L5
	li		$v0, 4
	la		$a0, _STR_9
	syscall	
L5:
	.data	
_x:	.word		0
_y:	.word		0
_STR_9:	.asciiz		"x = 5"
_STR_8:	.asciiz		"\n"
_STR_7:	.asciiz		"gcd = "
_STR_6:	.asciiz		"\n"
_STR_5:	.asciiz		"y = "
_STR_4:	.asciiz		"\n"
_STR_3:	.asciiz		"x = "
_STR_2:	.asciiz		"> "
_STR_1:	.asciiz		"> "
