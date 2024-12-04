#!/bin/bash

mkdir -p bin/obj
nasm -f elf64 UserInput.asm -o bin/obj/UserInput.o
gcc -o bin/UserInput bin/obj/UserInput.o -nostdlib -static
./bin/UserInput

