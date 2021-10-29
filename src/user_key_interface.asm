
# user interaction during execution
key_listener:
	addi sp, sp, -32
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw t0, 16(sp)
	sw t1, 20(sp)
	sw t2, 24(sp)
	sw t3, 28(sp)


	la s0, settings
	lw s1, 8(t0)

	# using t2 as pause loop
	li t2, 0
	li t3, 0	# as temp for stuff
	pause_loop:
		# getting our keyboard value 
		lw t0, 0(s1) # valid key input
		beq t0, zero switch.end
		lw t0, 4(s1)	#load key value
		switch.start:
  			switch.pause:
  				li t1, 'p'
  				bne t0, t1, switch.plus
  				beqz t2, set_pause
  				li t2, 0
  				j switch.end
  				set_pause:
  				li t2, 1	# setting pause till next pause
  				j switch.end
    
  			switch.plus:
  				li t1, '+'
  				bne t0, t1 switch.minus
  				lw t3, 24(s0)		# loading timme to next gen
  				addi t3, t3, 1		# yes no overflow detection because who the hell would do 7,101467089947 weeks??!
  				sw t3, 24(s0)
  				j switch.end
  				
  			switch.minus:
  				li t1, '-'
  				bne t0, t1 switch.reset	##TODO
  				lw t3, 24(s0)		# loading timme to next gen
  				beqz t3, switch.end	# Might print a message in future
  				addi t3, t3, -1		
  				sw t3, 24(s0)
  				j switch.end
  				
  			switch.reset:
  				li t1, 'r'
  				bne t0, t1 switch.life_rule
  				jal ra, reset	# complete reset settings to input
  				jal ra, init_gamefield		# i need a new gamefield
  				j switch.end
  				
  			switch.life_rule:
  				li t1, 'l'
  				bne t0, t1 switch.black_screen
  				jal ra, question_rule
  				j switch.end
  				
  			switch.black_screen:			# for some rules and (maybe i will add) objects it is good to have a clear screen
  				li t1, 'b'
  				bne t0, t1 switch.change_color
  				jal ra, print_black_display
  				j switch.end
  				
  			switch.change_color:			# for some rules and (maybe i will add) objects it is good to have a clear screen
  				li t1, 'c'
  				bne t0, t1 switch.time
  				jal ra, question_colour
  				jal ra, print_colour_display
  				j switch.end
  			
  			switch.time:			# in case you messed the time really bad
  				li t1, 't'
  				bne t0, t1 switch.finish
  				jal ra, question_time
  				j switch.end
  			
  			switch.finish:
  			li t1, 'e'
  			bne t0, t1, switch.end
  			li a7, 10	# ending rars by calling safe exit
			ecall
  				

switch.end:
	li t0, 0
	li t1, 0
	sw t0, 0(s1)
	sw t1, 4(s1)
	
	bnez t2, pause_loop	# pause is set
	
	# restore variables
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw t0, 16(sp)
	lw t1, 20(sp)
	lw t2, 24(sp)
	lw t3, 28(sp)
	addi sp, sp, 32
	ret

reset:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw t0, 4(sp)
	sw t1, 8(sp)
	
	la t0, settings
	
	#reset display:
	jal ra, print_black_display
	
	jal ra, question_cell_size
	
	lw t0, 4(t0)	# display adress
	li t1, RARS_DISPLAY_ADDRESS
	
	bne t0, t1, continue_reset
	jal ra, version_rars
	continue_reset:
	jal ra, question_rule
	jal ra, question_time
	jal ra, question_start_density
			
	# restore stack variables
	lw ra, 0(sp)
	lw t0, 4(sp)
	lw t1, 8(sp)
	addi sp,sp, 12

ret
