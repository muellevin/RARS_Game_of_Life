
# Main file for Game of Life Project
# fpgrars interface
.eqv FPG_DISPLAY_ADDRESS 0xFF000000
.eqv FPG_DISPLAY_WIDTH 320
.eqv FPG_DISPLAY_HEIGHT 240
.eqv FPG_KEYBOARD_ADDRESS 0xFF200000

# rars interface
.eqv RARS_DISPLAY_ADDRESS 0x10010000
.eqv RARS_KEYBOARD_ADDDRESS 0xFFFF0000


.eqv MIN_CELL_SIZE 1
.eqv MAX_CELL_SIZE 8



j init



cesp_sleep:
# Input:
#   a0: number of ms to sleep
  li a7, 32
  ecall
  ret
  

.data

ask_rars_version:
.string "are you using fpgrars(any number) or rars(0)\n"

ask_cell_size:
.string "Size of cells min 1 max 8\n"

ask_time:
.string "time till next generation will be displayed in ms 0-2³²-1 \n"

ask_x_size_display:
.string "x size of display rars(64; 128; 256; 512; 1024)\n"

ask_y_size_display:
.string "y size of display rars(64; 128; 256; 512; 1024)\n"

invalid_input_message:
.string "Somehow you did not gave the valid input try again\n"


settings:
.word 0	# here we have our cell size
.word 0 # display address
.word 0 # keyboard address

# diffrent sizes of display possible
.word 0	# x-size of display
.word 0	# y-size of display

.word 0	# time till next generation will be displayed in ms 0-2³²-1


.text



init:

	# we are using t0 as comparison register and settings address loading 
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
		addi sp, sp, -4
		sw t1, 0(sp)
		li t1, FPG_DISPLAY_ADDRESS
		sw t1, 4(t0)
		
		li t1, FPG_KEYBOARD_ADDRESS
		sw t1, 8(t0)
		
		li t1, FPG_DISPLAY_WIDTH
		sw t1, 12(t0)
		
		li t1, FPG_DISPLAY_HEIGHT
		sw t1, 16(t0)
		
		# restore t1
		sw t1, 0(sp)
		addi sp, sp, 4
		j get_time
	
	version_rars:
	
	get_time:
		
		
	lw a0, 4(t0)
		
	# restore t0
	lw t0, 0(sp)
	addi sp,sp, 4


	
	jal ra, print
	j exit
	


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
	# a1: address to integer that is printed

	# print integer

	li  a7, 1          
	ecall
	# print \n string
	#la a0, newline
	#li  a7, 4          
	#ecall
	ret 
	
	
	
exit:
        # safe exit
        li a7, 10
	ecall
