

.include "constants_settings.asm"
# init

jal ra, init_user_questioning
jal ra, init_gamefield

game_loop:
# our set wait timer

#ebreak
jal ra, key_listener
la t0, settings
lw a0, 24(t0)
li a7, 32
ecall
jal ra, next_generation
#li a0, 100
#li a7, 9
#ecall
j game_loop

#li a0, 10000
#li a7, 32
#ecall
.include "user_question.asm"
.include "gamefield.asm"
.include "rules.asm"
.include "draw_objects.asm"
.include "user_key_interface.asm"
