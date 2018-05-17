---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 17/05/2018
-- File          : instruction_register.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity instruction_register is
    port (
        clk         : in std_logic;
        rst_n       : in std_logic;
        en          : in std_logic;
        romdata     : in std_logic_vector(15 downto 0);
        instruction : out std_logic_vector(15 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of instruction_register is

begin

    instruction_fetch : process (clk, rst_n) is
    begin
        if (rst_n = '0') then
            instruction <= "0000000000000000";
        elsif (rising_edge(clk)) then
            if (en = '1') then
                instruction <= romdata; -- fetch rom instruction
            end if;
        end if;
    end process;

end architecture;
