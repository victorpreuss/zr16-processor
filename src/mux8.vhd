---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 18/04/2018
-- File          : mux8.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity mux8 is
    generic (
        LENGTH : integer := 8
    );
    port (
        ctrl : in std_logic_vector(2 downto 0);
        in1  : in std_logic_vector(LENGTH-1 downto 0);
        in2  : in std_logic_vector(LENGTH-1 downto 0);
        in3  : in std_logic_vector(LENGTH-1 downto 0);
        in4  : in std_logic_vector(LENGTH-1 downto 0);
        in5  : in std_logic_vector(LENGTH-1 downto 0);
        in6  : in std_logic_vector(LENGTH-1 downto 0);
        in7  : in std_logic_vector(LENGTH-1 downto 0);
        in8  : in std_logic_vector(LENGTH-1 downto 0);
        out1 : out std_logic_vector(LENGTH-1 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of mux8 is

begin

    with (ctrl) select
        out1 <= in1 when ("000"),
                in2 when ("001"),
                in3 when ("010"),
                in4 when ("011"),
                in5 when ("100"),
                in6 when ("101"),
                in7 when ("110"),
                in8 when ("111"),
                (others => '0') when others;

end architecture;
