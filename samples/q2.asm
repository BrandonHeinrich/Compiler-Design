	.text	
	li		$t0, 5
	li		$t1, 2
	li		$t2, 3
	div		$t3, $t1, $t2
	add		$t1, $t0, $t3
	sw		$t1, _x
	lw		$t0, _x
	lw		$t1, _x
	mul		$t2, $t0, $t1
	li		$t0, 4
	sub		$t1, $t2, $t0
	sw		$t1, _y
	li		$v0, 4
	la		$a0, L1
	syscall	
	li		$v0, 5
	syscall	
	move		$t0, $v0
	sw		$t0, _z
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
	li		$v0, 4
	la		$a0, L4
	syscall	
	lw		$t0, _y
	lw		$t1, _z
	mul		$t2, $t0, $t1
	li		$v0, 1
	move		$a0, $t2
	syscall	
	li		$v0, 4
	la		$a0, L3
	syscall	
	.data	
_z:	.word		0
_y:	.word		0
_x:	.word		0
_nl:	.asciiz		"\n"
L2:	.asciiz		"x = "
L4:	.asciiz		"y * z = "
L1:	.asciiz		"> "
L3:	.asciiz		"\n"