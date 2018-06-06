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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typedefs.all;

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

    signal clk     : std_logic := '0';
    signal rst_n   : std_logic := '1';
    signal rw      : std_logic := '0';
    signal addro   : std_logic_vector(1 downto 0) := (others => '0');
    signal pcctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal in1     : std_logic_vector(3 downto 0) := (others => '0');
    signal in2     : std_logic_vector(3 downto 0) := (others => '0');
    signal alu     : std_logic_vector(7 downto 0) := (others => '0');
    signal flags   : std_logic_vector(2 downto 0) := (others => '0');
    signal flctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal ro      : std_logic_vector(7 downto 0) := (others => '0');
    signal rd      : std_logic_vector(7 downto 0) := (others => '0');
    signal r13     : std_logic_vector(7 downto 0) := (others => '0');
    signal r14     : std_logic_vector(7 downto 0) := (others => '0');
    signal r15     : std_logic_vector(7 downto 0) := (others => '0');
    signal pc      : std_logic_vector(9 downto 0) := (others => '0');

    signal regdebug  : bytearray_t(15 downto 0);

begin

    clk_inst : clk_gen
    port map (
        clk => clk
    );

    uut : register_file
    port map (
        clk      => clk,
        rst_n    => rst_n,
        rw       => rw,
        addro    => addro,
        pcctrl   => pcctrl,
        in1      => in1,
        in2      => in2,
        alu      => alu,
        flags    => flags,
        flctrl   => flctrl,
        ro       => ro,
        rd       => rd,
        r13      => r13,
        r14      => r14,
        r15      => r15,
        pc       => pc,
        regdebug => regdebug
    );


    simulus : process

        procedure write_reg (reg, value : in integer) is
        begin
            rw <= '1';
            in2  <= std_logic_vector(to_unsigned(reg, in2'length));
            alu  <= std_logic_vector(to_unsigned(value, alu'length));
            wait for 10 ns;
            rw <= '0';
        end procedure;

        procedure check_reg (reg, value : in integer) is
            variable result : std_logic_vector(7 downto 0);
        begin
            in1  <= std_logic_vector(to_unsigned(reg, in1'length));
            in2  <= std_logic_vector(to_unsigned(reg, in2'length));
            wait for 1 ns;
            result := std_logic_vector(to_unsigned(value, ro'length));
            assert (result = ro) report "Wrong Value!" severity error;
            assert (result = rd) report "Wrong Value!" severity error;
        end procedure;

    begin

        write_reg(0, 75);
        write_reg(1, 14);
        write_reg(2, 47);
        write_reg(3, 3);
        write_reg(4, 127);
        write_reg(5, 234);
        write_reg(6, 1);
        write_reg(7, 195);
        write_reg(8, 32);
        write_reg(9, 98);
        write_reg(10, 200);
        write_reg(11, 150);
        write_reg(12, 65);
        write_reg(14, 12);  -- r14(3:2) = '11'
        write_reg(13, 100); -- r14(1:0) receives r14(3:2)
        write_reg(14, 128); -- r14(1:0) are set and can't be overwritten
        write_reg(15, 209);

        check_reg(0, 75);
        check_reg(1, 14);
        check_reg(2, 47);
        check_reg(3, 3);
        check_reg(4, 127);
        check_reg(5, 234);
        check_reg(6, 1);
        check_reg(7, 195);
        check_reg(8, 32);
        check_reg(9, 98);
        check_reg(10, 200);
        check_reg(11, 150);
        check_reg(12, 65);
        check_reg(13, 100);
        check_reg(14, 131);
        check_reg(15, 209);

        -- a couple of different tests

        in1 <= "0000";
        in2 <= "0000";
        flags  <= "000";
        flctrl <= "100";
        wait for 10 ns;
        check_reg(15, 81); -- cleared most significant bit (Z flag)

        in1 <= "0000";
        in2 <= "0000";
        flags  <= "100";
        flctrl <= "100";
        wait for 10 ns;
        check_reg(15, 209); -- set most significant bit (Z flag)

        in1 <= "0000";
        in2 <= "0000";
        flags  <= "000";
        flctrl <= "110";
        wait for 10 ns;
        check_reg(15, 17); -- set most significant bit (Z flag)
        flags  <= "000";
        flctrl <= "000";

        pcctrl <= "001";
        wait for 10 ns;
        assert (std_logic_vector(to_unsigned(869, 10)) = pc)
        report "Wrong PC value!" severity error;
        wait for 10 ns;
        assert (std_logic_vector(to_unsigned(870, 10)) = pc)
        report "Wrong PC value!" severity error;
        pcctrl <= "000";
        wait for 10 ns;

    end process;

end architecture;
