#!/bin/bash

mkdir -p ./bin/obj

nasm -f elf64 Calculator.asm -o bin/obj/Calculator.o
nasm -f elf64 IO.asm -o bin/obj/IO.o

gcc -o bin/Calculator bin/obj/Calculator.o bin/obj/IO.o -nostdlib -static
./bin/Calculator
