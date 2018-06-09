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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typedefs.all;

---------------------------------------------------------------------------
entity rom_tb is
end entity;

---------------------------------------------------------------------------
architecture arch of rom_tb is

    signal addr : std_logic_vector(9 downto 0) := (others => '0');
    signal data : std_logic_vector(15 downto 0) := (others => '0');

begin

    uut : rom
    generic map (
        DATA_SIZE => 16,
        ADDR_SIZE => 10,
        MEM_SIZE => 1024
    )
    port map (
        addr => addr,
        data => data
    );

    stimulus : process

        procedure read_rom (read_addr : in integer;
                            expected_data : in std_logic_vector(15 downto 0)) is
        begin
            addr <= std_logic_vector(to_unsigned(read_addr, 10));
            wait for 10 ns;
            assert(expected_data = data) report "Wrong value!" severity error;
        end procedure;

    begin

        wait for 10 ns;
        read_rom(0, x"D307");
        read_rom(12, x"0806");
        read_rom(13, x"FFFF");
        read_rom(1023, x"FFFF");

    end process;

end architecture;
