
# testing gamefield nect cell (continuee_gamefield) function 
# in case of error the test position of error or adress is displayed and test get terminated


.include "../src/constants_settings.asm"


la t0, settings

# working with defaults now.
# we don't need any status of the current cell -> no draw function
li s0, 63	# right edge for cell size 1
li s1, 63	# bottom edge for cell size 1
li s2, 0	# errorbase test


test_top_left:
li a1, 0	# top left
li a2, 0

la a0, errorcode	# gamefield should not be at end -> errorcode
jal ra, next_cell_edge_detection

addi a0, s2, 1		# error code for this
bnez a2, errorcode
addi a0, s2, 2
lw t1, 0(t0)		# expected next start cell coord is cell size
bne a1, t1, errorcode	# not expected call
jal ra, print_succes

test_top_right:
mv a1, s0	# top right
li a2, 0

la a0, errorcode	# gamefield should not be at end -> errorcode is now address code so...
jal ra, next_cell_edge_detection

addi a0, s2, 3		# error code for this
lw t1, 0(t0)		# expected next start cell coord is cell size
bne a2, t1, errorcode

addi a0, s2, 4
bnez a1, errorcode	# not expected call
jal ra, print_succes


test_gamefield_end:
mv a1, s0	# bottom right
mv a2, s1
la a0, success_testing_edge	# gamefield should be at end

jal ra, next_cell_edge_detection
addi a0, s2, 5
j errorcode

success_testing_edge:	# end of test routine anounced by 0 print
jal ra, print_succes
jal ra, print_new_line

addi s2, s2, 10		# increase error code

li t1, 1
lw t2, 0(t0)
beq t2, t1, test_odd_cell_size	# checking for odd cell size

# checking for diffrent display sizes
li t1, 127
beq s1, t1, exit_edge_detection_test
li t1, 1
sw t1, 0(t0)
li t1, 128
sw t1, 16(t0)	# checking diffrent height
li s1, 127
j test_top_left



test_odd_cell_size:
li t1, 15	# would be 4 cells but nvm...
sw t1, 0(t0)	# making edge detection bit dirtier
j test_top_left


print_succes:	# a0 0 -> succes
li a0, 0
li  a7, 1          
ecall	# always followed by newline

print_new_line:
la a0, new_line
li a7, 4
ecall
ret


errorcode:	# printting max int to declare test failed
li  a7, 1          
ecall


exit_edge_detection_test:
li a7, 10	# ending rars by calling safe exit
ecall

.include "../src/gamefield.asm"

  				