---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 12/04/2018
-- File          : fetch.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity fetch is 
    port (
        clk         : in std_logic;
        ctrl        : in std_logic_vector(1 downto 0); -- control flags
        pc          : in std_logic_vector(9 downto 0); -- pc register
        inst_addr   : in std_logic_vector(6 downto 0); -- in case of a MOV r0, (end)
        ro          : in std_logic_vector(6 downto 0); -- in case of a MOV rd, (ro)
        mem_p       : in std_logic_vector(2 downto 0); -- memory partition (rom is 8 blocks of 128x16)
        addr        : out std_logic_vector(9 downto 0); -- output address (the one fetched)
        data        : out std_logic_vector(15 downto 0) -- output data (can be an instruction or a readed byte)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of fetch is

    component rom is
    generic (
        DATA_SIZE : integer;
        ADDR_SIZE : integer;
        MEM_SIZE : integer
    );
    port (
        clk     : in std_logic;
        addr    : in std_logic_vector(ADDR_SIZE-1 downto 0);
        data    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
    end component;

begin

    rom_data : rom generic map(16, 10, 1024)
    port map (
        clk => clk,
        addr => addr,
        data => data
    );

    -- multiplexer to feed program ROM the correct address
    -- it can be an instruction adress from PC register, an
    -- immediate address encoded in the previous instructions
    -- or an address contained by a register
    addr <= pc when (ctrl = "01") else
            mem_p & inst_addr when (ctrl = "10") else
            mem_p & ro when (ctrl = "11") else
            (others => 'X');

end architecture;

