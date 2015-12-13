	.text	
	li		$v0, 4
	la		$a0, _STR_1
	syscall	
	li		$v0, 5
	syscall	
	move		$t1, $v0
	sw		$t1, _x
	li		$v0, 4
	la		$a0, _STR_2
	syscall	
	li		$v0, 5
	syscall	
	move		$t1, $v0
	sw		$t1, _y
	li		$v0, 4
	la		$a0, _STR_3
	syscall	
	lw		$a0, _x
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_4
	syscall	
	li		$v0, 4
	la		$a0, _STR_5
	syscall	
	lw		$a0, _y
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_6
	syscall	
L7:
	lw		$t4, _x
	lw		$t1, _y
	sne		$t4, $t4, $t1
	beq		$t4, $zero, L8
	lw		$t4, _x
	lw		$t1, _y
	slt		$t4, $t4, $t1
	beq		$t4, $zero, L5
	lw		$t1, _y
	lw		$t2, _x
	sub		$t1, $t1, $t2
	sw		$t1, _y
	b		L6
L5:
	lw		$t1, _x
	lw		$t2, _y
	sub		$t1, $t1, $t2
	sw		$t1, _x
L6:
	b		L7
L8:
	li		$v0, 4
	la		$a0, _STR_7
	syscall	
	lw		$a0, _x
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_8
	syscall	
	.data	
_x:	.word		0
_y:	.word		0
_STR_8:	.asciiz		"\n"
_STR_7:	.asciiz		"gcd = "
_STR_6:	.asciiz		"\n"
_STR_5:	.asciiz		"y = "
_STR_4:	.asciiz		"\n"
_STR_3:	.asciiz		"x = "
_STR_2:	.asciiz		"> "
_STR_1:	.asciiz		"> "
