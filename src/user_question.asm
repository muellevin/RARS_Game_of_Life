
# Main file for Game of Life Project
# fpgrars interface


j end	

init_user_questioning:

	addi sp, sp, -4
	sw ra, 0(sp)
	
	jal ra, question_cell_size
	jal ra, question_rars_version
	jal ra, question_rule
	jal ra, question_time
	jal ra, question_start_density	
		
	# restore ra
	lw ra, 0(sp)
	addi sp,sp, 4

ret


question_cell_size:
	
	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	la a1, question_cell_size	# jump back to where we start if invalid input

	# ask user about cell size
	la a0, ask_cell_size	
	li a7, 4
	ecall
	
	li a0, MAX_CELL_SIZE	#  print maximum cells in pixel
	jal ra, print
	jal ra, print_new_line

	li a7, 5	#get size input as integer
	ecall

	# now checkingg if the input was valid
	li t0, MIN_CELL_SIZE
	blt a0, t0, invalid_cell_size
	li t0, MAX_CELL_SIZE
	bgt a0, t0, invalid_cell_size	

	# loading setting address
	la t0, settings
	sw a0, 0(t0)
	
	#resetting t0
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret
	
	invalid_cell_size:
	#resetting t0
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	j invalid_input


question_rule:

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)

	la a1, question_rule	# jump back to where we start if invalid input

	# ask user about rule to apply
	la a0, ask_rule_to_apply	
	li a7, 4
	ecall
	
	li a0, MAX_RULE	#  print maximum of usable rules
	jal ra, print
	jal ra, print_new_line

	li a7, 5	#get size input as integer
	ecall

	# now checkingg if the input was valid
	li t0, 1	# min rule is one and default
	blt a0, t0, invalid_rule
	li t0, MAX_RULE
	bgt a0, t0, invalid_rule	

	# loading setting address
	la t0, settings
	sw a0, 20(t0)
	
	#resetting t0
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret
	
	invalid_rule:
	#resetting t0
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	j invalid_input

question_time:

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	la a1, question_time	# jump back to where we start if invalid input
	# ask user about time till next generation should be rendered
	la a0, ask_time_till_next_generation
	li a7, 4
	ecall
	
	li a0, MAX_TIME_DELAY	#  print maximum of usable objects
	jal ra, print
	jal ra, print_new_line
	
	# here we will accept anything
	li a7, 5	#get time input as integer
	ecall
	
	li t0, MAX_TIME_DELAY		# i am setting a limit because inever want to see someone wait 7,101467089947 weeks??!
	bgt a0, t0, invalid_time
	
	# loading setting address
	la t0, settings
	sw a0, 24(t0)
	
	#resetting t0
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret
	
	invalid_time:
	#resetting t0
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	j invalid_input


question_start_density:

	addi sp, sp, -4
	sw t0, 0(sp)
	
	la a1, question_start_density	# jump back to where we start if invalid input
	
	# ask user about density
	la a0, ask_start_density	
	li a7, 4
	ecall
	
	li a7, 5	#get density input as integer
	ecall
	
	# now checkingg if the input was valid
	li t0, 0		# lower would be boring
	blt a0, t0, invalid_density
	li t0, 100
	bgt a0, t0, invalid_density

	# loading setting address
	la t0, settings
	sw a0, 28(t0)
	
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4	
	ret
	
	invalid_density:
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4
	j invalid_input

question_rars_version:
	# no jump back address needed
	
	# ask user about rars version (fpgrars or rars)
	la a0, ask_rars_version
	li a7, 4
	ecall
	
	li a7, 5	#get size input as integer
	ecall
	
	beqz a0, version_rars
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)	# we are using t1 to safe fpgrars version addresses of keyboard display etc.
	
	la t0, settings
	
		# load fpgrars values in settings	
	li t1, FPG_DISPLAY_ADDRESS
	sw t1, 4(t0)
	
	li t1, FPG_KEYBOARD_ADDRESS
	sw t1, 8(t0)
	
	li t1, FPG_DISPLAY_WIDTH
	sw t1, 12(t0)
	
	li t1, FPG_DISPLAY_HEIGHT
	sw t1, 16(t0)
	
	# restore t1 and t0
	lw t1, 4(sp)
	lw t0, 0(sp)
	addi sp, sp, 8
	ret
	
	version_rars:
	# setting rars enviromenet addresses
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)	# we are using t1 to saferars version addresses of keyboard display etc.
		
	la t0, settings
		
	li t1, RARS_DISPLAY_ADDRESS
	sw t1, 4(t0)
	
	li t1, RARS_KEYBOARD_ADDRESS
	sw t1, 8(t0)
	
	# restore t1
	lw t1, 4(sp)
	addi sp, sp, 4
	# we are using t0 as settings adress for our display size question
	
	question_display_size:
		# rars can have diffrent display sizes
		la a1, question_display_size	# jump back to where we start if invalid input
		la a2, safe_x
		
		# ask user about x-size display
		la a0, ask_x_size_display	
		li a7, 4
		ecall
	
		li a7, 5	#get size input as integer
		ecall
	
		j rars_display_sizes	# a2 is jump register
		
		safe_x:
		la t0, settings
		sw a0, 16(t0)
		
		question_y_display_size:
		# rars can have diffrent display sizes
		la a1, question_y_display_size	# jump back to where we start if invalid input
		la a2, safe_y			# a2 is jump register when valid input
		
		# ask user about y-size display
		la a0, ask_y_size_display	
		li a7, 4
		ecall
	
		li a7, 5	#get size input as integer
		ecall
	
		j rars_display_sizes	# a2 is jump register when valid input
		
		safe_y:
		la t0, settings
		sw a0, 12(t0)
		
		# restore t0
		lw t0, 0(sp)
		addi sp, sp, 4
		ret


rars_display_sizes:
# a0 value to ckeck
# a1 repeat input (call invalid_input)
# a2 valid input -> next instruction to do

# t0 is temp register from outer call so we don't stack it
# t1 is needed temp regster for max display size
	addi sp, sp, -4
	sw t1, 0(sp)

	#size_64-1024:
	# now checkingg if the input was valid
	li t0, MIN_DISPLAY_SIZE
	li t1, MAX_DISPLAY_SIZE
	
	loop_allowed_size:
	bgt t0, t1, invalid_display_size
	beq a0, t0, return_to_safe
	slli t0, t0, 1
	j loop_allowed_size

	# restoring needed t1 register and jump to invalid
	invalid_display_size:
	lw t1, 0(sp)
	addi sp, sp, 4
	j invalid_input
	
	# restoring needed t1 register and jump to safe address
	return_to_safe:
	lw t1, 0(sp)
	addi sp, sp, 4
	jr a2

question_colour:	
	addi sp, sp, -4
	sw t0, 0(sp)
	
	# ask user about color code
	la a0, ask_colour	
	li a7, 4
	ecall

	li a7, 5	#get colorcode as integer
	ecall
	
	beqz a0, invalid_colour

	# loading setting address
	la t0, settings
	sw a0, 32(t0)
	
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4	
	ret
	
	invalid_colour:
	#resetting t0
	la a1, question_colour	# jump back to where we start if invalid input
	lw t0, 0(sp)
	addi sp, sp, 4
	j invalid_input
	

question_object:
# questioning which object you want to draw and where
	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	# ask user about density
	la a0, ask_object	
	li a7, 4
	ecall
	
	li a0, MAX_OBJECT	#  print maximum of usable objects
	jal ra, print
	jal ra, print_new_line
	
	li a7, 5	#get object input as integer
	ecall
	
	# now checkingg if the input was valid
	beqz a0, invalid_object
	
	li t0, MAX_OBJECT
	bgtu a0, t0, invalid_object
	
	
	li t0, 1
	beq a0, t0, glider_object
	
	li t0, 2
	beq a0, t0, smiley_object

	
	glider_object:
	la a3, glider			# load adress of object to print
	j finished_question_object
	
	smiley_object:
	la a3, smiley			# load adress of object to print
	j finished_question_object
	
	finished_question_object:
	jal ra, question_object_pos	# returning pos on a1;a2 # not using a3 there so i do not need to save it
	jal ra, draw_object
	#resetting t0|ra
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8	
	ret
	
	invalid_object:
	la a1, question_object	# jump back to where we start if invalid input
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4
	j invalid_input
	

question_object_pos:
# input a3 adress of object
	addi sp, sp, -28
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw t0, 8(sp)
	sw t1, 12(sp)
	sw t2, 16(sp)
	sw t3, 20(sp)
	sw ra, 24(sp)
	
	
	jal ra, get_object_size		# return a1|a2 with widht and height
	mv t0, a1			# securing widht and height
	#addi t0, t0, -1
	mv t1, a2
	#addi t1, t1, -1
	
	la s0, settings			# i need gamefield size and cell size
	lw s1, 0(s0)			# cell size
	lw t3, 12(s0)			# widht
	
	
	la a0, ask_object_x_pos	
	li a7, 4
	ecall
	
	sub t3, t3, s1			# last row|right edge cell
	div t3, t3, s1			# max cells before edge
	sub t3, t3, t0			# input cells
	mv a0, t3
	jal ra, print
	jal ra, print_new_line
	
	li a7, 5	#get object input as integer
	ecall
	
	bltz a0, invalid_object_pos
	bgt a0, t3, invalid_object_pos
	mv t0, a0			# saving correct x pos
	
	# else asking y
	lw t3, 16(s0)			# height
	
	mul t4, s1, t0			# max value to the bottom side
	
	la a0, ask_object_y_pos	
	li a7, 4
	ecall
	
	sub t3, t3, s1			# last row|right edge cell
	div t3, t3, s1			# max cells before edge
	sub t3, t3, t1			# object cell height
	mv a0, t3
	jal ra, print
	jal ra, print_new_line
	
	li a7, 5	#get object input as integer
	ecall
	
	bltz a0, invalid_object_pos
	bgt a0, t3, invalid_object_pos
	mv t1, a0			# saving correct y pos
	
	mv a1, t0		# writing in output adress
	mv a2, t1
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	lw t2, 16(sp)
	lw t3, 20(sp)
	lw ra, 24(sp)
	addi sp, sp, 28
	
	ret
	
	invalid_object_pos:
	la a1, question_object_pos
	
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	lw t2, 16(sp)
	lw t3, 20(sp)
	lw ra, 24(sp)
	addi sp, sp, 28
	j invalid_input


invalid_input:
# a1 is used for the try again jump, you need to la a1, your_label
# a0 will print the message

	
	# printing that given answer was invalid
	la a0, invalid_input_message
	li  a7, 4          
	ecall
	jr a1


print:
	#Input:
	# a0: integer value is printed
	# print integer

	li  a7, 1          
	ecall
	ret 

print_new_line:
	# new line
	la a0, new_line
	li  a7, 4          
	ecall
	ret
end:
