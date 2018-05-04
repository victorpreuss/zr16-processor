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
            --x"D307", -- this adds 7 every loop iteration
            --x"D010",
            --x"D021",
            --x"D032",
            --x"D331",
            --x"D040",
            --x"8043",
            --x"D301",
            --x"140C",
            --x"D043",
            --x"D034",
            --x"D043",
            --x"0806",
            x"D309", -- this is the bubble sort
            x"D802",
            x"D303",
            x"D803",
            x"D306",
            x"D804",
            x"D302",
            x"D805",
            x"D308",
            x"D806",
            x"D301",
            x"D807",
            x"D304",
            x"D808",
            x"D305",
            x"D809",
            x"D300",
            x"D80A",
            x"D300",
            x"D80B",
            x"D300",
            x"D80C",
            x"D300",
            x"D80A",
            x"D20A",
            x"D010",
            x"D308",
            x"7001",
            x"1038",
            x"D20A",
            x"D010",
            x"D301",
            x"9010",
            x"D001",
            x"D80B",
            x"D20B",
            x"D010",
            x"D3FF",
            x"7001",
            x"1036",
            x"D20B",
            x"8302",
            x"D110",
            x"8301",
            x"D120",
            x"7012",
            x"1834",
            x"D20B",
            x"8302",
            x"D402",
            x"8301",
            x"D401",
            x"F90B",
            x"0823",
            x"F80A",
            x"0818",
            x"0839",
            x"0839",
            others => x"FFFF"
    );

begin

    addri <= to_integer(unsigned(addr));
    data <= rom_data(addri);

end architecture;
