#   ___ ___ ___ ___   _    ___ ___ _____ _   _ ___ ___ 
#  / __| __/ __| _ \ | |  | __/ __|_   _| | | | _ \ __|
# | (__| _|\__ \  _/ | |__| _| (__  | | | |_| |   / _| 
#  \___|___|___/_|   |____|___\___| |_|  \___/|_|_\___|
#
# Copyright 2021 Michael J. Klaiber

#.include "cesplib_rars.asm"
.include "../src/init_user_question.asm"	# only there i need to define my addresses

# i reordered the draw_pixel to my settings so i need the in the u_test as well
.data
settings:
.word 1	# here we have our cell size. 		1 default for unittest		#addresss by 0
.word RARS_DISPLAY_ADDRESS # display address	defaulting for rars (unittest)		#addresss by 4
.word RARS_KEYBOARD_ADDRESS # keyboard address	defaulting for rars (unittest)		#addresss by 8

# diffrent sizes of display possible unittest to test if all is working
.word 256	# x-size of display		using smallest size unitest don't need max		#addresss by 12
.word 256	# y-size of display									#addresss by 16

.word 0	# rule to use				0 is default/normal Game of Life			#addresss by 20

.word 0	# time till next generation will be displayed in ms 0-2³²-1	in unittest i don't want to wait		#addresss by 24

.word 50	# start density	this is random so no UT								#addresss by 28

.text



li a3, 1
li a4, 1
li a5, 9
li a6, 10
li a7, 0x00ff00
jal draw_rectangle


li a3, 100
li a4, 180
li a5, 140
li a6, 200
li a7, 0xffff00
jal draw_rectangle


li a7,10
ecall

.include "../src/exercise_solutions/draw_rectangle.asm"
