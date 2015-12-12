	.text	
	li		$t3, 12
	move		$t2, $t3
	move		$t1, $t2
	sw		$t1, _target
	li		$v0, 4
	la		$a0, _STR_1
	syscall	
	addiu		$sp, $sp, -4
	sw		$t5, 0($sp)
	lw		$t3, _target
	move		$t2, $t3
	move		$t1, $t2
	move		$t5, $t1
	li		$v0, 5
	syscall	
	move		$t3, $v0
	move		$t2, $t3
	move		$t1, $t2
	bne		$t1, $t5, L1
	li		$v0, 4
	la		$a0, _STR_2
	syscall	
L1:
	li		$v0, 5
	syscall	
	move		$t3, $v0
	move		$t2, $t3
	move		$t1, $t2
	bne		$t1, $t5, L2
	li		$v0, 4
	la		$a0, _STR_3
	syscall	
L2:
	li		$t3, 12
	move		$t2, $t3
	move		$t1, $t2
	bne		$t1, $t5, L3
	li		$v0, 4
	la		$a0, _STR_4
	syscall	
L3:
	li		$v0, 4
	la		$a0, _STR_5
	syscall	
	lw		$t3, _target
	move		$t2, $t3
	move		$t1, $t2
	move		$a0, $t1
	li		$v0, 1
	syscall	
	lw		$t5, 0($sp)
	addiu		$sp, $sp, 4
	.data	
_target:	.word		0
_STR_5:	.asciiz		"The number was: "
_STR_4:	.asciiz		"Sorry, I cheated"
_STR_3:	.asciiz		"You got it on your second try!"
_STR_2:	.asciiz		"You got it on your first try!"
_STR_1:	.asciiz		"Guess a number between 1 and 10\n"
