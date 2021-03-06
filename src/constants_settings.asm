

.data

.space 1048576	# Addressing for 512x512 Display addresses -> bug at 0x1040...
# it is disgusting but i guess the easiest solution for now
state_bits:
.space 32768	# malloc for 512x512Pixel/32Bits of word x 4 addressing
# it is disgusting but i guess the easiest solution for now

.eqv FPG_DISPLAY_ADDRESS 0xFF000000
.eqv FPG_DISPLAY_WIDTH 320
.eqv FPG_DISPLAY_HEIGHT 240
.eqv FPG_KEYBOARD_ADDRESS 0xFF200000

# rars interface
.eqv RARS_DISPLAY_ADDRESS 0x10010000
.eqv RARS_KEYBOARD_ADDRESS 0xFFFF0000

.eqv MIN_DISPLAY_SIZE 64	# display size need to be 2^x | 6 <= x <= 9
.eqv MAX_DISPLAY_SIZE 512	# RARS bug!!! 1024x1024 result in adress access error

.eqv MIN_CELL_SIZE 1
.eqv MAX_CELL_SIZE 16

.eqv MAX_RULE 4		# min rule 1

.eqv MAX_TIME_DELAY 100000	# min is obviosly 0

#.eqv ALIVE 0xa0a397 

ask_rars_version:
.string "are you using fpgrars(any number) or rars(0)\n"

ask_cell_size:
.string "Size of cells min 1 max "

ask_x_size_display:
.string "height of display rars(64; 128; 256; 512)\n"

ask_y_size_display:
.string "width of display rars(64; 128; 256; 512)\n"

ask_rule_to_apply:
.string "which rule do you want tu use min 1 max "

ask_time_till_next_generation:
.string "how much time in ms should the programm wait till next generation is shown max "

ask_start_density:
.string "Density of living cells when starting Game of Life (0-100)%\n"

ask_colour:
.string "What color do you like?\n"

ask_object:
.string "Which object do you want? MAX: \t"

ask_object_x_pos:
.string "Which x position (cell)?\n MAX:\t"

ask_object_y_pos:
.string "Which y position (cell)?\n MAX:\t"

invalid_input_message:
.string "Somehow you did not gave the valid input try again\n"

new_line:
.string "\n"

settings:
.word 1	# here we have our cell size. 		1 default for unittest		#addresss by 0
.word RARS_DISPLAY_ADDRESS # display address	defaulting for rars (unittest)		#addresss by 4
.word RARS_KEYBOARD_ADDRESS # keyboard address	defaulting for rars (unittest)		#addresss by 8

# diffrent sizes of display possible unittest to test if all is working
.word 64	# width-size of display		using smallest size unitest don't need max		#addresss by 12
.word 64	# height-size of display									#addresss by 16

.word 1	# rule to use				0 is default/normal Game of Life			#addresss by 20

.word 0	# time till next generation will be displayed in ms 0-2????-1	in unittest i don't want to wait		#addresss by 24

.word 50	# start density	this is random so no UT								#addresss by 28

.word 0xa0a397	# color of living cells				# adress by 32

.text

.include "objects.asm"