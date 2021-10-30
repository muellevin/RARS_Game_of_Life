# testing if i can succesfully draw an complex object like smiley

.include "../src/constants_settings.asm"
li a1, 0
li a2, 0
la a3, smiley
jal ra, draw_object

li a7, 10	# ending rars by calling safe exit
ecall

.include "../src/gamefield.asm"
.include "../src/draw_objects.asm"