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
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$a0, $t1, 0
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_3
	syscall	
	li		$t3, 1
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	sw		$t1, _fac
L1:
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$t4, $t1, 0
	li		$t3, 0
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	sub		$t4, $t4, $t1
	blez		$t4, L2
	lw		$t3, _fac
	addi		$t2, $t3, 0
	lw		$t3, _x
	mul		$t2, $t2, $t3
	addi		$t1, $t2, 0
	sw		$t1, _fac
	lw		$t3, _x
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	li		$t3, 1
	addi		$t2, $t3, 0
	sub		$t1, $t1, $t2
	sw		$t1, _x
	b		L1
L2:
	li		$v0, 4
	la		$a0, _STR_4
	syscall	
	lw		$t3, _fac
	addi		$t2, $t3, 0
	addi		$t1, $t2, 0
	addi		$a0, $t1, 0
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_5
	syscall	
	.data	
_x:	.word		0
_fac:	.word		0
_STR_5:	.asciiz		"\n"
_STR_4:	.asciiz		"factorial = "
_STR_3:	.asciiz		"\n"
_STR_2:	.asciiz		"x = "
_STR_1:	.asciiz		"> "
