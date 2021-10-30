# here ia can now draw objects

# testing
#.include "constants_settings.asm"
#li a1, 0
#li a2, 0
#la a3, glider
# will deletet

draw_object:
# input start coord ## checked in user question
# a1 x coord
# a2 y coord
# a3 the object to draw

addi sp, sp, -40
sw s0, 0(sp)	# base adress of object
sw s1, 4(sp)	# base adress for setting -> cell size
sw s2, 8(sp)	# word where status of object is saved
sw t0, 12(sp)	# start position x
sw t1, 16(sp)	# start psoition y
sw t2, 20(sp)	# end position x
sw t3, 24(sp)	# end position y
sw t4, 28(sp)	# temp for saving status cell
sw t5, 32(sp)	# shifting the status of cell to correct use
sw ra, 36(sp)	# i jump a bit


mv s0, a3	# saving the adress of the object

la s1, settings
lw s1, 0(s1)	# i need the cell size to get the real coords

mul t0, a1, s1	# the start coords for object
mul t1, a2, s1

# i need the x coord later again -> save it
addi sp, sp, -4
sw t0, 0(sp)

jal ra, get_object_size

mul t2, a1, s1 	# object widht
add t2, t2, t0
mul t3, a2, s1	# object hight
add t3, t3, t1

li t4, 0	# used to save the status of the cell
li t5, 31	# how much i need to shift


lw s2, 4(s0)	# where the object cell status is

	_loopy_object:
		_loopx_object:	
			srl t4, s2, t5		# shifting the cell status
			andi t4, t4, 1		# get the single cell status
			
			mv a1, t0	# coords of current cell
			mv a2, t1
			
			jal ra, get_pixel	# even a bit faster is faster
			
			la ra, continue_draw_object_loop	# where to go after prining cell
			
			bnez t4, print_living_cell_object
			
			bnez a3, print_dead_cell	# the cell is suddenly alive but should be dead	
			jr ra				# 
			
			print_living_cell_object:
			beqz a3, print_living_cell	# cell is dead but should be alivee
			
			
			continue_draw_object_loop:
			# securing correct shift
			addi t5, t5, -1
			bgez t5, continue_loopx_object
			li t5, 31
			addi s0, s0, 4		# i need the next word to load the object
			lw s2, 4(s0)		# where the next object cell status is
			
			continue_loopx_object:
			add t0, t0, s1
			ble t0, t2 _loopx_object
		
		add t1, t1, s1
		lw t0, 0(sp)		
		ble t1, t3, _loopy_object

# i need to restore it the correct way
lw t0, 0(sp)
addi sp, sp, 4


lw s0, 0(sp)	
lw s1, 4(sp)	
lw s2, 8(sp)	
lw t0, 12(sp)	
lw t1, 16(sp)	
lw t2, 20(sp)	
lw t3, 24(sp)	
lw t4, 28(sp)	
lw t5, 32(sp)	
lw ra, 36(sp)	
addi sp, sp, 40
ret


get_object_size:
# input base object adress in a3 and will not be changed!!

# output a1 widht
# output a2 height
addi sp, sp, -8
sw t0, 0(sp)
sw t1, 4(sp)

lw t0, 0(a3)	# size of object
li t1, 0xffff	# mask for widht

and a1, t0, t1	# widht		## andi can only do 12 Bit but i need 16
addi a1, a1, -1	# widht start point is 1 not zero in data section

srli a2, t0, 16	# height
addi a2, a2, -1	# same like widht

lw t0, 0(sp)
lw t1, 4(sp)
addi sp, sp, 8

ret

#.include "gamefield.asm"