#   ___ ___ ___ ___   _    ___ ___ _____ _   _ ___ ___ 
#  / __| __/ __| _ \ | |  | __/ __|_   _| | | | _ \ __|
# | (__| _|\__ \  _/ | |__| _| (__  | | | |_| |   / _| 
#  \___|___|___/_|   |____|___\___| |_|  \___/|_|_\___|
#
# Copyright 2021 Michael J. Klaiber

########################################
#CESP Exercise: Draw Rectangle
########################################


#STEP x: Implement draw_rectangle with the arguments as described below
	# Hint: Don't forget the caller/callee save register conventions

# Function to draw rectangle from position x1,y1 to x2,y2 with fill color c
# a3: unsigned integer x1 -- left boundary of rectangle
# a4: unsigned integer y1 -- top boundary of rectangle
# a5: unsigned integer x2 -- right boundary of rectangle
# a6: unsigned integer y2 -- bottom boundary of rectangle
# a7: unsigned integer c  -- fill color of rectangle as RGB value

# li a3, 1
#li a4, 1
#li a5, 9
#li a6, 10
#li a7, 0x00ff00
draw_rectangle:
	#STEP 3: Save and restore all necessary register to/from the stack
	addi sp, sp, -16
	sw a1, 12(sp)
	sw a2, 8(sp)
	sw a3, 4(sp)
	sw ra, 0(sp)
	# ADD YOUR STEP 3 CODE HERE
	add a1, zero, a3
	add a2, zero, a4
	add a3, zero, a7
	
	
	
	_loopy:
		_loopx:	
			#STEP 1: Move the right value to registers a1-a3 and call draw_pixel
			# ADD YOUR STEP 1 CODE HERE
			jal ra, draw_pixel
			addi a1, a1, 1
			ble a1, a5 _loopx
		
		addi a2, a2, 1
		lw a1, 4(sp)
		#STEP 2: Don't forget to set x=x0 again
		# ADD YOUR STEP 2 CODE HERE			
		ble a2, a6, _loopy


	
	lw a1, 12(sp)
	lw a2, 8(sp)
	lw a3, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 16
	
	ret

draw_cell:
# input
# a1 x cell pos
# a2 y cell pos
# inderekt a7 -> color

	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw ra, 8(sp)
	
	la t0, settings
	lw t0, 0(t0)		# cell size
	li t1, 1
	
	bne t0, t1, draw_cell_rectangle		# less instruction -> faster print
	
	## but the simulated display reacts on sw -> need alot more time so...
	#jal ra, get_pixel
	#beq a3, a7, draw_cell_finished		# if the color is the same i do not need to draw anything
	
	mv a3, a7
	jal ra, draw_pixel			# since draw/get pixel have nearly the same instruction it doesn' even matter
	j draw_cell_finished
	
	
	draw_cell_rectangle:
	jal ra, get_pixel
	beq a3, a7, draw_cell_finished		# if the color is the same i do not need to draw anything
	mv a3, a1
	mv a4, a2
	add a5, a1, t0	# here would be already the next cell so -1
	add a6, a2, t0
	addi a5, a5, -1
	addi a6, a6, -1
	jal ra, draw_rectangle
	
	draw_cell_finished:
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw ra, 8(sp)
	addi sp, sp, 12
ret

print_dead_cell:
# input
# a1 x cell pos
# a2 y cell pos
	addi sp, sp, -4
	sw ra, 0(sp)

	li a7, 0	# dead cell
	jal ra, draw_cell
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

print_living_cell:
# input
# a1 x cell pos
# a2 y cell pos
	addi sp, sp, -8
	sw ra, 0(sp)
	sw t0, 4(sp)
	
	la t0, settings
	lw a7, 32(t0)		# color of living cell
	jal ra, draw_cell
	
	lw ra, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8
	ret

.include "draw_pixel.asm"

