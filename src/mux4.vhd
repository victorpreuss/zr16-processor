---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 14/04/2018
-- File          : mux4.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity mux4 is 
    generic (
        LENGTH : integer
    );
    port (
        ctrl : in std_logic_vector(1 downto 0);
        in1  : in std_logic_vector(LENGTH-1 downto 0);
        in2  : in std_logic_vector(LENGTH-1 downto 0);
        in3  : in std_logic_vector(LENGTH-1 downto 0);
        in4  : in std_logic_vector(LENGTH-1 downto 0);
        out1 : out std_logic_vector(LENGTH-1 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of mux4 is

begin
    
    with (ctrl) select
        out1 <= in1 when ("00"),
                in2 when ("01"),
                in3 when ("10"),
                in4 when ("11"),
                (others => '0') when others;

end architecture;

