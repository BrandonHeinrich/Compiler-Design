	.text	
	li		$t3, 10
	move		$t2, $t3
	move		$t1, $t2
	sw		$t1, _x
L5:
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	li		$v0, 4
	la		$a0, _STR_1
	syscall	
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	li		$t3, 1
	move		$t2, $t3
	sub		$t1, $t1, $t2
	sw		$t1, _x
	lw		$t3, _x
	move		$t2, $t3
	move		$t1, $t2
	move		$t4, $t1
	li		$t3, 0
	move		$t2, $t3
	move		$t1, $t2
	seq		$t4, $t4, $t1
	beq		$t4, $zero, L4
	j		L2
L3:
L4:
	j		L5
L2:
	li		$v0, 4
	la		$a0, _STR_2
	syscall	
L1:
	.data	
_x:	.word		0
_STR_2:	.asciiz		"BLASTOFF!!!"
_STR_1:	.asciiz		", "
