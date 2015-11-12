	.text	
	li		$v0, 4
	la		$a0, L1
	syscall	
	li		$v0, 5
	syscall	
	move		$t0, $v0
	sw		$t0, _x
	li		$v0, 4
	la		$a0, L1
	syscall	
	li		$v0, 5
	syscall	
	move		$t0, $v0
	sw		$t0, _y
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
	li		$v0, 1
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, L3
	syscall	
L8:
	lw		$t0, _x
	lw		$t1, _y
	beq		$t0, $t1, L5
	lw		$t0, _x
	lw		$t1, _y
	bge		$t0, $t1, L6
	lw		$t0, _y
	lw		$t1, _x
	sub		$t2, $t0, $t1
	sw		$t2, _y
	b		L7
L6:
	lw		$t0, _x
	lw		$t1, _y
	sub		$t2, $t0, $t1
	sw		$t2, _x
L7:
	b		L8
L5:
	li		$v0, 4
	la		$a0, L9
	syscall	
	lw		$t0, _x
	li		$v0, 1
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, L3
	syscall	
	li		$v0, 10
	syscall	
	.data	
_y:	.word		0
_x:	.word		0
L2:	.asciiz		"x = "
L4:	.asciiz		"y = "
L1:	.asciiz		"> "
L3:	.asciiz		"\n"
L9:	.asciiz		"gcd = "