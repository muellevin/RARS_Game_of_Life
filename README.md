# Conway's Game of Life

This assembly project is intended for the DHBW Stuttgart Rechnerarchitektur programming project.

The project implements and display [Conway's Game of Life](https://en.wikipedia.org/wiki/The_Game_of_Life).

The project can run on [RARS](https://github.com/TheThirdOne/rars) and [FPGRARS](https://github.com/LeoRiether/FPGRARS) using the [RISC-V](https://riscv.org/) architecture.


## Authors

Levin Müller:    inf20124@lehre.dhbw-stuttgart.de

## Demo Video

[![IMAGE ALT TEXT](http://img.youtube.com/vi/-h3eH4ubuno/0.jpg)](http://www.youtube.com/watch?v=-h3eH4ubuno "Video Title")

Replace -h3eH4ubuno in the this .md by your YT video

## Description

For a detailed description please have a look at the [wiki page](https://github.com/muellevin/RARS_Game_of_Life/wiki).
It would overload the Readme and that is not someting i want.



### How to run

Simply open the ``main.asm`` file from the ``src`` directory and run it via rars or fpgrars.
For a more detailed description please have a look at the [wiki page](https://github.com/muellevin/RARS_Game_of_Life/wiki)


## Files

src/main.asm # including the settings and needed files (while loop for the game)

src/constants_settings.asm # Contains settings, questions and objects

src/draw_objects.asm    # drawing an object defined in constants_settings.asm

src/gamefield.asm   # This includes the most gamefield logic -> printing cells; init the gamefield; getting the next cell; counting living neighboor; and making the gamefield black.

src/rules.asm   # Here all the rules are currently written and the status of the next generation will be defined.

src/user_key_interface.asm  # In here the user keyboard input will be checked and the game will be changed in corresbonding to the input.

src/user_questions.asm  # All questions and the validation of the answers to those questions are written in here. Corresbonding to the input the settings of the game are set or changed.

test/unittest_draw_object.asm   # in here i will check if the programm can draw an object (i choosed the smiley since it is more complex than the glider).

test/unittest_edge_detection_test.asm   # in here i am checking if the edge detection is working and it returns the correct next cell coordinations.

test/unittest_neighboorCount.asm    # Here i cehck if the programm can count the living neighboors correctly with edge detection and so on.

test/unittest_print_next_status.asm # here i am checking if the next generation is correctly drawn.

test/rule_1 - rule_4    # Here i am checking if the implementation of the rules are correct.

The files from the exercises (draw_rectangle and draw_pixel) and there corrosponding unittest are not listed in here since they are more or less copied from our lessons.
The modification (get_pixel and draw_cell) are in my eyes not meaningfull enough to be mentioned or need to be tested.


## Test
I did not at the the Unittest for draw_rectangle and draw_pixel since those two are exercise solutions and were already tested during the lessons. I still added them in the ``test`` folder but renamed them in a ``.tjson`` file.

Screenshot that shows succedded (unit) tests:

![UT1](https://github.com/muellevin/RARS_Game_of_Life/wiki/images/UT_1.png)
![UT2](https://github.com/muellevin/RARS_Game_of_Life/wiki/images/UT_2.png)