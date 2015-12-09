	.text	
	li		$t3, 0
	move		$t2, $t3
	move		$t1, $t2
	sw		$t1, _x
L1:
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$t4, $t1
	li		$t3, 10
	move		$t2, $t3
	move		$t1, $t2
	slt		$t4, $t4, $t1
	beq		$t4, $zero, L2
	li		$v0, 4
	la		$a0, _STR_1
	syscall	
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_2
	syscall	
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	li		$t3, 1
	move		$t2, $t3
	add		$t1, $t1, $t2
	sw		$t1, _x
	b		L1
L2:
	li		$v0, 4
	la		$a0, _STR_3
	syscall	
	li		$v0, 5
	syscall	
	move		$t3, $v0
	move		$t2, $t3
	move		$t1, $t2
	sw		$t1, _x
	li		$v0, 4
	la		$a0, _STR_4
	syscall	
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_5
	syscall	
	li		$t3, 1
	move		$t2, $t3
	move		$t1, $t2
	sw		$t1, _fac
L3:
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$t4, $t1
	li		$t3, 0
	move		$t2, $t3
	move		$t1, $t2
	sgt		$t4, $t4, $t1
	beq		$t4, $zero, L4
	lw		$t3, _fac
	move		$t2, $t3
	lw		$t3, _x
	mul		$t2, $t2, $t3
	move		$t1, $t2
	sw		$t1, _fac
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	li		$t3, 1
	move		$t2, $t3
	sub		$t1, $t1, $t2
	sw		$t1, _x
	b		L3
L4:
	li		$v0, 4
	la		$a0, _STR_6
	syscall	
	lw		$t3, _fac
	move		$t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_7
	syscall	
	.data	
_x:	.word		0
_fac:	.word		0
_STR_7:	.asciiz		"\n"
_STR_6:	.asciiz		"factorial = "
_STR_5:	.asciiz		"\n"
_STR_4:	.asciiz		"x = "
_STR_3:	.asciiz		"> "
_STR_2:	.asciiz		"\n"
_STR_1:	.asciiz		"x ="
