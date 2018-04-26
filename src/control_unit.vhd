---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 26/04/2018
-- File          : control_unit.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

---------------------------------------------------------------------------
entity control_unit is
    port (
        clk         : in std_logic;
        rst_n       : in std_logic;
        romdata     : in std_logic_vector(15 downto 0);
        romctrl     : out std_logic_vector(1 downto 0);
        ramrw       : out std_logic;
        regrw       : out std_logic;
        pcctrl      : out std_logic_vector(2 downto 0);
        flagsctrl   : out std_logic;
        aluctrl     : out std_logic_vector(3 downto 0);
        aluoctrl    : out std_logic_vector(2 downto 0);
        aludctrl    : out std_logic;
        instruction : out std_logic_vector(15 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of control_unit is

    -- opcodes
    constant JMP  : std_logic_vector(3 downto 0) := "0000";
    constant ADD  : std_logic_vector(3 downto 0) := "1000";
    constant MOV  : std_logic_vector(3 downto 0) := "1101";

    -- control unit state machine
    type state_t is (RESET, FETCH_1, FETCH_2, DECODE, MOV_1, MOV_2, MOV_3, ADD_1, ADD_2, ADD_3, JMP_1, JMP_2, HALT);
    signal state : state_t := RESET;
    signal next_state : state_t := RESET;

    -- control signals
    signal w_romctrl   : std_logic_vector(1 downto 0) := "00";
    signal w_ramrw     : std_logic := '0'; -- RAM R/W flag
    signal w_regrw     : std_logic := '0'; -- registers R/W flag
    signal w_pcctrl    : std_logic_vector(2 downto 0) := "000";
    signal w_flagsctrl : std_logic := '0';
    signal w_aluctrl   : std_logic_vector(3 downto 0) := (others => '0');
    signal w_aluoctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal w_aludctrl  : std_logic := '0';

    -- instruction registers
    signal w_instruction : std_logic_vector(15 downto 0) := (others => '0');

    -- instruction decode
    alias opcode      : std_logic_vector(3 downto 0) is w_instruction(15 downto 12); -- opcode

    -- the below definitions are for instructions of type MOV, ADD
    alias addrmoded   : std_logic_vector(1 downto 0) is w_instruction(11 downto 10); -- addrmode of dest
    alias addrmodeo   : std_logic_vector(1 downto 0) is w_instruction(9 downto 8);   -- addrmode of orig

    alias dest    : std_logic_vector(3 downto 0) is w_instruction(7 downto 4);   -- destination
    alias orig    : std_logic_vector(3 downto 0) is w_instruction(3 downto 0);   -- origin

    alias immed   : std_logic_vector(7 downto 0) is w_instruction(7 downto 0);
    alias memaddr : std_logic_vector(7 downto 0) is w_instruction(7 downto 0);

begin

    romctrl   <= w_romctrl;
    ramrw     <= w_ramrw;
    regrw     <= w_regrw;
    pcctrl    <= w_pcctrl;
    flagsctrl <= w_flagsctrl;
    aluctrl   <= w_aluctrl;
    aluoctrl  <= w_aluoctrl;
    aludctrl  <= w_aludctrl;

    instruction <= w_instruction;

    -- transition of state machine is synchronous
    sm_sequential : process (clk) is
    begin
        if (rst_n = '0') then
            state <= RESET;
        elsif (rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    sm_combinational : process (state) is
        variable L : line;
    begin
        case (state) is
            when RESET =>

                -- output function
                -- TODO: reset ram, registers and control flags

                -- transition logic
                next_state <= FETCH_1;

            when FETCH_1 =>

                -- output function
                w_romctrl <= "00";           -- set rom input addr
                w_pcctrl <= "001";           -- start pc increment

                -- transition logic
                next_state <= FETCH_2;

            when FETCH_2 =>

                -- output function
                w_instruction <= romdata;    -- fetch rom instruction
                w_pcctrl <= "000";           -- stop pc increment

                -- transition logic
                next_state <= DECODE;

            when DECODE =>

                --write(L, to_hstring(w_instruction));
                --writeline(output, L);

                -- transition logic
                case (opcode) is
                    when MOV => next_state <= MOV_1;
                    when ADD => next_state <= ADD_1;
                    when JMP => next_state <= JMP_1;
                    when others => next_state <= HALT;
                end case;

            when MOV_1 =>

                -- output function
                w_aluoctrl <= "100";
                w_aluctrl  <= "0000";

                -- transition logic
                next_state <= MOV_2;

            when MOV_2 =>

                -- output function
                w_regrw <= '1';

                -- transition logic
                next_state <= MOV_3;

            when MOV_3 =>

                -- output function
                w_regrw <= '0';

                -- transition logic
                next_state <= FETCH_1;

            when ADD_1 =>

                -- output function
                w_aluoctrl <= "100";
                w_aludctrl <= '1';
                w_aluctrl  <= "0001";

                -- transition logic
                next_state <= ADD_2;

            when ADD_2 =>

                -- output function
                w_regrw <= '1';    -- set registers to write

                -- transition logic
                next_state <= ADD_3;

            when ADD_3 =>

                -- output function
                w_regrw <= '0';      -- set registers back to read mode

                -- transition logic
                next_state <= FETCH_1;

            when JMP_1 =>

                -- output function
                w_pcctrl <= "101";   -- set pc to 10 bit value

                -- transition logic
                next_state <= JMP_2;

            when JMP_2 =>

                -- output function
                w_romctrl <= "00";   -- send pc to rom

                -- transition logic
                next_state <= FETCH_1;

            when HALT =>
                next_state <= RESET;
            when others =>
                next_state <= RESET;
        end case;
    end process;

end architecture;
