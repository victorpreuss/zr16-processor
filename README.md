
# ZR16-processor

 VHDL implementation of the processor contained in the ZR16S08 microcontroller developed by SMDH/Chipus.

## Getting Started

These instructions should enable you to get up and running with the simulation of the ZR16 processor ([datasheet](http://w3.ufsm.br/smdh/files/ZR16S08_datasheet.pdf)). It also includes instructions to synthesize the code and deploy it on a Spartan 6 Xilinx FPGA using the [Mojo Board](https://embeddedmicro.com/products/mojo-v3).

### SW Prerequisites

For the digital simulation of the individual modules and the top-level, the open-source VHDL simulator GHDL was used. GTKWave was used to visualize the generated waveforms. To install GHDL and GTKWave:
```
$ sudo apt-get install ghdl gtkwave
```
The project was tested using versions `GHDL 0.36-dev (v0.35-44-g1199680) [Dunoon edition]` and `GTKWave Analyzer v3.3.66 (w)1999-2015 BSI`.

Since the project was developed for the Mojo board, the tool used to synthesize the code was Xilinx ISE 14.7 using a student license. This step is not necessary to run the simulations.
The ISE can be downloaded in the Xilinx website [here](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools/v2012_4---14_7.html) and the EmbeddedMicro folks (who developed the Mojo Board) have a good tutorial on installing and licensing the tool [here](https://embeddedmicro.com/pages/installing-ise).

### Running the simulation and testbenches

The source code is available inside this repository:
```
$ git clone https://github.com/victorpreuss/zr16-processor.git
```
To run a testbench, first you need to run the following commands to create a Makefile for the module's testbench:
```
$ cd zr16-processor
# scan and parse the files to create ghdl project hierarchy
$ ghdl -i --std=08 --workdir=work src/*.vhd tb/*.vhd
# change module_tb for the desired module (e.g.: control_unit_tb)
$ ghdl --gen-makefile --std=08 --workdir=work -Plib module_tb > Makefile
```
Now to run the testbench multiple times, while editing the code, you can simply:
```
# change the 'time' for the desired simulation time (e.g.: 300ns)
$ make run GHDLRUNFLAGS="--stop-time=time --vcd=./etc/waves/module_tb.vcd"
```
To visualize the waveform saved in the /etc/waves directory, use:
```
$ gtkwave ../etc/waves/module_tb.vcd &
```
The top level module used for simulation is named **src/main.vhd**. It implements the whole processor, therefore, the stimulus used during the simulation comes from the binary code saved inside **src/rom.vhd**.
The same process can be used to run the simulation of the top level module, which is called **main**:
```
# simulation setup
$ ghdl -i --std=08 --workdir=work src/*.vhd tb/*.vhd
$ ghdl --gen-makefile --std=08 --workdir=work -Plib main > Makefile
# use 'make run' everytime the code is updated
$ make run GHDLRUNFLAGS="--stop-time=time --vcd=./etc/waves/main.vcd"
# after a new 'make run' simply refresh the gtkwave screen
$ gtkwave ../etc/waves/main.vcd &
```
The binary code running on the processor during the simulation can be changed using the compiler for ZR16 processor instruction set ([download here](http://w3.ufsm.br/smdh/downloads.php)).
To automate the deployment of different codes inside the implemented processor, the script **scripts/run.py** was developed. You can pass as an argument, the Assembly/C code to be deployed and the amount of simulation time desired. The scripts automatically compiles the the code, store it inside **src/rom.vhd** and run the ghdl simulation. Check an example:
```
$ cd scripts
$ ./run.py -f ../etc/code/main.c -t 20us
```
Inside the folder **etc/codes**, there are some examples of ZR16 Assembly and C codes.

The script **scrtips/run.py** assumes that you downloaded the compilers and pasted them inside the folder **zr16-processor/etc/compiler**. The files that you must paste inside this folder are:
- ZR16_Compiler.exe (Assembly compiler)
- ZR16_C_Compiler.exe (C compiler)
- ZR16_Compiler_DLL.dll

Those files were not shipped in the repository since they belong to SMDH and you can download them from their website ([here](http://w3.ufsm.br/smdh/downloads.php)).
It also assumes that you have [Wine](https://www.winehq.org/) installed (since the compilers were developed for Windows). You can install it by typing:
```
$ sudo apt-get install wine
```

There are also other scripts to simplify the simulation and/or hardware deployment:
- For simulation:
	- compile.sh - Compile an assembly code given as input argument
	- ccompile.sh - Compile a C code given as input argument
	- genrom.py - Takes a compiled binary file (.stringhex) for ZR16 and paste it into **src/rom.vhd**
- For hardware deployment:
	- upload_to_flash.sh - upload the FPGA binary to the flash memory chip in the Mojo board (requires [mojo-loader](https://github.com/embmicro/mojo-loader))
	- upload_to_ram.sh - upload the FPGA binary to the FPGA volatile memory (also requires [mojo-loader](https://github.com/embmicro/mojo-loader))
	- serialcomm.py - serial communication with FPGA to get the registers and RAM memory data (debug)

### HW Prerequisites



### Deploying on the Mojo board

## The ZR16 processor

This is the block diagram of the current implementation of ZR16 processor.

![Block diagram of implemented ZR16 processor](https://i.imgur.com/1Gfiahf.png)

It contains all the fundamental block displayed on SDMH power point presentation.

### Registers

### Stack

### Instructions

### What is missing?

## Authors
- **Victor Hugo Bueno Preuss** - *Initial Work*
	- Postgraduate Student in UFSC - Electrical Engineering Department
	- email: victor.preuss@posgrad.ufsc.br
## License

## Acknowledgements

Great thanks to the folks at Santa Maria DH who developed the ZR16S08 microprocessor and provide a nice documentation about it. (**That's brazillian technology! Brilliant!**)
Also a special thanks for professor Eduardo Augusto Bezerra who came up with the project idea and helped with insights throughout the implementation.
