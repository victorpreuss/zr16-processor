# Makefile automatically generated by ghdl
# Version: GHDL 0.36-dev (v0.35-44-g1199680) [Dunoon edition] - mcode code generator
# Command used to generate this makefile:
# ghdl --gen-makefile --std=08 --workdir=work -Plib top_level

GHDL=ghdl
GHDLFLAGS= --std=08 --workdir=work -Plib
GHDLRUNFLAGS=

# Default target : elaborate
all : elab

# Elaborate target.  Almost useless
elab : force
	$(GHDL) -c $(GHDLFLAGS) -e top_level

# Run target
run : force
	$(GHDL) -c $(GHDLFLAGS) -r top_level $(GHDLRUNFLAGS)

# Targets to analyze libraries
init: force
	# /usr/local/lib/ghdl/v08/std/../../src/std/textio.v08
	# /usr/local/lib/ghdl/v08/std/../../src/std/textio_body.v08
	# /usr/local/lib/ghdl/v08/ieee/../../src/ieee2008/std_logic_1164.vhdl
	# /usr/local/lib/ghdl/v08/ieee/../../src/ieee2008/std_logic_1164-body.vhdl
	# /usr/local/lib/ghdl/v08/ieee/../../src/ieee2008/numeric_std.vhdl
	# /usr/local/lib/ghdl/v08/ieee/../../src/ieee2008/numeric_std-body.vhdl
	$(GHDL) -a $(GHDLFLAGS) src/top_level.vhd
	$(GHDL) -a $(GHDLFLAGS) src/clk_gen.vhd
	$(GHDL) -a $(GHDLFLAGS) src/rom.vhd
	$(GHDL) -a $(GHDLFLAGS) src/mux4.vhd
	$(GHDL) -a $(GHDLFLAGS) src/register_file.vhd
	$(GHDL) -a $(GHDLFLAGS) src/mux8.vhd
	$(GHDL) -a $(GHDLFLAGS) src/mux2.vhd
	$(GHDL) -a $(GHDLFLAGS) src/alu.vhd
	$(GHDL) -a $(GHDLFLAGS) src/control_unit.vhd

force:
