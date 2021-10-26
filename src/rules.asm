

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

	la t0, settings
	lw t1, 20(t0)	# rule
	li s0, 1	# first rule
	
	beq s0, t1, rule_1
	
	
	rule_1:

	lw t1, 28(t0)	#density
	lw s0, 12(t0)	# widht size
	lw s1, 16(t0)	# height size
	lw s2, 0(t0)	# cell size

	
	li t2, 0
	li t3, 0
	
	through_gamefield:
	# current cell:
		mv a1, t2
		mv a2, t3
		jal neighboor_status
		mv a0, a4	# print status ehre to safe?
		li  a7, 1          
		ecall
		
		# going to next cell
		la a0, finished_rule	# where to go if gamefield is finished
		#current pos
		mv a1, t2	
		mv a2, t3
		mv a3, s2	# cell size
		mv a4, s0	# max widht
		mv a5, s1	# max height
		jal ra, continue_gamefield
		# load coords of next cell
		mv t2, a1
		mv t3, a2
		j through_gamefield
	
	
	finished_rule:
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
