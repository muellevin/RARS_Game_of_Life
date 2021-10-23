
# making a RANDOM NUMBER 0-100 (saved in a0)
.macro rand
li a1, 100
li a7, 42
ecall
.end_macro



init_gamefield:

	la t0, settings
	lw t1, 28(t0)	#density
	
	rand
	bleu a1, t1, cell_alive
	
	cell_not_alive:
	
	
	cell_alive:
	