	.text	
	li		$t3, 5
	move		$t2, $t3
	move		$t1, $t2
	li		$t3, 6
	move		$t2, $t3
	li		$t3, 3
	mul		$t2, $t2, $t3
	add		$t1, $t1, $t2
	li		$t3, 17
	move		$t2, $t3
	sub		$t1, $t1, $t2
	li		$t3, 23
	move		$t2, $t3
	li		$t3, 5
	div		$t2, $t2, $t3
	add		$t1, $t1, $t2
	sw		$t1, _x
	.data	
_abc:	.word		0
_bc:	.word		0
_a:	.word		0
_x:	.word		0
_y:	.word		0
