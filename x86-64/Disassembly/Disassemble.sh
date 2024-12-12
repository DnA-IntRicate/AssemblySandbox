#!/bin/bash

gcc -masm=intel -S Hello.c -o Hello.asm
code Hello.asm
