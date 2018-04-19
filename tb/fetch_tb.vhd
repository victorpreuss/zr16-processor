---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 12/04/2018
-- File          : fetch_tb.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity fetch_tb is 
end entity;

---------------------------------------------------------------------------
architecture arch of fetch_tb is
    
    component clk_gen is
    port (
        clk : out std_logic
    );
    end component;

    component fetch is 
    port (
        clk         : in std_logic;
        ctrl        : in std_logic_vector(1 downto 0);
        pc          : in std_logic_vector(9 downto 0);
        inst_addr   : in std_logic_vector(6 downto 0);
        ro          : in std_logic_vector(6 downto 0);
        mem_p       : in std_logic_vector(2 downto 0);
        addr        : out std_logic_vector(9 downto 0);
        data        : out std_logic_vector(15 downto 0)
    );
    end component;
    
    signal clk         : std_logic := '0';
    signal ctrl        : std_logic_vector(1 downto 0) := (others => '0');
    signal pc          : std_logic_vector(9 downto 0) := (others => '0');
    signal inst_addr   : std_logic_vector(6 downto 0) := (others => '0');
    signal ro          : std_logic_vector(6 downto 0) := (others => '0');
    signal mem_p       : std_logic_vector(2 downto 0) := (others => '0');
    signal addr        : std_logic_vector(9 downto 0) := (others => '0');
    signal data        : std_logic_vector(15 downto 0) := (others => '0');

begin
    
    clk_inst : clk_gen
    port map (
        clk => clk
    );

    uut : fetch
    port map (
        clk         => clk,
        ctrl        => ctrl,
        pc          => pc,
        inst_addr   => inst_addr,
        ro          => ro,
        mem_p       => mem_p,
        addr        => addr,
        data        => data
    );

    stimulus : process

    procedure test_fetch (control : in std_logic_vector(1 downto 0);
                          exp_addr : in std_logic_vector(9 downto 0);
                          exp_data : in std_logic_vector(15 downto 0)) is
        begin
            ctrl <= control;
            wait for 20 ns;
            assert(exp_addr = addr) report "Wrong address!" severity error;
            assert(exp_data = data) report "Wrong data!" severity error;
    end procedure;

    begin

        -- this test only works using ./etc/escmemprog1.strbin inside rom.vhd
        pc <= "0000011100";
        mem_p <= "001";
        inst_addr <= "0000101";
        ro <= "0000110";
        test_fetch("01", "0000011100", "0111000001000000"); -- data from position 28
        test_fetch("10", "0010000101", "1011000000000000"); -- data from position 133
        test_fetch("11", "0010000110", "1110000010000101"); -- data from position 134

    end process;

end architecture;

