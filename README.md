Important commands:

$ ghdl -i --std=08 --workdir=work tb/*.vhd src/*.vhd
$ ghdl -m --std=08 --workdir=work -Plib "top module"
$ ghdl --gen-makefile --std=08 --workdir=work -Plib "top module" > Makefile
$ make run -GHDLRUNFLAGS="--stop-time=200ns --vcd=./etc/waveform.vcd"
$ gtkwave ./etc/waveform.vcd &

The -i option scan, parse and add the files to the library without analyzing
The -m option analyze and compile the design for simulation
