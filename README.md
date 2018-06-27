# ZR16-processor

## Getting Started

### Prerequisites

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

Thanks to the folks at Santa Maria DH who developed the ZR16S08 microprocessor and provide a nice documentation about their processor. And a special thanks for professor Eduardo Bezerra who came up with the project idea and helped with insights throughout the implementation.



Important commands:

$ ghdl -i --std=08 --workdir=work tb/*.vhd src/*.vhd
$ ghdl -m --std=08 --workdir=work -Plib "top module"
$ ghdl --gen-makefile --std=08 --workdir=work -Plib "top module" > Makefile
$ make run -GHDLRUNFLAGS="--stop-time=200ns --vcd=./etc/waveform.vcd"
$ gtkwave ./etc/waveform.vcd &

The -i option scan, parse and add the files to the library without analyzing
The -m option analyze and compile the design for simulation
