
.include "init_user_question.asm"

.data 

settings:
.word 1	# here we have our cell size. 		1 default for unittest		#addresss by 0
.word RARS_DISPLAY_ADDRESS # display address	defaulting for rars (unittest)		#addresss by 4
.word RARS_KEYBOARD_ADDRESS # keyboard address	defaulting for rars (unittest)		#addresss by 8

# diffrent sizes of display possible unittest to test if all is working
.word 64	# x-size of display		using smallest size unitest don't need max		#addresss by 12
.word 64	# y-size of display									#addresss by 16

.word 0	# rule to use				0 is default/normal Game of Life			#addresss by 20

.word 0	# time till next generation will be displayed in ms 0-2³²-1	in unittest i don't want to wait		#addresss by 24

.word 50	# start density	this is random so no UT								#addresss by 28

.text

jal ra, init_user_questioning
jal ra, init_gamefield

# safe exit
        li a7, 10
	ecall


.include "init_gamefield.asm"
.include "exercise_solutions/draw_rectangle.asm"