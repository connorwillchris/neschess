#!/usr/bin/sh

# makefile for linux/macOS

ca65 main.s -o game.o --debug-info
ld65 game.o -o game.nes -t nes --dbgfile game.dbg
