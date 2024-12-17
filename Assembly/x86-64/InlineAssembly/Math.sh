#!/bin/bash

mkdir -p bin
g++ -Wno-return-type -masm=intel -s Math.cpp -o bin/Math
./bin/Math
