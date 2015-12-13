	.text	
	li		$t3, 5
	move		$t2, $t3
	move		$t1, $t2
	li		$t3, 5
	move		$t2, $t3
	add		$t1, $t1, $t2
	li		$t3, 6
	move		$t2, $t3
	addiu		$sp, $sp, -4
	sw		$t1, 0($sp)
	addiu		$sp, $sp, -4
	sw		$t2, 0($sp)
	li		$t3, 10
	move		$t2, $t3
	move		$t1, $t2
	li		$t3, 2
	move		$t2, $t3
	add		$t1, $t1, $t2
	move		$t3, $t1
	lw		$t2, 0($sp)
	addiu		$sp, $sp, 4
	lw		$t1, 0($sp)
	addiu		$sp, $sp, 4
	mul		$t2, $t2, $t3
	add		$t1, $t1, $t2
	sw		$t1, _x
	lw		$t3, _x
	move		$t2, $t3
	lw		$t3, _x
	mul		$t2, $t2, $t3
	move		$t1, $t2
	li		$t3, 4
	move		$t2, $t3
	sub		$t1, $t1, $t2
	sw		$t1, _y
	li		$v0, 4
	la		$a0, _STR_1
	syscall	
	li		$v0, 5
	syscall	
	move		$t3, $v0
	move		$t2, $t3
	move		$t1, $t2
	sw		$t1, _z
	li		$v0, 4
	la		$a0, _STR_2
	syscall	
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_3
	syscall	
	li		$v0, 4
	la		$a0, _STR_4
	syscall	
	lw		$t3, _y
	move		$t2, $t3
	lw		$t3, _z
	mul		$t2, $t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_5
	syscall	
L1:
	.data	
_x:	.word		0
_y:	.word		0
_z:	.word		0
_STR_5:	.asciiz		"\n"
_STR_4:	.asciiz		"y * z = "
_STR_3:	.asciiz		"\n"
_STR_2:	.asciiz		"x = "
_STR_1:	.asciiz		"> "
