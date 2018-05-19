def generate_rom_vhdl(rom_data):

    vhdl = """---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 12/04/2018
-- File          : rom.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity rom is
    generic (
        DATA_SIZE   : integer := 16; -- size of an addressable data
        ADDR_SIZE   : integer := 10; -- number of bits of and address
        MEM_SIZE    : integer := 1024 -- memory size
    );
    port (
        addr    : in std_logic_vector(ADDR_SIZE-1 downto 0);
        data    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of rom is

    subtype word_t is std_logic_vector(DATA_SIZE-1 downto 0);
    type memory_t is array(0 to MEM_SIZE-1) of word_t;

    --signal addr_reg : integer := 0;
    signal addri : integer := 0;
    constant rom_data : memory_t := (
"""

    i = 0
    for line in rom_data:
        half_word = line[0:4]
        vhdl += "\t\t\t\tx\"" + half_word
        if i == 1023:
            vhdl += "\");\n"
        else:
            vhdl += "\",\n"
        i += 1

    vhdl += """
begin

    addri <= to_integer(unsigned(addr));
    data <= rom_data(addri);

end architecture;"""

    # overwrite rom.vhd file with new binary
    f = open('../src/rom.vhd', 'w')
    f.write(vhdl)
    f.close()
