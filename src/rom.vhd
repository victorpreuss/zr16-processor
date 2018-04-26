---------------------------------------------------------------------------
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
use std.textio.all;

---------------------------------------------------------------------------
entity rom is
    generic (
        DATA_SIZE   : integer := 16; -- size of an addressable data
        ADDR_SIZE   : integer := 10; -- number of bits of and address
        MEM_SIZE    : integer := 1024 -- memory size
    );
    port (
        clk     : in std_logic;
        addr    : in std_logic_vector(ADDR_SIZE-1 downto 0);
        data    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;


---------------------------------------------------------------------------
architecture arch of rom is

    subtype word_t is std_logic_vector(DATA_SIZE-1 downto 0);
    type memory_t is array(0 to MEM_SIZE-1) of word_t;

    impure function init_rom  (file_name : in string) return memory_t is

        file rom_file       : text;
        variable file_line  : line;
        variable mem        : memory_t;

    begin
        file_open(rom_file, file_name, READ_MODE);
        for i in memory_t'range loop
            readline(rom_file, file_line);
            read(file_line, mem(i));
        end loop;
        file_close(rom_file);
        return mem;

    end function;

    signal addr_reg : integer := 0;
    signal rom_data : memory_t := init_rom("./etc/code/test.zr16.stringbin");

begin

    process (clk) is
    begin
        if (rising_edge(clk)) then
            addr_reg <= to_integer(unsigned(addr));
        end if;
    end process;

    data <= rom_data(addr_reg);

end architecture;
