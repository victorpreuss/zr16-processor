---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 18/04/2018
-- File          : alu.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity alu is 
    port (
        ctrl : in std_logic_vector(2 downto 0);
        in1  : in std_logic_vector(7 downto 0);
        in2  : in std_logic_vector(7 downto 0);
        out1 : out std_logic_vector(7 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of alu is

begin

end architecture;

