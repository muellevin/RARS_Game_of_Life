
# making a RANDOM NUMBER 0-100 (saved in a0)
.macro rand
li a1, 100
li a7, 42
ecall
.end_macro



init_gamefield:
	# sw ra, sp
	addi sp, sp, -32
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw s0, 16(sp)
	sw s1, 20(sp)
	sw s2, 24(sp)
	sw ra, 28(sp)
	
	la t0, settings
	lw t1, 28(t0)	#density
	lw s0, 12(t0)	# x size
	lw s1, 16(t0)	# y size
	lw s2, 0(t0)	# cell size
	
	#mv t2, s2	# left pseudo cells
	#mv t3, s2	# top peseudo cells
	li t2, 0
	li t3, 0
	
	#sub s0, s0, s2	# right pseudo cells 
	#sub s1, s1, s2	# bottom pseudo cells
	
	
	
	# Function to draw rectangle from position x1,y1 to x2,y2 with fill color c
# a3: unsigned integer x1 -- left boundary of rectangle
# a4: unsigned integer y1 -- top boundary of rectangle
# a5: unsigned integer x2 -- right boundary of rectangle
# a6: unsigned integer y2 -- bottom boundary of rectangle
# a7: unsigned integer c  -- fill color of rectangle as RGB value
	init_living_cells:
	
	
	# coords of cell
		mv a3, t2
		mv a4, t3
		add a5, t2, s2
		add a6, t3, s2
		addi a5, a5, -1
		addi a6, a6, -1
	rand
	ble a0, t1, cell_alive
	la a0, return_to_main
		mv a1, t2
		mv a2, t3
		mv a3, s2
		mv a4, s0
		mv a5, s1
	jal ra, continue_gamefield	# getting next cell
	j adding_next_cell
	
	
	cell_alive:
		
		
		li a7, ALIVE	# all living cells are green
		jal draw_rectangle
		la a0, return_to_main
		mv a1, t2
		mv a2, t3
		mv a3, s2
		mv a4, s0
		mv a5, s1
		jal ra, continue_gamefield
		j adding_next_cell
		
	adding_next_cell:
	mv t2, a1
	mv t3, a2
	j init_living_cells
	
	
	return_to_main:
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw s0, 16(sp)
	lw s1, 20(sp)
	lw s2, 24(sp)
	lw ra, 28(sp)
	addi sp, sp, 32
	ret
	

continue_gamefield:
	add a1, a1, a3	# checking if next cell is still in display size
	add a1, a1, a3
	addi a1, a1, -1
	bge a1, a5, check_y_field_size	# if x size is too much checking y size
	addi a1, a1, 1
	sub a1, a1, a3
	ret
	
	check_y_field_size:
	add a2, a2, a3
	add a2, a2, a3
	addi a2, a2, -1
	li a1, 0 		# only checking y size when x size is too much -> reseting x size
	bge a2, a5, return_to_gamefield_caller
	addi a2, a2, 1
	sub a2, a2, a3
	ret
	
	return_to_gamefield_caller:
	jr a0


neighboor_status:
# a1 your cell x
# a2 your cell y
# return a4 living neighboor count

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
	lw s0, 0(t3)

	top_left:
	mv t0, a1
	mv t1, a2
	sub a1, t0, s0
	sub a2, t1, s0
	bltz a2, mid_left
	bltz a1, top_mid
	jal ra, get_pixel
	beqz a3, top_mid
	addi a4, a4, 1
	
	top_mid:
	add a1, a1, s0
	jal ra, get_pixel
	beqz a3, top_right
	addi a4, a4, 1
	
	top_right:
	add a1, a1, s0
	lw t4, 12(t3)
	bgeu a1, t4, mid_left
	jal ra, get_pixel
	beqz a3, mid_left
	addi a4, a4, 1
	
	mid_left:
	sub a1, t0, s0
	mv a2, t1
	bltz a1, mid_right
	jal ra, get_pixel
	beqz a3, mid_right
	addi a4, a4, 1
	
	mid_right:
	add a1, t0, s0
	jal ra, get_pixel
	beqz a3, bottom_left
	addi a4, a4, 1
	
	bottom_left:
	sub a1, t0, s0
	sub a1, t0, s0
	add a2, t1, s0
	lw t4, 16(t3)
	bgeu a2, t4, finish_counting_neighboor
	bltz a1, bottom_mid
	jal ra, get_pixel
	beqz a3, bottom_mid
	addi a4, a4, 1

	bottom_mid:
	add a1, a1, s0
	jal ra, get_pixel
	beqz a3, bottom_right
	addi a4, a4, 1
	
	bottom_right:
	add a1, a1, s0
	lw t4, 12(t3)
	bgeu a1, t4, finish_counting_neighboor
	jal ra, get_pixel
	beqz a3, finish_counting_neighboor
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


get_pixel:
# get colored pixel at position (x,y)  

# Inputs
#----------------------
#    a1: x
#    a2: y
# Outputs: a3: color

	#STEP 3a: Save the callee save registers on the stack
	# ADD YOUR STEP x CODE HERE
	addi sp, sp, -16
	sw s0, 0 (sp)
	sw s1, 4 (sp)
	sw s2, 8 (sp)
	sw s3, 12(sp)
	
	la s3, settings
	#STEP 1: Use the constants DISPLAY_ADDRESS and DISPLAY_WIDTH defined in cesplib_rars.asm and the arguments passed via registers a1 and a2 to calculate the memory address that you  need.
	# ADD YOUR STEP x CODE HERE
	lw s0, 4(s3)	# display address
	lw s1, 12(s3)	# y size
	
	# y_offset
	mul s2, s1, a2  # y∗DISPLAY_WIDTH
			
	# crt_address = base_address + x_offset + y_offset
	add s2, a1, s2
	slli s2, s2, 2 # *4 to byte address
	
	add s2, s2, s0 

	#STEP 2: Store the value of a3 in the memory at the address you have calculated before.
	# ADD YOUR STEP x CODE HERE
	# *crt_address = a3
	lw a3, 0(s2)

	#STEP 3b: Don't forget to restore the callee save values
	# ADD YOUR STEP x CODE HERE
	lw s0, 0 (sp)
	lw s1, 4 (sp)
	lw s2, 8 (sp)
	lw s3, 12(sp)
	addi sp, sp, 16
	ret


