---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 12/04/2018
-- File          : clk_gen.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity clk_gen is
    port (
        clk : out std_logic
    );
end entity;

architecture arch of clk_gen is

    constant clk_period : time := 10 ns;

    begin

        clk_process : process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
                                                                
end architecture;

