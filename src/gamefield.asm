
# making a RANDOM NUMBER 0-100 (saved in a0)
.macro rand
li a1, 100
li a7, 42
ecall
.end_macro


init_gamefield:

	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw ra, 16(sp)
	
	la t0, settings
	lw t1, 28(t0)	#density
	
	li t2, 0
	li t3, 0
	
	init_living_cells:
	# coords of cell
	mv a1, t2
	mv a2, t3
	rand
	blt a0, t1, cell_alive
	j adding_next_cell
	
	cell_alive:
		mv a1, t2
		mv a2, t3
		jal ra, print_living_cell
		
	adding_next_cell:
	la a0, return_to_main
	mv a1, t2	# incase some below function modified them
	mv a2, t3
	jal ra, next_cell_edge_detection	# input a1, a2
	mv t2, a1
	mv t3, a2
	j init_living_cells

	
	return_to_main:
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw ra, 16(sp)
	addi sp, sp, 20
	ret
	

next_cell_edge_detection:
# input:
# a0 where to jump if gemfield is finished
# a1 current x pos
# a2 current y pos
# return:
# a1 x pos of next cell
# a2 y pos of next cell


	addi sp, sp, -16
	sw t0, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	
	la t0, settings
	lw s0, 12(t0)	# width size
	lw s1, 16(t0)	# height size
	lw s2, 0(t0)	# cell size
	
	add a1, a1, s2	# checking if next cell is still in display size
	add a1, a1, s2
	addi a1, a1, -1
	bge a1, s0, check_y_field_size	# if wdth is too much checking height size
	addi a1, a1, 1
	sub a1, a1, s2
	j return_next_cell_coord
	
	check_y_field_size:
	add a2, a2, s2
	add a2, a2, s2
	addi a2, a2, -1
	li a1, 0 		# only checking y size when x size is too much -> reseting x size
	bge a2, s1, return_to_gamefield_caller
	addi a2, a2, 1
	sub a2, a2, s2
	
	return_next_cell_coord:
	# resetting used register and return to ra
	lw t0, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16
	ret
	
	return_to_gamefield_caller:
	# resetting used register and go to next call when gamefield is finished
	lw t0, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16
	jr a0


neighboor_status:
# a1 your cell x
# a2 your cell y
# return a4 living neighboor count
# i would need 2 for loops and everytime both edge detections -> more instructions 

	li a4, 0	# count living cells
	addi sp, sp, -28
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	sw ra, 20(sp)
	sw s0, 24(sp)
	
	la t3, settings
	lw s0, 0(t3)		# i need the cell size to check if the next cell would be out of range
	
	mv t0, a1		# saving the coords of current cell
	mv t1, a2

	top_left:
	
	sub a1, t0, s0		# left from current
	sub a2, t1, s0		# row over current
	
	bltz a2, mid_left	# if less than 0 (top row) than go directly to mid row
	bltz a1, top_mid	# when cell is on left edge jump to mid top
	jal ra, get_pixel
	beqz a3, top_mid	# 0 == death -> no count
	addi a4, a4, 1
	
	top_mid:
	mv a1, t0		# same x coord as current
	# sub a2, t1, s0	# still one row over current (already checked)
	# this means the cell must exist
	jal ra, get_pixel
	beqz a3, top_right	# 0 == death -> no count
	addi a4, a4, 1
	
	top_right:
	add a1, t0, s0		# right from current
	# sub a2, t1, s0	# still one row over current (already checked)
	
	lw t4, 12(t3)		# need to get the gamefield widht
	bgeu a1, t4, mid_left	# when the cell is on edge go to mid_left
	jal ra, get_pixel
	beqz a3, mid_left	# 0 == death -> no count
	addi a4, a4, 1
	
	mid_left:
	sub a1, t0, s0		# left from current
	mv a2, t1		# same row as current -> row must exist
	bltz a1, mid_right	# left edge
	jal ra, get_pixel
	beqz a3, mid_right	# 0 == death -> no count
	addi a4, a4, 1
	
	mid_right:
	add a1, t0, s0		# right from current
	#mv a2, t1		# same row as current -> row must exist
	lw t4, 12(t3)		# need to get the gamefield widht
	bgeu a1, t4, bottom_left# right edge
	jal ra, get_pixel
	beqz a3, bottom_left	# 0 == death -> no count
	addi a4, a4, 1
	
	bottom_left:
	sub a1, t0, s0		# left from current
	add a2, t1, s0		# row below current
	
	lw t4, 16(t3)				# i need gamefield height
	bgeu a2, t4, finish_counting_neighboor	# bottom edge -> no more cells -> finish
	bltz a1, bottom_mid			# left edge -> go to next cell -> row must exist
	jal ra, get_pixel
	beqz a3, bottom_mid	# 0 == death -> no count
	addi a4, a4, 1

	bottom_mid:
	mv a1, t0
	#add a2, t1, s0		# row below current
	jal ra, get_pixel
	beqz a3, bottom_right	# 0 == death -> no count
	addi a4, a4, 1
	
	bottom_right:
	add a1, t0, s0		# right from current
	#add a2, t1, s0		# row below current
	lw t4, 12(t3)		# right edge detection
	bgeu a1, t4, finish_counting_neighboor		
	jal ra, get_pixel
	beqz a3, finish_counting_neighboor	# 0 == death -> no count
	addi a4, a4, 1
	
	finish_counting_neighboor:
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	lw ra, 20(sp)
	lw s0, 24(sp)
	addi sp, sp, 28
	ret


# cropped from rules.asm next_generation
# -> looks even more weird from used registers
print_next_generation:
	# saving all needed register those of rules as well
	addi sp, sp, -24
	sw t2, 0(sp)
	sw t3, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw s2, 16(sp)
	sw ra, 20(sp)
	
	la s0, state_bits	# base adress for state bits
	li s2, 31	# bits in one word +1 bit your bit; i changed the register at a later point
	lw s1, 0(s0)	# first value
	
	li t2, 0
	li t3, 0
	
	print_through_gamefield:
	# current cell:
		mv a1, t2
		mv a2, t3
		
		get_status_bit:
		srl a4, s1, s2		# getting cell status
		andi a4, a4, 1		# only single bit is needed
		
		la ra, continue_print_gamefiled
		beqz a4, print_dead_cell
		j print_living_cell
		
		continue_print_gamefiled:
		addi s2, s2, -1
		bgez s2, same_status_word_print
		
		li s2, 31		# resetting bit count
		addi s0, s0, 4		# going to next word adress
		lw s1, 0(s0)		# and loading the next word status bits
		
		same_status_word_print:
		# going to next cell
		la a0, print_next_gemeration_finished	# where to go if gamefield is finished
		#current pos
		mv a1, t2	
		mv a2, t3
		jal ra, next_cell_edge_detection
		# load coords of next cell
		mv t2, a1
		mv t3, a2
		j print_through_gamefield
	
	
	print_next_gemeration_finished:	
	lw t2, 0(sp)
	lw t3, 4(sp)
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw s2, 16(sp)
	lw ra, 20(sp)
	addi sp, sp, 24
	ret

# more efficient way to print black screen (reset)
print_black_display:
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw ra, 8(sp)

	li t0, 0	# display start coords
	li t1, 0	
	
	print_trough_blacking_display:
	mv a1, t0
	mv a2, t1
	
	jal ra, print_dead_cell
	
	continue_blacking_display:
	la a0, print_black_display_finished	# where to go if gamefield is finished
	#current pos
	mv a1, t0
	mv a2, t1
	jal ra, next_cell_edge_detection
	# load coords of next cell
	mv t0, a1
	mv t1, a2
	j print_trough_blacking_display
	
	
	print_black_display_finished:
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw ra, 8(sp)
	addi sp, sp, 12
	ret


.include "exercise_solutions/draw_rectangle.asm"
