
set AS=ca65
set LD=ld65

%AS% controller.s    -o controller.o     --debug-info
%AS% main.s          -o game.o           --debug-info

%LD% game.o controller.o -o game.nes -t nes --dbgfile game.dbg
