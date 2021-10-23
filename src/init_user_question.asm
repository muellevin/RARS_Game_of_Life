
# Main file for Game of Life Project
# fpgrars interface
.eqv FPG_DISPLAY_ADDRESS 0xFF000000
.eqv FPG_DISPLAY_WIDTH 320
.eqv FPG_DISPLAY_HEIGHT 240
.eqv FPG_KEYBOARD_ADDRESS 0xFF200000

# rars interface
.eqv RARS_DISPLAY_ADDRESS 0x10010000
.eqv RARS_KEYBOARD_ADDRESS 0xFFFF0000

.eqv MIN_DISPLAY_SIZE 64

.eqv MIN_CELL_SIZE 1
.eqv MAX_CELL_SIZE 8

.eqv MAX_RULE 0	# min rule 0

.data

ask_rars_version:
.string "are you using fpgrars(any number) or rars(0)\n"

ask_cell_size:
.string "Size of cells min 1 max 8\n"

ask_x_size_display:
.string "x size of display rars(64; 128; 256; 512; 1024)\n"

ask_y_size_display:
.string "y size of display rars(64; 128; 256; 512; 1024)\n"

ask_rule_to_apply:
.string "which rule do you want tu use min 0 max 0\n"

ask_time_till_next_generation:
.string "how much time in ms should the programm wait till next generation is shown max 2³²-1\n"

ask_start_density:
.string "Density of living cells when starting Game of Life (10-100)%\n"

invalid_input_message:
.string "Somehow you did not gave the valid input try again\n"

.text

j end	

init_user_questioning:

	# we are using t0 as comparison register and settings address loading 
	# i will not reset the aX registers since they are mostly used for enviromental calls
	addi sp, sp, -4
	sw t0, 0(sp)

	
	get_cell_size:
		la a1, get_cell_size	# jump back to where we start if invalid input
	
		# ask user about cell size
		la a0, ask_cell_size	
		li a7, 4
		ecall
	
		li a7, 5	#get size input as integer
		ecall
	
		# now checkingg if the input was valid
		li t0, MIN_CELL_SIZE
		blt a0, t0, invalid_input
		li t0, MAX_CELL_SIZE
		bgt a0, t0, invalid_input	

		# loading setting address
		la t0, settings
		sw a0, 0(t0)

	question_rars_version:
		# no jump back address needed

		# ask user about cell size
		la a0, ask_rars_version
		li a7, 4
		ecall
	
		li a7, 5	#get size input as integer
		ecall
		
		beqz a0, version_rars
		la t0, settings
		# we are using t1 to safe fpgrars version addresses of keyboard display etc.
		# we are using t2 for directly calculationg cells
		addi sp, sp, -8
		sw t1, 0(sp)
		sw t2, 4(sp)
		
		lw t2, 0(t0)	# cell size
		
		li t1, FPG_DISPLAY_ADDRESS
		sw t1, 4(t0)
		
		li t1, FPG_KEYBOARD_ADDRESS
		sw t1, 8(t0)
		
		li t1, FPG_DISPLAY_WIDTH
		
		divu t1, t1, t2
		sw t1, 12(t0)
		
		li t1, FPG_DISPLAY_HEIGHT
		divu t1, t1, t2
		sw t1, 16(t0)
		
		# restore t1 and t2
		lw t1, 0(sp)
		lw t2, 4(sp)
		addi sp, sp, 8
		j question_rule
	
	version_rars:
		# setting rars enviromenet addresses
		
		la t0, settings
		# we are using t1 to safe fpgrars version addresses of keyboard display etc.
		addi sp, sp, -4
		sw t1, 0(sp)
		
		li t1, RARS_DISPLAY_ADDRESS
		sw t1, 4(t0)
		
		li t1, RARS_KEYBOARD_ADDRESS
		sw t1, 8(t0)
		
		# restore t1
		lw t1, 0(sp)
		addi sp, sp, 4
	
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
		
		# calculating cells
		addi sp, sp, -4
		sw t1, 0(sp)
		
		lw t1, 0(t0)
		divu a0, a0, t1
		sw a0, 12(t0)
		
		# restore t1
		lw t1, 0(sp)
		addi sp, sp, 4


		question_y_display_size:
		# rars can have diffrent display sizes
		la a1, question_y_display_size	# jump back to where we start if invalid input
		la a2, safe_y
		
		# ask user about y-size display
		la a0, ask_y_size_display	
		li a7, 4
		ecall
	
		li a7, 5	#get size input as integer
		ecall
	
		j rars_display_sizes	# a2 is jump register
		
		safe_y:
		la t0, settings
		
		# calculating cells
		addi sp, sp, -4
		sw t1, 0(sp)
		
		lw t1, 0(t0)
		divu a0, a0, t1
		sw a0, 16(t0)
		
		# restore t1
		lw t1, 0(sp)
		addi sp, sp, 4
		
	question_rule:
		la a1, question_rule	# jump back to where we start if invalid input
	
		# ask user about rule to apply
		la a0, ask_rule_to_apply	
		li a7, 4
		ecall
	
		li a7, 5	#get size input as integer
		ecall
	
		# now checkingg if the input was valid
		li t0, 0
		blt a0, t0, invalid_input
		li t0, MAX_RULE
		bgt a0, t0, invalid_input	

		# loading setting address
		la t0, settings
		sw a0, 20(t0)
		
		
	get_time:
		# ask user about time till next generation should be rendered
		la a0, ask_time_till_next_generation
		li a7, 4
		ecall
		
		# here we will accept anything
		li a7, 5	#get size input as integer
		ecall
		
		# loading setting address
		la t0, settings
		sw a0, 24(t0)
	
	get_start_density:
		la a1, get_start_density	# jump back to where we start if invalid input
	
		# ask user about density
		la a0, ask_start_density	
		li a7, 4
		ecall
	
		li a7, 5	#get density input as integer
		ecall
	
		# now checkingg if the input was valid
		li t0, 10
		blt a0, t0, invalid_input
		li t0, 100
		bgt a0, t0, invalid_input	

		# loading setting address
		la t0, settings
		sw a0, 28(t0)
		
		
	# restore t0
	lw t0, 0(sp)
	addi sp,sp, 4

ret
	

rars_display_sizes:
# a0 value to ckeck
# a1 repeat input (call invalid_input)
# a2 valid input -> next instruction to do

	size_64:
	# now checkingg if the input was valid
	li t0, MIN_DISPLAY_SIZE
	bne a0, t0, size_128
	jr a2
	
	size_128:
	slli t0, t0, 1
	bne a0, t0, size_256
	jr a2
		
	size_256:
	slli t0, t0, 1
	bne a0, t0, size_512
	jr a2
		
	size_512:
	slli t0, t0, 1
	bne a0, t0, size_1024
	jr a2
	
	size_1024:
	slli t0, t0, 1
	bne a0, t0, invalid_input
	jr a2


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
        
