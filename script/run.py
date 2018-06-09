#!/usr/bin/python3

import os
import argparse
from genrom import generate_rom_vhdl

def main():
    parser = argparse.ArgumentParser(description='ZR16S08 CLI')

    parser.add_argument('-f', '--file', dest='file', action='store', type=str,
                        help='Assembly or C file to run simulation')

    parser.add_argument('-t', '--time', dest='time', action='store', type=str,
                        help='Simulation time')

    args = parser.parse_args()

    if (os.path.isfile(args.file) == True):
        if (args.file[-2:] == '.c'):
            rom_data = compile_c_file(args.file)
        elif (args.file[-5:] == '.zr16'):
            rom_data = compile_asm_file(args.file)
        else:
            print('The file is not an assembly or C code')
            exit(1)
    else:
        print('File not found!')
        exit(1)

    generate_rom_vhdl(rom_data)
    rom_data.close()

    run_simulation(args.time)

def compile_c_file(file_name):
    cmd = 'TZ=Europe/Berlin wine ../etc/compiler/ZR16_C_Compiler.exe' + file_name + '-asm -debug'
    ret = os.system(cmd)
    print(ret)

    return open(file_name[:-2] + '.zr16.stringhex')

def compile_asm_file(file_name):
    cmd = 'TZ=Europe/Berlin wine ../etc/compiler/ZR16_Compiler.exe ' + file_name + ' -debug'
    ret = os.system(cmd)
    print(ret)

    return open(file_name + '.stringhex')

def run_simulation(time):
    cmd = 'cd .. && make run GHDLRUNFLAGS="--stop-time=' + time + ' --vcd=./etc/waves/main.vcd"'
    ret = os.system(cmd)
    print(ret)

main()
