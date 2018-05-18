---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 18/04/2018
-- File          : alu.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

---------------------------------------------------------------------------
entity alu is
    port (
        op      : in std_logic_vector(3 downto 0); -- operation / ctrl signal
        Cin     : in std_logic;
        uc      : in std_logic;
        ed      : in std_logic;
        in1     : in std_logic_vector(7 downto 0);
        in2     : in std_logic_vector(7 downto 0);
        out1    : out std_logic_vector(7 downto 0);
        Z       : out std_logic;
        Cout    : out std_logic;
        V_P     : out std_logic
    );
end entity;

---------------------------------------------------------------------------
architecture arch of alu is

    --signal evenpar : std_logic := '0';

    signal w_out1 : std_logic_vector(7 downto 0) := (others => '0');
    signal w_Z    : std_logic := '0';
    signal w_Cout : std_logic := '0';
    signal w_V_P  : std_logic := '0';

begin

    process (op, in1, in2, Cin, uc, ed)

        variable resp : unsigned(7 downto 0) := (others => '0');

        variable C0 : std_logic := '0';
        variable C1 : std_logic := '0';
        variable C2 : std_logic := '0';
        variable C3 : std_logic := '0';
        variable C4 : std_logic := '0';
        variable C5 : std_logic := '0';
        variable C6 : std_logic := '0';
        variable C7 : std_logic := '0';
        variable C8 : std_logic := '0';

        variable L : line;

    begin

        case (op) is

            when "0000" => -- ALU becomes a wire

                resp := (others => '0');

                w_Cout <= '0';
                w_V_P  <= '0';
                w_out1 <= in1;

            when "0001" => -- SUM

                if (uc = '1' and Cin = '1') then
                    resp := unsigned(in1) + unsigned(in2) + 1;
                else
                    resp := unsigned(in1) + unsigned(in2);
                end if;

                C0 := Cin when uc = '1' else '0';
                C1 := (in1(0) and in2(0)) or (in1(0) and C0) or (in2(0) and C0);
                C2 := (in1(1) and in2(1)) or (in1(1) and C1) or (in2(1) and C1);
                C3 := (in1(2) and in2(2)) or (in1(2) and C2) or (in2(2) and C2);
                C4 := (in1(3) and in2(3)) or (in1(3) and C3) or (in2(3) and C3);
                C5 := (in1(4) and in2(4)) or (in1(4) and C4) or (in2(4) and C4);
                C6 := (in1(5) and in2(5)) or (in1(5) and C5) or (in2(5) and C5);
                C7 := (in1(6) and in2(6)) or (in1(6) and C6) or (in2(6) and C6);
                C8 := (in1(7) and in2(7)) or (in1(7) and C7) or (in2(7) and C7);

                w_Cout <= C8;
                w_V_P  <= C8 xor C7;
                w_out1 <= std_logic_vector(resp);

            when "0010" => -- SUBTRACTION or CMP

                if (uc = '1' and Cin = '1') then
                    resp := unsigned(in2) - unsigned(in1) - 1;
                else
                    resp := unsigned(in2) - unsigned(in1);
                end if;

                C0 := Cin when uc = '1' else '0';
                C1 := (in1(0) and not in2(0)) or (not in2(0) and C0) or (in1(0) and C0);
                C2 := (in1(1) and not in2(1)) or (not in2(1) and C1) or (in1(1) and C1);
                C3 := (in1(2) and not in2(2)) or (not in2(2) and C2) or (in1(2) and C2);
                C4 := (in1(3) and not in2(3)) or (not in2(3) and C3) or (in1(3) and C3);
                C5 := (in1(4) and not in2(4)) or (not in2(4) and C4) or (in1(4) and C4);
                C6 := (in1(5) and not in2(5)) or (not in2(5) and C5) or (in1(5) and C5);
                C7 := (in1(6) and not in2(6)) or (not in2(6) and C6) or (in1(6) and C6);
                C8 := (in1(7) and not in2(7)) or (not in2(7) and C7) or (in1(7) and C7);

                w_Cout <= C8;
                w_V_P  <= C8 xor C7;
                w_out1 <= std_logic_vector(resp);

            when "0100" => -- INC

                resp := unsigned(in2) + 1;

                w_Cout <= '0';
                w_V_P  <= '0';
                w_out1 <= std_logic_vector(resp);

            when "1000" => -- DEC

                resp := unsigned(in2) - 1;

                w_Cout <= '0';
                w_V_P  <= '0';
                w_out1 <= std_logic_vector(resp);

            when others =>

                resp := (others => '0');

                w_Cout  <= '0';
                w_V_P   <= '0';
                w_out1  <= (others => '0');

        end case;

        if (resp(7 downto 0) = "00000000") then
            w_Z <= '1';
        else
            w_Z <= '0';
        end if;

    end process;

    -- calculate even parity
    --evenpar <= resp(0) xor resp(1) xor resp(2) xor resp(3) xor
    --           resp(4) xor resp(5) xor resp(6) xor resp(7);

    -- set output flags
    Z     <= w_Z;
    Cout  <= w_Cout;
    V_P   <= w_V_P;

    -- set alu output
    out1  <= w_out1;

end architecture;
