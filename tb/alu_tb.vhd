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

    stimulus : process

        procedure int_to_slv (A : in integer;
                              B : out std_logic_vector(7 downto 0)) is
        begin
            if (A < 0) then
                B := std_logic_vector(to_signed(A, B'length));
            else
                B := std_logic_vector(to_unsigned(A, B'length));
            end if;
        end procedure;

        procedure check_result (exp_result : integer;
                                exp_Z, exp_C, exp_V_P : std_logic) is
            variable result : std_logic_vector(7 downto 0);
        begin
            int_to_slv(exp_result, result);
            assert (result = out1) report "Wrong Result!"        severity error;
            assert (exp_Z = Z)     report "Flag Zero is wrong!"  severity error;
            assert (exp_C = Cout)  report "Flag Carry is wrong!" severity error;
            assert (exp_V_P = V_P) report "Flag VP is wrong!"    severity error;
        end procedure;

        procedure op_without_carry (op0 : in aluop_t;
                                    op1 : in integer;
                                    op2 : in integer) is
            variable op1_slv : std_logic_vector(7 downto 0);
            variable op2_slv : std_logic_vector(7 downto 0);
        begin
            int_to_slv(op1, op1_slv);
            int_to_slv(op2, op2_slv);
            op <= op0;
            Cin <= '0';
            uc <= '0';
            in1 <= op1_slv;
            in2 <= op2_slv;
            wait for 10 ns;
        end procedure;

        procedure op_with_carry (op0 : in aluop_t;
                                 op1 : in integer;
                                 op2 : in integer) is
            variable op1_slv : std_logic_vector(7 downto 0);
            variable op2_slv : std_logic_vector(7 downto 0);
        begin
            int_to_slv(op1, op1_slv);
            int_to_slv(op2, op2_slv);
            op <= op0;
            Cin <= '1';
            uc <= '1';
            in1 <= op1_slv;
            in2 <= op2_slv;
            wait for 10 ns;
        end procedure;

    begin

        -- WIRE tests

        op <= ALU_WIRE;

        in1 <= "01010101";
        in2 <= "10101010";
        wait for 10 ns; -- 0ns
        check_result(2#01010101#, '0', '0', '0');

        in1 <= "00000000";
        in2 <= "11111111";
        wait for 10 ns; -- 10ns
        check_result(2#00000000#, '1', '0', '0');

        -- ADD tests

        -- 1: overflow (sets VP flag)
        op_without_carry(ALU_ADD, 100, 28); -- 20ns // simulation time to check
        check_result(-128, '0', '0', '1');

        -- 2: simple sum
        op_without_carry(ALU_ADD, 100, 27); -- 30ns
        check_result(127, '0', '0', '0');

        -- 3: overflow using carry in (sets VP flag)
        op_with_carry(ALU_ADD, 100, 27); -- 40ns
        check_result(-128, '0', '0', '1');

        -- 4: sum of two negative numbers generating underflow and carry
        op_without_carry(ALU_ADD, -1, -128); -- 50ns
        check_result(127, '0', '1', '1');

        -- 5: sum of two negative numbers generating carry
        op_without_carry(ALU_ADD, -50, -50); -- 60ns
        check_result(-100, '0', '1', '0');

        -- SUB tests

        -- 1: simple subtraction (in2 > in1)
        op_without_carry(ALU_SUB, 18, 95); -- 70ns
        check_result(77, '0', '0', '0');

        -- 2: subtraction with negative result (sets borrow/carry)
        op_without_carry(ALU_SUB, 95, 18); -- 80ns
        check_result(-77, '0', '1', '0');

        -- 3: subtraction of negative and positive
        op_without_carry(ALU_SUB, 27, -101); -- 90ns
        check_result(-128, '0', '0', '0');

        -- 4: subtraction of negative and positive with carry (sets VP)
        op_with_carry(ALU_SUB, 27, -101); -- 100ns
        check_result(127, '0', '0', '1');

        -- 5: subtraction of positive and negative (sets VP and borrow/carry)
        op_without_carry(ALU_SUB, -28, 100); -- 110ns
        check_result(128, '0', '1', '1');

        -- 6: subtraction result is zero
        op_without_carry(ALU_SUB, -101, -101); -- 120ns
        check_result(0, '1', '0', '0');

        -- INC tests (with carry because carry shouldn't interfere)

        -- 1: increment simple positive
        op_with_carry(ALU_INC, 0, 100); -- 130ns
        check_result(101, '0', '0', '0');

        -- 2: increment simple negative
        op_with_carry(ALU_INC, 0, -100); -- 140ns
        check_result(-99, '0', '0', '0');

        -- 3: increment positive at boundary (shoudn't set carry flag)
        op_with_carry(ALU_INC, 0, 255); -- 150ns
        check_result(0, '1', '0', '0');

        -- 4: increment positive that should generate VP (shoudn't set VP flag)
        op_with_carry(ALU_INC, 0, 127); -- 160ns
        check_result(128, '0', '0', '0');

        -- DEC tests

        -- 1: decrement simple positive
        op_without_carry(ALU_DEC, 0, 100); -- 170ns
        check_result(99, '0', '0', '0');

        -- 2: decrement simple negative
        op_without_carry(ALU_DEC, 0, -100); -- 180ns
        check_result(-101, '0', '0', '0');

        -- 3: decrement zero (shoudn't set carry/borrow flag)
        op_without_carry(ALU_DEC, 0, 0); -- 190ns
        check_result(-1, '0', '0', '0');

        -- 4: decrement negative that should generate VP (shoudn't set VP flag)
        op_without_carry(ALU_DEC, 0, -128); -- 200ns
        check_result(127, '0', '0', '0');

        -- 5: decrement to generate zero flag
        op_without_carry(ALU_DEC, 0, 1); -- 210ns
        check_result(0, '1', '0', '0');

        -- AND tests

        -- 1: simple test with even parity and zero result
        op_without_carry(ALU_AND, 2#10101010#, 2#01010101#); -- 220ns
        check_result(2#00000000#, '1', '0', '1');

        -- 2: simple test with even parity
        op_without_carry(ALU_AND, 2#10101010#, 2#11110000#); -- 230ns
        check_result(2#10100000#, '0', '0', '1');

        -- 3: simple test with odd parity
        op_without_carry(ALU_AND, 2#10101010#, 2#11111000#); -- 240ns
        check_result(2#10101000#, '0', '0', '0');

        -- 4: simple test with odd parity
        op_without_carry(ALU_AND, 2#11111111#, 2#00011111#); -- 250ns
        check_result(2#00011111#, '0', '0', '0');

        -- OR tests

        -- 1: simple test with even parity and FF result
        op_without_carry(ALU_OR, 2#10101010#, 2#01010101#); -- 260ns
        check_result(2#11111111#, '0', '0', '1');

        -- 2: simple test with even parity
        op_without_carry(ALU_OR, 2#10101010#, 2#11110000#); -- 270ns
        check_result(2#11111010#, '0', '0', '1');

        -- 3: simple test with odd parity
        op_without_carry(ALU_OR, 2#10101010#, 2#10111000#); -- 280ns
        check_result(2#10111010#, '0', '0', '0');

        -- 4: simple test with odd parity
        op_without_carry(ALU_OR, 2#00000000#, 2#00000001#); -- 290ns
        check_result(2#00000001#, '0', '0', '0');

        -- XOR tests

        -- 1: simple test with even parity and FF result
        op_without_carry(ALU_XOR, 2#10101010#, 2#01010101#); -- 300ns
        check_result(2#11111111#, '0', '0', '1');

        -- 2: simple test with even parity
        op_without_carry(ALU_XOR, 2#10101010#, 2#11110000#); -- 310ns
        check_result(2#01011010#, '0', '0', '1');

        -- 3: simple test with odd parity
        op_without_carry(ALU_XOR, 2#00101010#, 2#10111000#); -- 320ns
        check_result(2#10010010#, '0', '0', '0');

        -- 4: simple test with odd parity
        op_without_carry(ALU_XOR, 2#11111110#, 2#11111111#); -- 330ns
        check_result(2#00000001#, '0', '0', '0');

        -- ROT tests

        -- 1:
        ed <= '0';
        op_without_carry(ALU_ROT, 2#10101010#, 0); -- 340ns
        check_result(2#01010101#, '0', '0', '0');

        -- 2:
        ed <= '0';
        op_without_carry(ALU_ROT, 2#10101011#, 0); -- 350ns
        check_result(2#11010101#, '0', '1', '0');

        -- 3:
        ed <= '1';
        op_without_carry(ALU_ROT, 2#00101010#, 0); -- 360ns
        check_result(2#01010100#, '0', '0', '0');

        -- 4:
        ed <= '1';
        op_without_carry(ALU_ROT, 2#10101010#, 0); -- 370ns
        check_result(2#01010101#, '0', '1', '0');

        -- 5:
        ed <= '0';
        op_with_carry(ALU_ROT, 2#10101010#, 0); -- 380ns
        check_result(2#11010101#, '0', '0', '0');

        -- 6:
        ed <= '0';
        op_with_carry(ALU_ROT, 2#10101011#, 0); -- 390ns
        check_result(2#11010101#, '0', '1', '0');

        -- 7:
        ed <= '1';
        op_with_carry(ALU_ROT, 2#00101010#, 0); -- 400ns
        check_result(2#01010101#, '0', '0', '0');

        -- 8:
        ed <= '1';
        op_with_carry(ALU_ROT, 2#10101010#, 0); -- 410ns
        check_result(2#01010101#, '0', '1', '0');

        -- SHL tests

        -- 1:
        ed <= '0';
        op_without_carry(ALU_SHL, 2#10101010#, 0); -- 420ns
        check_result(2#01010101#, '0', '0', '0');

        -- 2:
        ed <= '0';
        op_without_carry(ALU_SHL, 2#10101011#, 0); -- 430ns
        check_result(2#01010101#, '0', '1', '0');

        -- 3:
        ed <= '1';
        op_without_carry(ALU_SHL, 2#01101010#, 0); -- 440ns
        check_result(2#11010100#, '0', '0', '0');

        -- 4:
        ed <= '1';
        op_without_carry(ALU_SHL, 2#11101010#, 0); -- 450ns
        check_result(2#11010100#, '0', '1', '0');

        -- SHA tests

        -- missing SHA tests

    end process;

end architecture;
