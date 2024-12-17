#!/bin/bash

mkdir -p bin/obj
nasm -f elf64 HelloWorld.asm -o bin/obj/HelloWorld.o
gcc -o bin/HelloWorld bin/obj/HelloWorld.o -nostdlib -static
./bin/HelloWorld

