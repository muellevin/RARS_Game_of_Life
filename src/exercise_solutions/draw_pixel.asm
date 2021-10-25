#   ___ ___ ___ ___   _    ___ ___ _____ _   _ ___ ___ 
#  / __| __/ __| _ \ | |  | __/ __|_   _| | | | _ \ __|
# | (__| _|\__ \  _/ | |__| _| (__  | | | |_| |   / _| 
#  \___|___|___/_|   |____|___\___| |_|  \___/|_|_\___|
#
# Copyright 2021 Michael J. Klaiber


draw_pixel:
# Creates colored pixel at position (x,y)  

# Inputs
#----------------------
#    a1: x
#    a2: y
#    a3: color
# Outputs: None

	#STEP 3a: Save the callee save registers on the stack
	# ADD YOUR STEP x CODE HERE
	addi sp, sp, -16
	sw s0, 0 (sp)
	sw s1, 4 (sp)
	sw s2, 8 (sp)
	sw s3, 12(sp)
	
	la s3, settings
	#STEP 1: Use the constants DISPLAY_ADDRESS and DISPLAY_WIDTH defined in cesplib_rars.asm and the arguments passed via registers a1 and a2 to calculate the memory address that you  need.
	# ADD YOUR STEP x CODE HERE
	lw s0, 4(s3)	# display address
	lw s1, 12(s3)	# y size
	
	# y_offset
	mul s2, s1, a2  # y∗DISPLAY_WIDTH
			
	# crt_address = base_address + x_offset + y_offset
	add s2, a1, s2
	slli s2, s2, 2 # *4 to byte address
	
	add s2, s2, s0 

	#STEP 2: Store the value of a3 in the memory at the address you have calculated before.
	# ADD YOUR STEP x CODE HERE
	# *crt_address = a3
	sw a3, 0(s2)

	#STEP 3b: Don't forget to restore the callee save values
	# ADD YOUR STEP x CODE HERE
	lw s0, 0 (sp)
	lw s1, 4 (sp)
	lw s2, 8 (sp)
	lw s3, 12(sp)
	addi sp, sp, 16
	ret
