

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
	li s0, 0	# first rule
	
	beq s0, t1, rule_0
	
	
	rule_0:

	lw t1, 28(t0)	#density
	lw s0, 12(t0)	# x size
	lw s1, 16(t0)	# y size
	lw s2, 0(t0)	# cell size
	
	li t2, 0
	li t3, 0
	
	mv a1, t2
	mv a2, t3
	
	jal ra, neighboor_status
	mv a0, a4
	li  a7, 1          
	ecall
	
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