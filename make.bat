
set AS=ca65
set LD=ld65

:: ASSEMBLE ALL FILES ::
%AS% controller.s    -o controller.o     --debug-info
%AS% main.s          -o game.o           --debug-info
:: LINK THE PROGRAM NOW ::
%LD% game.o controller.o -o game.nes -t nes --dbgfile game.dbg
