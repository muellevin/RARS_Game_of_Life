
# here i am testing the 4 rule
# there is a more efficient wayy to test it with loops. But thats faster to do and easier to understand 

.include "../src/constants_settings.asm"

# at this point it is not a mather where the cell is. i will check the status bit

li a1, 0	# i have a pixel check in it so i need an adress to go
li a2, 0	# because this is just initiated the cell should be dead
li a4, 0	# i need a fake living neigboor count

jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 1	
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 2	
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 3
jal ra, rule_4
beqz a4, errorcode	#-> dead should rebirth
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 4	
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 5	
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 6
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 7	
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 8
jal ra, rule_4
bnez a4, errorcode	#-> dead should stay dead
jal ra, print_succes



##############
jal ra, print_new_line
jal ra, print_new_line
# now comencing it with a living cell

li a1, 0	
li a2, 0	
jal ra, print_living_cell

li a1, 0	
li a2, 0
li a4, 0	
jal ra, rule_4
bnez a4, errorcode	#-> living should die
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 1	
jal ra, rule_4
beqz a4, errorcode	#-> living should stay alive
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 2	
jal ra, rule_4
beqz a4, errorcode	#-> living should stay alive
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 3
jal ra, rule_4
beqz a4, errorcode	#-> living should stay alive
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 4	
jal ra, rule_4
beqz a4, errorcode	#-> living should stay alive
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 5	
jal ra, rule_4
beqz a4, errorcode	#-> living should stay alive
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 6
jal ra, rule_4
bnez a4, errorcode	#-> living should die
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 7	
jal ra, rule_4
bnez a4, errorcode	#-> living should die
jal ra, print_succes

li a1, 0	
li a2, 0	
li a4, 8
jal ra, rule_4
bnez a4, errorcode	#-> living should die
jal ra, print_succes


##############
j exit_rule_4_test

print_succes:	# printting 0 for succes
li a0, 0
li  a7, 1        
ecall
# always followed by new_line
print_new_line:
la a0, new_line
li a7, 4
ecall
ret

errorcode:	# printting max int to declare test failed
li a0, -1
li  a7, 1        
ecall
# -> and exit
exit_rule_4_test:
li a7, 10	# ending rars by calling safe exit
ecall



.include "../src/rules.asm"
.include "../src/gamefield.asm"	# just using that for the single print
