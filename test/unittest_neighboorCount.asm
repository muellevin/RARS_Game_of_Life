
# testing count of living neighboors
# in case of error the test position of error or adress is displayed and test get terminated


.include "../src/constants_settings.asm"

## the detection of edges is cropped from the next_cell_edge method and so i do not need any resizing or stuff
# i need to draw a couple of cells
la t0, settings

li t1, 512
sw t1, 12(t0)		# max display size -> the whole buffer in .data with .space is filled
sw t1, 16(t0)		
lw s1, 12(t0)		# width!!!!!
lw s2, 16(t0)		# height!!!

li t1, 0	# top left coords
li t2, 0

up_cell_line:	# filling the first 2 cell lines

mv a1, t1	# function vars
mv a2, t2
jal ra, print_living_cell

mv a1, t1	# better reset them
mv a2, t2
la a0, errorcode		# print adress as code for error -> should't be possible
jal ra, next_cell_edge_detection
mv t1, a1	# the next cell
mv t2, a2
li t3, 1
bleu t2, t3, up_cell_line # filling the first 2 cell lines


li t1, 0	# left coords
addi t2, s2, -6

down_cell_lines:	# filling the first 2 cell lines

mv a1, t1	# function vars
mv a2, t2
jal ra, print_living_cell

mv a1, t1	# better reset them
mv a2, t2
la a0, start_testing_neighboors		# print adress as code for error -> should't be possible
jal ra, next_cell_edge_detection
mv t1, a1	# the next cell
mv t2, a2
j down_cell_lines # filling the last cell lines


start_testing_neighboors:
#testing_top_left: a4 = 3
li a1, 0
li a2, 0
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

#testing_top_right: a4 = 3
addi a1, s1, -1
li a2, 0
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

#testing_mid_left: a4= 5
li a1, 0
addi a2, s2, -5
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

#testing_mid_right: a4 = 5
addi a1, s1, -1
addi a2, s2, -5
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

# testing middle_up dead a4= 5
li t1, 2
divu a1, s1, t1
addi a2, s2, -6
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

# testing middle_whole -> a4 = 8
li t1, 2
divu a1, s1, t1
addi a2, s2, -5
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

# if something weird is print this means it checked the settings or text
# testing bottom left -> a4 = 3
li a1, 0
addi a2, s2, -1
jal ra, neighboor_status
mv a0, a4
jal ra, print_int

# testing bottom right -> a4 = 3
addi a1, s1, -1
addi a2, s2, -1
jal ra, neighboor_status
mv a0, a4
jal ra, print_int
j exit_neighboor_test

print_int:	# a0 
li  a7, 1          
ecall	# always followed by newline

print_new_line:
la a0, new_line
li a7, 4
ecall
ret


errorcode:	# printting errorcode test failed -> max int
li a0, -1
li  a7, 1          
ecall


exit_neighboor_test:
li a7, 10	# ending rars by calling safe exit
ecall

.include "../src/gamefield.asm"


