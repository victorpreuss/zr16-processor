---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 27/04/2018
-- File          : ram.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity ram is
    port (
        clk      : in std_logic;
        rst_n    : in std_logic;
        rw       : in std_logic; -- write enable
        addr     : in std_logic_vector(7 downto 0);
        datain   : in std_logic_vector(7 downto 0);
        dataout  : out std_logic_vector(7 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of ram is

    subtype byte_t is std_logic_vector(7 downto 0);
    type ram_t is array(255 downto 0) of byte_t;

    signal ramdata : ram_t := (others => (others => '0'));
    signal addrreg : std_logic_vector(7 downto 0) := (others => '0');

begin

    process (clk, rst_n) is
    begin
        if (rst_n = '0') then
            ramdata <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            if (rw = '1') then
                ramdata(to_integer(unsigned(addr))) <= datain;
            end if;
            addrreg <= addr;
        end if;
    end process;

    dataout <= ramdata(to_integer(unsigned(addrreg)));

end architecture;
