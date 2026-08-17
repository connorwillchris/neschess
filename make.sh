#!/usr/bin/sh

# folder for my ca65 executables
FOLDER="$HOME/.programs/cc65/bin"

$FOLDER/ca65 rook.s -o rook.o --debug-info
$FOLDER/ca65 main.s -o game.o --debug-info

# finally...

$FOLDER/ld65 game.o rook.o -o game.nes -t nes --dbgfile game.dbg
