
ca65 main.s -o game.o --debug-info
ca65 rook_movement.s -o rook.o --debug-info


ld65 game.o rook.o -o game.nes -t nes --dbgfile game.dbg
