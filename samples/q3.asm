	.text	
	li		$v0, 4
	la		$a0, L1
	syscall	
	li		$v0, 5
	syscall	
	move		$t0, $v0
	sw		$t0, _x
	li		$v0, 4
	la		$a0, L2
	syscall	
	lw		$t0, _x
	li		$v0, 1
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, L3
	syscall	
	li		$t0, 1
	sw		$t0, _fac
L5:
	lw		$t0, _x
	li		$t1, 0
	ble		$t0, $t1, L4
	lw		$t0, _fac
	lw		$t1, _x
	mul		$t2, $t0, $t1
	sw		$t2, _fac
	lw		$t0, _x
	li		$t1, 1
	sub		$t2, $t0, $t1
	sw		$t2, _x
	b		L5
L4:
	li		$v0, 4
	la		$a0, L6
	syscall	
	lw		$t0, _fac
	li		$v0, 1
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, L3
	syscall	
	.data	
_fac:	.word		0
_x:	.word		0
L2:	.asciiz		"x = "
L6:	.asciiz		"factorial = "
L1:	.asciiz		"> "
L3:	.asciiz		"\n"