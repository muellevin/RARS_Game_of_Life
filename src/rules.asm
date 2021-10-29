

next_generation:
	# saving all needed register those of rules as well
	addi sp, sp, -32
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw s0, 16(sp)
	sw s1, 20(sp)
	sw s2, 24(sp)
	sw ra, 28(sp)
	
	la s0, state_bits	# base adress for state bits
	li s2, 31	# bits in one word +1 bit your bit; i changed the register at a later point
	li s1, 0	# first value
	
	la t0, settings
	lw t1, 20(t0)
	
	li t2, 0
	li t3, 0
	
	through_gamefield:
	# current cell:
		mv a1, t2
		mv a2, t3
		jal neighboor_status	# return with a4 count living neighboors
		# current cell; incase i have done something stupid in neighboor_status
		mv a1, t2
		mv a2, t3
		
		li t0, 1	# min rule == 1
		# now the magic begins
		
		la ra, set_status_bit	# directly jump there instead jump in here again
		bne t0, t1, check_rule_2
		j rule_1	# returning status bit -->1 -> change status (dead -> alive; alive ->dead)
		# normal conway

		# anti conway
		check_rule_2:
		li t0, 2
		bne t0, t1, check_rule_3
		j rule_2
		
		# copy 
		check_rule_3:
		li t0, 3
		bne t0, t1, check_rule_4
		j rule_3
		
		check_rule_4:
		li a4, 0
		
		# well shouldn't be possible
		## switch rule call a4 -> next status of current cell is a4 as well	
		
		
		set_status_bit:

		sll a4, a4, s2
		add s1, s1, a4
		addi s2, s2, -1
		bgez s2, same_status_word
		
		sw s1, 0(s0)		# saving the status bits
		li s2, 31		# resetting bit count
		li s1, 0		# resetting saving word
		addi s0, s0, 4		# going to next word adress
		
		same_status_word:
		# going to next cell
		la a0, finished_rule	# where to go if gamefield is finished
		#current pos
		mv a1, t2	
		mv a2, t3
		jal ra, next_cell_edge_detection
		# load coords of next cell
		mv t2, a1
		mv t3, a2
		j through_gamefield
	
	
	finished_rule:
	sw s1, 0(s0)		# saving the status bits; incase of cells not divideable to 32
	# now the fun begins:: print the next generation
	jal ra, print_next_generation
	
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw s0, 16(sp)
	lw s1, 20(sp)
	lw s2, 24(sp)
	lw ra, 28(sp)
	addi sp, sp, 32
	ret


# normal conways
rule_1:
# a1 x pos of cell
# a2 y pos of cell
# input a4 with number of living neighboors
# return a4 if status bit is set -> change cell status dead/alive

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	li t0, 2
	bne a4, t0, rule_1_3
	# well this means no chances
	# can not relieve dead cells
	# alive cells can not be dead
	jal ra, nochange_bit	# ra is not set to finish yet
	j back_rule_1
	
	rule_1_3:
	jal ra, get_pixel	# return color code in a3 -> status of cell
	# i need the status for the other rules so i am calling it now
	
	# after that ra need to be the finished rule so...
	la ra, back_rule_1
	
	li t0, 3
	bne a4, t0, dead_rule_1
	
	# now i need the current status of the cell
	bnez a3, nochange_bit
	# this means the cell rebirth
	j change_bit
	
	dead_rule_1:	# not all can survive...now die or stay dead
	
	bnez a3, change_bit	# cell dies
	# well at this point the cell is dead and stays dead
	j nochange_bit
	
	back_rule_1:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret

# aanti conways
rule_2:
# a1 x pos of cell
# a2 y pos of cell
# input a4 with number of living neighboors
# return a4 if status bit is set -> change cell status dead/alive

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	li t0, 6
	bne a4, t0, rule_2_5
	# well this means no chances
	# can not relieve dead cells
	# alive cells can not be dead
	jal ra, nochange_bit	# ra is not set to finish yet
	j back_rule_2
	
	rule_2_5:
	jal ra, get_pixel	# return color code in a3 -> status of cell
	# i need the status for the other rules so i am calling it now
	
	# after that ra need to be the finished rule so...
	la ra, back_rule_2
	
	li t0, 5
	bne a4, t0, alive_rule_2
	
	# now i need the current status of the cell
	bnez a3, change_bit
	# this means the cell dies
	j nochange_bit
	
	alive_rule_2:	# not all can stay dead
	
	bnez a3, nochange_bit	# cell stay alive
	# well at this point the cell is dead and get to be a living beeing
	j change_bit
	
	back_rule_2:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret


# copy world
rule_3:
# a1 x pos of cell
# a2 y pos of cell
# input a4 with number of living neighboors
# return a4 if status bit is set -> change cell status dead/alive

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	jal ra, get_pixel	# return color code in a3 -> status of cell
	# after that ra need to be the finished rule so...
	la ra, back_rule_3
	
	li t0, 2	# when a4%2=1 cell set alive else die
	remu t0, a4, t0
	bnez t0, rule_3_alive	# cell is to set alive or stay alive
	
	# the cell is dead
	bnez a3, change_bit	#cell is alive but should die now
	# cell si deead and stays dead
	j nochange_bit
	
	rule_3_alive:
	bnez a3, nochange_bit	# cell is alive and stay alive
	# cell is dead and should be alive now
	j change_bit
		
	back_rule_3:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret


change_bit:
li a4, 1
ret

nochange_bit:
li a4, 0
ret
