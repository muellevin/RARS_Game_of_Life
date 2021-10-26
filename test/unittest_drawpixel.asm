#   ___ ___ ___ ___   _    ___ ___ _____ _   _ ___ ___ 
#  / __| __/ __| _ \ | |  | __/ __|_   _| | | | _ \ __|
# | (__| _|\__ \  _/ | |__| _| (__  | | | |_| |   / _| 
#  \___|___|___/_|   |____|___\___| |_|  \___/|_|_\___|
#
# Copyright 2021 Michael J. Klaiber

#.include "cesplib_rars.asm"
.include "../src/constants_settings.asm"


la t0, settings
li t1, 256		#exercise solution have 256x256

sw t1, 12(t0)
sw t1, 16(t0)


utest_draw_pixel:
	li a1, 45
	li a2, 40
	li a3, 0x00ff00
	jal draw_pixel
	
	li a1, 47
	li a2, 40
	li a3, 0xff0000
	jal draw_pixel	

	li a1, 250
	li a2, 250
	li a3, 0xffffff
	
	
	line:
	jal draw_pixel	
	addi a1, a1,-1
	bne zero, a1, line
	
	

li a7, 10
ecall

.include "../src/exercise_solutions/draw_pixel.asm"
