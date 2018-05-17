---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 18/04/2018
-- File          : mux2.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity mux2 is
    generic (
        LENGTH : integer := 8
    );
    port (
        ctrl : in std_logic;
        in1  : in std_logic_vector(LENGTH-1 downto 0);
        in2  : in std_logic_vector(LENGTH-1 downto 0);
        out1 : out std_logic_vector(LENGTH-1 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of mux2 is

begin

    with (ctrl) select
        out1 <= in1 when ('0'),
                in2 when ('1'),
                (others => '0') when others;

end architecture;
