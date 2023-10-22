#       CSE 3666 uint2decstr

        .globl  main

        .text
main:   
        # create an array of 128 bytes on the stack
        addi    sp, sp, -128

        # copy array's address to a0
        addi    a0, sp, 0

	# set all bytes in the buffer to 'A'
        addi    a1, x0, 0       # a1 is the index
	addi	a2, x0, 128
	addi	t2, x0, 'A'
clear:
        add     t0, a0, a1
	sb	t2, 0(t0)
        addi    a1, a1, 1
	bne	a1, a2, clear
	
        # change -1 to other numbers to test
        # use li to make it easier to load the number 
        li	a1, -1
	jal	ra, uint2decstr

        # print the string
        addi    a0, sp, 0
        addi    a7, x0, 4
        ecall

exit:   addi    a7, x0, 10      
        ecall

# char * uint2decstr(char *s, unsigned int v) 
# the function converts an unsigned 32-bit value to a decimal string
# Here are some examples:
# 0:    "0"
# 2022: "2022"
# -1:   "4294967295"
# -3666:   "4294963630"
uint2decstr:
	addi sp, sp, -8 # creates space on stack for ra and s0
	sw ra, 4(sp)
	sw s0, 0(sp)
	li t0, 10# loads 10 into t0
	li t1, 0 # register initialization
	mv t2, a0 # register initialization
	mv t3, a1 # register initialization

test:
	bge t3, t0, recursive #checks if t3 >= t0 (t0 is 10) and goes to recursive function
	addi t3, t3, '0'
	sb t3, 0(t2)
	addi t1, t1, 1 #increments length by 1
	addi t2, t2, 1 #increments pointer by 1
	li t3, 0 # resets t3 to 0
	sb zero, 0(t2)
	addi t2, t2, -1
	mv a0, t2
	lw ra, 4(sp)
	lw s0, 0(sp)
	addi sp, sp, 8
	ret

recursive:
	divu t4, t3, t0 # divides t3 by 10
	mv a0, t2 #
	mv a1, t4
	jal ra, uint2decstr
	mv t2, a0
	remu t3, t3, t0
	addi t3, t3, '0' # adds 0 to value
	sb t3, 0(t2) # stored as byte
	addi t1, t1, 1 #increments length by
	addi t2, t2, 1 #increments pointer by 1
	li t3, 0 # resets t3 to 0
	j test # jumps to the test function
