        .text

addi    sp, sp, -128
addi    x1, sp, 0
addi    x20, sp, -1024
sw      x20, 40(x1)
addi	x4, gp, -128
addi    x5, x0, 0x3FF
addi    x6, x0, 0x66
addi    x7, x0, 0x77
addi    x8, x0, 0x88
addi    x9, x0, 0x99

add	x0, x0, x0
add	x0, x0, x0
add	x0, x0, x0

# The code in the textbook
lw      x10, 40(x1)
sub     x11, x2, x3
and     x12, x4, x5 
or      x13, x6, x7
add     x14, x8, x9

# Assume the following BEQ instruction is after<1> 
beq     x1, x0, exit
add	x0, x0, x0      # this would be after <2>
add	x0, x0, x0
add	x0, x0, x0
exit:
