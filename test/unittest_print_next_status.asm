# now i am setting (printing the next generation) for this i copy the printing of living cells from the unittest_neighboorCount.asm but not on max display
# i will only test the printing for rule 1 (normal)
# this means i check the display output.
# the printing is intended that 
# first the status bit is correctly set 
# and second that the status bit is correctly readed

# yes the .json file be more or less generated

.include "../src/constants_settings.asm"

## the detection of edges is cropped from the next_cell_edge method and so i do not need any resizing or stuff
# i need to draw a couple of cells
la t0, settings

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
la a0, start_testing_status_print		# print adress as code for error -> should't be possible
jal ra, next_cell_edge_detection
mv t1, a1	# the next cell
mv t2, a2
j down_cell_lines # filling the last cell 

start_testing_status_print:
jal ra, next_generation
j exit_status_print_test



errorcode:	# printting errorcode test failed -> max int
li a0, -1
li  a7, 1          
ecall


exit_status_print_test:
li a7, 10	# ending rars by calling safe exit
ecall

.include "../src/rules.asm"
.include "../src/gamefield.asm"