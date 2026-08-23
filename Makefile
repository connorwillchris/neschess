# folder for my ca65 executables
FOLDER=$(HOME)/.programs/cc65/bin
AS=ca65
LD=ld65

all: controller.s main.s
	$(AS) controller.s -o controller.o --debug-info
	$(AS) main.s -o game.o --debug-info
	$(LD) game.o controller.o \
	    -o game.nes -t nes --dbgfile game.dbg

clean:
	rm -rf *.o
	rm -rf *.dbg
	rm -rf game.nes

run: all
	fceux game.nes
