

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
		# normal conway
		beq t0, t1, rule_1
		# returning status bit -->1 -> change status (dead -> alive; alive ->dead)

		# anti conway
		li t0, 2
		beq t0, t1, rule_2
		
		# exploding labyrint 
		li t0, 3
		bne t0, t1, rule_3

		
		# copy
		li t0, 4
		bne t0, t1, rule_4
		
		# not possible
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
	jal ra, get_pixel	# return color code in a3 -> status of cell
	
	# after that ra need to be the finished rule so...
	la ra, back_rule_1
	
	li t0, 2
	bne a4, t0, rule_1_3
	bnez a3, alive_bit
	j noalive_bit
	# well this means no chances
	# can not relieve dead cells
	# alive cells can not be dead

	rule_1_3:
	li t0, 3
	bne a4, t0, noalive_bit	# well if it is not 2 or 3 it is dead
	j alive_bit
	
	back_rule_1:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret

# anti conways
rule_2:
# a1 x pos of cell
# a2 y pos of cell
# input a4 with number of living neighboors
# return a4 if status bit is set -> change cell status dead/alive

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	jal ra, get_pixel	# return color code in a3 -> status of cell
	
	# after that ra need to be the finished rule so...
	la ra, back_rule_2
	
	li t0, 6
	bne a4, t0, rule_2_5
	# well this means no chances
	# can not relieve dead cells
	# alive cells can not be dead
	bnez a3, alive_bit
	j noalive_bit
	
	rule_2_5:	
	li t0, 5
	bne a4, t0, alive_bit	# if not 5 it is alive
	j noalive_bit
	
	back_rule_2:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret


# labyrinth
rule_3:
# a1 x pos of cell
# a2 y pos of cell
# input a4 with number of living neighboors
# return a4 if status bit is set -> change cell status dead/alive

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	# after that ra need to be the finished rule so...
	la ra, back_rule_3
	
	li t0, 2	# when a4%2=1 cell set alive else die
	remu t0, a4, t0
	bnez t0, alive_bit	# cell is to set alive or stay alive
	j noalive_bit
	# the cell is dead
		
	back_rule_3:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret



# copy
rule_4:
# a1 x pos of cell
# a2 y pos of cell
# input a4 with number of living neighboors
# return a4 if status bit is set -> change cell status dead/alive

	addi sp, sp, -8
	sw t0, 0(sp)
	sw ra, 4(sp)
	
	jal ra, get_pixel	# saved in a3
	la ra, back_rule_4
	
	li t0, 3
	beq a4, t0, alive_bit	# cell gets alive
	
	bnez a4, rule_4_6
	j noalive_bit
	
	rule_4_6:
	li t0, 6
	bltu a4, t0, rule_4_stay
	j noalive_bit
	
	rule_4_stay:
	bnez a3, alive_bit
	j noalive_bit
	
	back_rule_4:
	lw t0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	ret


alive_bit:
li a4, 1
ret

noalive_bit:
li a4, 0
ret
