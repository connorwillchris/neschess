# folder for my ca65 executables
FOLDER=$(HOME)/.programs/cc65/bin
AS=$(HOME)/Downloads/cc65/bin/ca65
LD=$(HOME)/Downloads/cc65/bin/ld65

all: controller.s main.s
	$(AS) controller.s -o controller.o --debug-info
	$(AS) main.s -o main.o --debug-info
	$(LD) main.o controller.o -o game.nes -t nes --dbgfile game.dbg

clean:
	rm -rf *.o
	rm -rf *.dbg
	rm -rf game.nes

run: all
	fceux game.nes
