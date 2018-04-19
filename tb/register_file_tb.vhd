---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 13/04/2018
-- File          : register_file_tb.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity register_file_tb is 
end entity;

---------------------------------------------------------------------------
architecture arch of register_file_tb is

    component clk_gen is
    port (
        clk : out std_logic
     );
    end component;

    component register_file is
    port (
        clk     : in std_logic;
        ctrl    : in std_logic_vector(1 downto 0);
        in1     : in std_logic_vector(3 downto 0);
        in2     : in std_logic_vector(3 downto 0);
        alu     : in std_logic_vector(7 downto 0);
        ro      : out std_logic_vector(7 downto 0);
        rd      : out std_logic_vector(7 downto 0);
        r13     : out std_logic_vector(7 downto 0);
        r14     : out std_logic_vector(7 downto 0);
        r15     : out std_logic_vector(7 downto 0);
        pc      : out std_logic_vector(9 downto 0)
    );
    end component;

    signal clk     : std_logic := '0';
    signal ctrl    : std_logic_vector(1 downto 0) := (others => '0');
    signal in1     : std_logic_vector(3 downto 0) := (others => '0');
    signal in2     : std_logic_vector(3 downto 0) := (others => '0');
    signal alu     : std_logic_vector(7 downto 0) := (others => '0');
    signal ro      : std_logic_vector(7 downto 0) := (others => '0');
    signal rd      : std_logic_vector(7 downto 0) := (others => '0');
    signal r13     : std_logic_vector(7 downto 0) := (others => '0');
    signal r14     : std_logic_vector(7 downto 0) := (others => '0');
    signal r15     : std_logic_vector(7 downto 0) := (others => '0');
    signal pc      : std_logic_vector(9 downto 0) := (others => '0');

begin
    
    clk_inst : clk_gen
    port map (
        clk => clk
    );

    uut : register_file
    port map (
        clk  => clk,
        ctrl => ctrl,
        in1  => in1,
        in2  => in2,
        alu  => alu,
        ro   => ro,
        rd   => rd,
        r13  => r13,
        r14  => r14,
        r15  => r15,
        pc   => pc
    );

    simulus : process

        procedure write_reg (reg, value : in integer) is
        begin
            ctrl <= "01";
            in2  <= std_logic_vector(to_unsigned(reg, 4));
            alu  <= std_logic_vector(to_unsigned(value, 8));
        end procedure;

    begin
 
        wait for 10 ns;
        write_reg(6, 75);
        wait for 10 ns;
        write_reg(11, 14);
        wait for 10 ns;
        write_reg(13, 47);
        wait for 10 ns;
        write_reg(14, 3);

    end process;

end architecture;

