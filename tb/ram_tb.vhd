---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 30/05/2018
-- File          : ram_tb.vhdl
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typedefs.all;

---------------------------------------------------------------------------
entity ram_tb is
end entity;

---------------------------------------------------------------------------
architecture arch of ram_tb is

    component clk_gen is
    port (
        clk : out std_logic
     );
    end component;

    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '1';
    signal rw       : std_logic := '0'; -- write enable
    signal addr     : std_logic_vector(7 downto 0) := (others => '0');
    signal datain   : std_logic_vector(7 downto 0) := (others => '0');
    signal dataout  : std_logic_vector(7 downto 0) := (others => '0');
    signal ramdebug : bytearray_t(255 downto 0) := (others => (others => '0'));

begin

    clk_inst : clk_gen
    port map (
        clk => clk
    );

    uut : ram
    port map (
        clk      => clk,
        rst_n    => rst_n,
        rw       => rw,
        addr     => addr,
        datain   => datain,
        dataout  => dataout,
        ramdebug => ramdebug
    );

    stimulus : process

        procedure write_ram (pos   : in std_logic_vector(7 downto 0);
                             value : in std_logic_vector(7 downto 0)) is
        begin
            addr <= pos;
            datain <= value;
            rw <= '1';
            wait for 10 ns;
        end procedure;

        procedure check_ram (pos   : in std_logic_vector(7 downto 0);
                             value : in std_logic_vector(7 downto 0)) is
        begin
            addr <= pos;
            rw <= '0';
            wait for 10 ns;
            assert (value = dataout) report "Wrong Value!" severity error;
        end procedure;

    begin

        write_ram(x"00", x"FA"); -- 0 ns
        write_ram(x"55", x"55"); -- 10 ns
        write_ram(x"FF", x"AF"); -- 20 ns

        check_ram(x"00", x"FA"); -- 30 ns
        check_ram(x"55", x"55"); -- 40 ns
        check_ram(x"FF", x"AF"); -- 50 ns

        write_ram(x"FF", x"AA"); -- 60 ns
        write_ram(x"00", x"FA"); -- 70 ns
        write_ram(x"55", x"AA"); -- 80 ns

        check_ram(x"FF", x"AA"); -- 90 ns
        check_ram(x"00", x"FA"); -- 100 ns
        check_ram(x"55", x"AA"); -- 110 ns

    end process;

end architecture;
