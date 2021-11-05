
# i sorted this out now because this looks better and is easier to use




.data

.eqv MAX_OBJECT 4	# min is 1

glider:
.word 0x00030003	# 16BIt height| 16 bit widht
.word 0x35800000	# expression of glider status 001|101|011 -> 3x3 cells needed

smiley:
.word 0x00080009
.word 0x3E20A530
.word 0x1A2CE504
.word 0x7c000000


r_pent:
.word 0x00030003	# 16BIt height| 16 bit widht
.word 0x79000000	# Bitmuster 011110010 + filling 0

glider_gun:
.word 0x000b0026	# 16BIt height| 16 bit widht
.word 0			# first and last row empty (buffer for views)
.word 0x00000001
.word 0
.word 0x14000001
.word 0x81800600
.word 0x08860019
.word 0x80411800
.word 0x06011614
.word 0x00000410
.word 0x10000008
.word 0x80000000
.word 0x18000000
.word 0

.text