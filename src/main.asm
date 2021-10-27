

.include "constants_settings.asm"
# init

jal ra, init_user_questioning
jal ra, init_gamefield

game_loop:
# our set wait timer
la t0, settings
lw a0, 24(t0)
li a7, 32
ecall
#ebreak
jal ra, key_listener

jal ra, next_generation
#li a0, 100
#li a7, 9
#ecall
j game_loop

#li a0, 10000
#li a7, 32
#ecall
.include "init_user_question.asm"
.include "init_gamefield.asm"
.include "exercise_solutions/draw_rectangle.asm"
.include "rules.asm"
.include "user_key_interface.asm"
