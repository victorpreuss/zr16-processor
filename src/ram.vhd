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
use work.typedefs.all;

---------------------------------------------------------------------------
entity ram is
    port (
        clk      : in std_logic;
        rst_n    : in std_logic;
        rw       : in std_logic; -- write enable
        addr     : in std_logic_vector(7 downto 0);
        datain   : in std_logic_vector(7 downto 0);
        dataout  : out std_logic_vector(7 downto 0);
        ramdebug : out bytearray_t(255 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of ram is

    signal ramdata : bytearray_t(255 downto 0) := (others => (others => '0'));
    signal addrreg : std_logic_vector(7 downto 0) := (others => '0');

begin

    ramdebug <= ramdata;

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
