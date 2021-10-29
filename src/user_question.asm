
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
	
	addi sp, sp, -4
	sw t0, 0(sp)
	
	la a1, question_cell_size	# jump back to where we start if invalid input

	# ask user about cell size
	la a0, ask_cell_size	
	li a7, 4
	ecall

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
	addi sp, sp, 4	
	ret
	
	invalid_cell_size:
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4
	j invalid_input


question_rule:

	addi sp, sp, -4
	sw t0, 0(sp)

	la a1, question_rule	# jump back to where we start if invalid input

	# ask user about rule to apply
	la a0, ask_rule_to_apply	
	li a7, 4
	ecall

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
	addi sp, sp, 4	
	ret
	
	invalid_rule:
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4
	j invalid_input

question_time:

	addi sp, sp, -4
	sw t0, 0(sp)
	
	la a1, question_time	# jump back to where we start if invalid input
	# ask user about time till next generation should be rendered
	la a0, ask_time_till_next_generation
	li a7, 4
	ecall
	
	# here we will accept anything
	li a7, 5	#get time input as integer
	ecall
	
	li t0, 100000		# i am setting a limit because inever want to see someone wait 7,101467089947 weeks??!
	bgt a0, t0, invalid_time
	
	# loading setting address
	la t0, settings
	sw a0, 24(t0)
	
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4	
	ret
	
	invalid_time:
	#resetting t0
	lw t0, 0(sp)
	addi sp, sp, 4
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
	li t0, 10		# lower would be boring
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
 
end:
