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
    constant SUB  : std_logic_vector(3 downto 0) := "1001";
    constant MOV  : std_logic_vector(3 downto 0) := "1101";

    -- addressing modes
    constant REG       : std_logic_vector(1 downto 0) := "00";
    constant REG_ADDR  : std_logic_vector(1 downto 0) := "01";
    constant ADDR      : std_logic_vector(1 downto 0) := "10";
    constant IMMEDIATE : std_logic_vector(1 downto 0) := "11";

    -- control unit state machine
    type state_t is (RESET, FETCH, CONTROL_1, CONTROL_2, CONTROL_3, HALT);
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
        elsif (falling_edge(clk)) then
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
                next_state <= FETCH;

            when FETCH =>

                w_regrw <= '0';
                w_flagsctrl <= '0';

                w_romctrl <= "00";           -- set rom input addr
                w_pcctrl <= "000";           -- stop pc

                w_instruction <= romdata;    -- fetch rom instruction

                -- transition logic
                next_state <= CONTROL_1;

            when CONTROL_1 =>

                -- set ALU control
                case (opcode) is
                    when MOV =>
                        w_aluctrl <= "0000";
                    when ADD =>
                        w_aluctrl <= "0001";
                    when SUB =>
                        w_aluctrl <= "0010";
                    when others => w_aluctrl <= "0000";
                end case;

                -- addressing modes
                if (opcode = MOV or opcode = ADD or opcode = SUB) then
                    if (addrmodeo = REG and addrmoded = REG) then
                        -- set ALU inputs
                        w_aluoctrl <= "100"; -- origin resgister
                        w_aludctrl <= '1';   -- destination register

                        w_regrw <= '1';
                        w_flagsctrl <= '1';
                    elsif (addrmodeo = IMMEDIATE and addrmoded = REG) then
                        w_regrw <= '1';
                        w_flagsctrl <= '1';
                    end if;
                else
                    w_regrw <= '0';
                    w_flagsctrl <= '0';
                end if;

                if (opcode = JMP) then
                    if (addrmoded = "00") then
                        w_pcctrl <= "010";
                    elsif (addrmoded = "01") then
                        w_pcctrl <= "100";
                    elsif (addrmoded = "10") then
                        w_pcctrl <= "101";
                    end if;
                else
                    w_pcctrl <= "001"; -- start pc increment
                end if;

                write(L, opcode);
                writeline(output, L);

                write(L, addrmoded);
                writeline(output, L);

                next_state <= FETCH;

            when others =>
                next_state <= RESET;
        end case;
    end process;

    --fetch : process (clk) is
    --begin
    --    if (rising_edge(clk)) then
    --        if (w_done = '1') then
    --            w_instruction <= romdata;    -- fetch rom instruction
    --        end if;
    --    end if;
    --end process;

end architecture;
