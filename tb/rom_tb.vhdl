---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 12/04/2018
-- File          : rom_tb.vhdl
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity rom_tb is 
end entity;

---------------------------------------------------------------------------
architecture arch of rom_tb is

    component clk_gen is
    port (
        clk : out std_logic
    );
    end component;

    component rom is
    generic (
        DATA_SIZE : integer;
        ADDR_SIZE : integer;
        MEM_SIZE  : integer
    );
    port (
        clk     : in std_logic;
        addr    : in std_logic_vector(addr_size-1 downto 0);
        data    : out std_logic_vector(data_size-1 downto 0)
    );
    end component;

    signal clk  : std_logic := '0';
    signal addr : std_logic_vector(9 downto 0) := (others => '0');
    signal data : std_logic_vector(15 downto 0) := (others => '0');

begin

    clk_inst : clk_gen
    port map (
        clk => clk
    );

    uut : rom
    generic map (
        DATA_SIZE => 16,
        ADDR_SIZE => 10,
        MEM_SIZE => 1024
    )
    port map (
        clk => clk,
        addr => addr,
        data => data
    );

    stimulus : process 

        procedure read_rom (read_addr : in integer; expected_data : in std_logic_vector(15 downto 0)) is
        begin
            addr <= std_logic_vector(to_unsigned(read_addr, 10));
            wait for 20 ns;
            assert(expected_data = data) report "Wrong value!" severity error;
        end procedure;

    begin

        wait for 10 ns;
        read_rom(0, "1101001101000000");
        read_rom(142, x"FFFF");
        read_rom(141, "0000100010001101");
        read_rom(1023, x"FFFF");

    end process;

end architecture;

