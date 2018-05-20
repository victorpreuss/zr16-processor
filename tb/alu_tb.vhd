---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 20/05/2018
-- File          : alu_tb.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typedefs.all;

---------------------------------------------------------------------------
entity alu_tb is
end entity;

---------------------------------------------------------------------------
architecture arch of alu_tb is

    signal op   : aluop_t := ALU_WIRE;
    signal Cin  : std_logic := '0';
    signal uc   : std_logic := '0';
    signal ed   : std_logic := '0';
    signal in1  : std_logic_vector(7 downto 0) := (others => '0');
    signal in2  : std_logic_vector(7 downto 0) := (others => '0');
    signal out1 : std_logic_vector(7 downto 0) := (others => '0');
    signal Z    : std_logic := '0';
    signal Cout : std_logic := '0';
    signal V_P  : std_logic := '0';

begin

    uut : alu
    port map (
        op   => op,
        Cin  => Cin,
        uc   => uc,
        ed   => ed,
        in1  => in1,
        in2  => in2,
        out1 => out1,
        Z    => Z,
        Cout => Cout,
        V_P  => V_P
    );

    stimuli : process

        procedure check_result (exp_result : integer;
                                exp_Z, exp_C, exp_V_P : std_logic) is
        begin
            assert(std_logic_vector(to_unsigned(exp_result, out1'length)) = out1) report "Wrong Result!" severity error;
            assert(exp_Z = Z) report "Flag Zero is wrong!" severity error;
            assert(exp_C = Cout) report "Flag Carry is wrong!" severity error;
            assert(exp_V_P = V_P) report "Flag VP is wrong!" severity error;
        end procedure;

        procedure add_without_carry (op1 : in integer;
                                     op2 : in integer) is
        begin
            op <= ALU_ADD;
            Cin <= '0';
            uc <= '1';
            ed <= '0';
            in1 <= std_logic_vector(to_unsigned(op1, in1'length));
            in2 <= std_logic_vector(to_unsigned(op2, in2'length));
            wait for 10 ns;
        end procedure;

        procedure add_with_carry (op1 : in integer;
                                  op2 : in integer) is
        begin
            op <= ALU_ADD;
            Cin <= '1';
            uc <= '1';
            ed <= '0';
            in1 <= std_logic_vector(to_unsigned(op1, in1'length));
            in2 <= std_logic_vector(to_unsigned(op2, in2'length));
            wait for 10 ns;
        end procedure;

    begin

        -- WIRE tests
        op <= ALU_WIRE;

        in1 <= "01010101";
        in2 <= "10101010";
        wait for 10 ns;

        in1 <= "00000000";
        in2 <= "11111111";
        wait for 10 ns;

        -- ADD tests

        -- 1: overflow (sets VP flag)
        add_without_carry(100, 28);
        check_result(128, '0', '0', '1');

        -- 2: simple sum
        add_without_carry(100, 27);
        check_result(127, '0', '0', '0');

        -- 3: overflow using carry in (sets VP flag)
        add_with_carry(100, 27);
        check_result(128, '0', '0', '1');

        -- 4: sum of two negative numbers generating underflow and carry
        add_without_carry(255, 128);
        check_result(127, '0', '1', '1');

    end process;

end architecture;
