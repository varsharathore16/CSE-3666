#       CSE 3666 Lab 4
#	TAG: 5fd71ac11b8a14746aa31ed0caf142197fb20839

	.data
	.align	2	
word_array:     .word
        0,   10,   20,  30,  40,  50,  60,  70,  80,  90, 
        100, 110, 120, 130, 140, 150, 160, 170, 180, 190,
        200, 210, 220, 230, 240, 250, 260, 270, 280, 290,
        300, 310, 320, 330, 340, 350, 360, 370, 380, 390,
        400, 410, 420, 430, 440, 450, 460, 470, 480, 490,
        500, 510, 520, 530, 540, 550, 560, 570, 580, 590,
        600, 610, 620, 630, 640, 650, 660, 670, 680, 690,
        700, 710, 720, 730, 740, 750, 760, 770, 780, 790,
        800, 810, 820, 830, 840, 850, 860, 870, 880, 890,
        900, 910, 920, 930, 940, 950, 960, 970, 980, 990

        # code
        .text
        .globl  main
main:   
	addi	s0, x0, -1
	addi	s4, x0, -1
	addi	s5, x0, -1
	addi	s6, x0, -1
	addi	s7, x0, -1

	# help to check if any saved registers are changed during the function call
	# could add more...

        # la      s1, word_array
        lui     s1, 0x10010      # starting addr of word_array in standard memory config
        addi    s2, x0, 100      # 100 elements in the array

        # read an integer from the console
        addi    a7, x0, 5
        ecall

        addi    s3, a0, 0       # keep a copy of v in s3
        
        # call binary search
        addi	a0, s1, 0
        addi	a1, s2, 0
        addi	a2, s3, 0
        jal	ra, binary_search

exit:   addi    a7, x0, 10      
        ecall

#### Do not change lines above
binary_search:
        # TODO
        addi    sp, sp, -4
        sw	ra, 0(sp)
     	bne	a1, x0, skip
     	addi	a0, x0, -1
     	beq	x0, x0, bs_exit
     	
skip:
	srli	t0, a1, 1		# divide by two, t0 = half
	slli	t1, t0, 2		# multiply by four to get the address offset and put it in t1
	add	t1, t1, a0		# add offset to address
	lw	t1, 0(t1)		# load word to t1	
	
	bne	t1, a2, else_if
	add	a0, t0, x0
	beq	x0, x0, bs_exit
	
else_if:
	blt	t1, a2, else
	add	a1, t0, x0		# set n = half
        jal	ra, binary_search
        beq	x0, x0, bs_exit
		
else:	
	addi	t0, t0, 1
	slli	t1, t0, 2
	addi 	sp, sp, -4
	sw	t0, 0(sp)
	add	a0, a0, t1
	sub	a1, a1, t0
	jal	ra, binary_search
	
	lw	t0, 0(sp)
	addi	sp, sp, 4
	blt	a0, x0, bs_exit
	add	a0, a0, t0
	
bs_exit:	
	lw	ra, 0(sp)
	addi	sp, sp, 4
	jalr	x0, ra, 0	
