# ZR16-processor

 VHDL implementation of the processor contained in the ZR16S08 microcontroller  developed by SMDH/Chipus.

## Getting Started

These instructions should enable you to get up and running with the simulation of the [ZR16 processor](http://w3.ufsm.br/smdh/files/ZR16S08_datasheet.pdf). It also includes instructions to synthesize the code and deploy it on a Spartan 6 Xilinx FPGA using the [Mojo Board](https://embeddedmicro.com/products/mojo-v3).

### Prerequisites

For the digital simulation of the individual modules and the top-level, the open-source VHDL simulator GHDL was used. GTKWave was used to visualize the generated waveforms. To install GHDL and GTKWave, type in the terminal console:
```
$ sudo apt-get install ghdl gtkwave
```
The development was done using versions `GHDL 0.36-dev (v0.35-44-g1199680) [Dunoon edition]` and `GTKWave Analyzer v3.3.66 (w)1999-2015 BSI`.

### Installing

## Running the tests

## Deploying on the Mojo board

## Introduction to ZR16S08 processor

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
