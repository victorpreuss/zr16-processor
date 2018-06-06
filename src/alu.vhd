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
use work.typedefs.all;

---------------------------------------------------------------------------
entity alu is
    port (
        op      : in aluop_t; -- operation / ctrl signal
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

    signal w_out1 : std_logic_vector(7 downto 0) := (others => '0');
    signal w_Z    : std_logic := '0';
    signal w_Cout : std_logic := '0';
    signal w_V_P  : std_logic := '0';

begin

    process (op, in1, in2, Cin, uc, ed)

        variable resp   : unsigned(7 downto 0) := (others => '0');
        variable parity : std_logic := '0'; -- even parity

        variable C0 : std_logic := '0';
        variable C1 : std_logic := '0';
        variable C2 : std_logic := '0';
        variable C3 : std_logic := '0';
        variable C4 : std_logic := '0';
        variable C5 : std_logic := '0';
        variable C6 : std_logic := '0';
        variable C7 : std_logic := '0';
        variable C8 : std_logic := '0';

    begin

        case (op) is

            when ALU_WIRE => -- ALU becomes a wire

                resp := unsigned(in1);

                w_Cout <= '0';
                w_V_P  <= '0';

            when ALU_ADD =>

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

            when ALU_SUB =>

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

            when ALU_INC => -- INC

                resp := unsigned(in2) + 1;

                w_Cout <= '0';
                w_V_P  <= '0';

            when ALU_DEC => -- DEC

                resp := unsigned(in2) - 1;

                w_Cout <= '0';
                w_V_P  <= '0';

            when ALU_AND =>

                resp := unsigned(in1) and unsigned(in2);

                w_Cout <= '0';
                w_V_P  <= not (resp(0) xor resp(1) xor resp(2) xor resp(3) xor
                               resp(4) xor resp(5) xor resp(6) xor resp(7));

            when ALU_OR =>

                resp := unsigned(in1) or unsigned(in2);

                w_Cout <= '0';
                w_V_P  <= not (resp(0) xor resp(1) xor resp(2) xor resp(3) xor
                               resp(4) xor resp(5) xor resp(6) xor resp(7));

            when ALU_XOR =>

                resp := unsigned(in1) xor unsigned(in2);

                w_Cout <= '0';
                w_V_P  <= not (resp(0) xor resp(1) xor resp(2) xor resp(3) xor
                               resp(4) xor resp(5) xor resp(6) xor resp(7));

            when ALU_ROT =>

                if (ed = '0' and uc = '0') then
                    resp := unsigned(in1(0) & in1(7 downto 1));
                    w_Cout <= in1(0);
                elsif (ed = '0' and uc = '1') then
                    resp := unsigned(Cin & in1(7 downto 1));
                    w_Cout <= in1(0);
                elsif (ed = '1' and uc = '0') then
                    resp := unsigned(in1(6 downto 0) & in1(7));
                    w_Cout <= in1(7);
                else
                    resp := unsigned(in1(6 downto 0) & Cin);
                    w_Cout <= in1(7);
                end if;
                w_V_P  <= '0';

            when ALU_SHL =>

                if (ed = '0') then
                    resp := unsigned('0' & in1(7 downto 1));
                    w_Cout <= in1(0);
                else
                    resp := unsigned(in1(6 downto 0) & '0');
                    w_Cout <= in1(7);
                end if;
                w_V_P  <= '0';

            when ALU_SHA =>

                if (ed = '0') then
                    resp := unsigned(in1(7) & in1(7 downto 1));
                    w_Cout <= in1(0);
                    w_V_P  <= '0';
                else
                    resp := unsigned(in1(6 downto 0) & '0');
                    w_Cout <= in1(7);
                    w_V_P  <= in1(7) xor in1(6);
                end if;

            when others =>

                resp := (others => '0');

                w_Cout  <= '0';
                w_V_P   <= '0';

        end case;

        if (resp(7 downto 0) = "00000000") then
            w_Z <= '1';
        else
            w_Z <= '0';
        end if;

        w_out1 <= std_logic_vector(resp);

    end process;

    -- set output flags
    Z     <= w_Z;
    Cout  <= w_Cout;
    V_P   <= w_V_P;

    -- set alu output
    out1  <= w_out1;

end architecture;
