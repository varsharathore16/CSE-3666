#       CSE 3666 Lab 2

        .globl  main

        .text
main:   
        # use system call 5 to read integer
        addi    a7, x0, 5
        ecall
        addi    s1, a0, 0       # copy to s1

        # TODO
        # Add you code here
        #   reverse bits in s1 and save the results in s2
        #   print s1 in binary, with a system call
        #   print newline
        #   print s2 in binary
        #   print newline

	addi t0, s1, 0 		# t0 = s1

	addi s2, x0, 0		# initialize s2 to 0

	addi s3, x0, 32		# reverse bits in s1
	reverse_loop:
		# srli s4, s1, 1		# shift right s1 by 1
		# slli s1, s1, 1 		# save last bit in s4

		slli s2, s2, 1		# shift left s2 by 1
		andi t1, t0, 1
		or s2, s2, t1		# add last bit from s4
		srli t0, t0, 1

		addi s3, s3, -1
		bne s3, x0, reverse_loop 	# decrement loop counter
	
	# use system call 35 to print s1 in binary
	addi a7, x0, 35
  	addi a0, s1, 0
  	ecall

	# use system call 11 to print newline character (ASCII value 10)
	addi a7, x0, 11
	addi a0, x0, 10
	ecall

	# use system call 35 to print s2 in binary
	addi a7, x0, 35
	addi a0, s2, 0
	ecall

	# use system call 11 to print newline character (ASCII valye 10)
	addi a7, x0, 11
	addi a0, x0, 10
	ecall
        
        # exit
exit:   addi    a7, x0, 10      
        ecall


# t0 after first shift execution of shift right by 1:
# 0 0000 000 0000 0000 0000 0011 1111 0011
