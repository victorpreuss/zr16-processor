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

begin

    process (op, in1, in2, Cin, uc, ed)

    variable in1_ext : unsigned(8 downto 0) := (others => '0');
    variable in2_ext : unsigned(8 downto 0) := (others => '0');
    variable resp    : unsigned(8 downto 0) := (others => '0');

    variable w_out1 : std_logic_vector(7 downto 0) := (others => '0');
    variable w_Cout : std_logic := '0';
    variable w_V_P  : std_logic := '0';

    begin

        in1_ext := resize(unsigned(in1), 9);
        in2_ext := resize(unsigned(in2), 9);

        case (op) is

            when "0000" => -- SUM

                if (uc = '1' and Cin = '1') then
                    resp := in1_ext + in2_ext + 1;
                else
                    resp := in1_ext + in2_ext;
                end if;

                w_Cout  := std_logic(resp(8));
                w_V_P   := '0'; -- TODO: set VP value

                w_out1  := std_logic_vector(resp(7 downto 0));

            when others =>

                w_Cout  := '0';
                w_V_P   := '0';

                w_out1  := (others => '0');

        end case;

        -- set output flags
        Z     <= '1' when (resp = "000000000") else '0';
        Cout  <= w_Cout;
        V_P   <= w_V_P;

        -- set alu output
        out1  <= w_out1;

    end process;

    -- calculate even parity
    --evenpar <= resp(0) xor resp(1) xor resp(2) xor resp(3) xor
    --           resp(4) xor resp(5) xor resp(6) xor resp(7);


end architecture;
