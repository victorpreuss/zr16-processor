#!/bin/sh

TZ=Europe/Berlin wine ../etc/compiler/ZR16_Compiler.exe $1 -debug

python3 genrom.py $1

cd ..

make run GHDLRUNFLAGS="--stop-time=$2 --vcd=./etc/waves/main.vcd"
