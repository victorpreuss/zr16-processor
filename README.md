
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
# create the project hierarchy for ghdl
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
The top level module used for simulation is named **main.vhd**. It implements the whole processor,
The same process can be used to run the simulation of the top level module, which is called **main**:
```
# setup
$ ghdl -i --std=08 --workdir=work src/*.vhd tb/*.vhd
$ ghdl --gen-makefile --std=08 --workdir=work -Plib main > Makefile
# use 'make run' everytime the code is updated
$ make run GHDLRUNFLAGS="--stop-time=time --vcd=./etc/waves/main.vcd"
# after a new 'make run' just refresh the gtkwave screen
$ gtkwave ../etc/waves/main.vcd &
```
### HW Prerequisites



### Deploying on the Mojo board

## The ZR16 processor

This is the block diagram of the current implementation of ZR16 processor.

![Block diagram of implemented ZR16 processor](https://i.imgur.com/1Gfiahf.png)

It contains all the fundamental block displayed on SDMH power point presentation.

### Registers

### Stack

### Instructions

## Author

## License

## Acknowledgements

Thanks to the folks at Santa Maria DH who developed the ZR16S08 microprocessor and provide a nice documentation about their processor.
Also a special thanks for professor Eduardo Bezerra who came up with the project idea and helped with insights throughout the implementation.



Important commands:

$ ghdl -i --std=08 --workdir=work tb/*.vhd src/*.vhd
$ ghdl -m --std=08 --workdir=work -Plib "top module"
$ ghdl --gen-makefile --std=08 --workdir=work -Plib "top module" > Makefile
$ make run -GHDLRUNFLAGS="--stop-time=200ns --vcd=./etc/waveform.vcd"
$ gtkwave ./etc/waveform.vcd &

The -i option scan, parse and add the files to the library without analyzing
The -m option analyze and compile the design for simulation
