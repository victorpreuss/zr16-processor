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
        ramctrl     : out std_logic_vector(1 downto 0);
        ramrw       : out std_logic;
        regrw       : out std_logic;
        pcctrl      : out std_logic_vector(2 downto 0);
        flagsctrl   : out std_logic;
        aluctrl     : out std_logic_vector(3 downto 0);
        aluoctrl    : out std_logic_vector(2 downto 0);
        aludctrl    : out std_logic;
        regorig     : out std_logic_vector(3 downto 0);
        regdest     : out std_logic_vector(3 downto 0);
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

    constant REG0      : std_logic_vector(3 downto 0) := "0000";

    -- control unit state machine
    type state_t is (RESET, FETCH, CONTROL_1, CONTROL_2, CONTROL_3, HALT);
    signal state : state_t := RESET;
    signal next_state : state_t := RESET;

    -- control signals
    signal w_romctrl   : std_logic_vector(1 downto 0) := "00";
    signal w_ramctrl   : std_logic_vector(1 downto 0) := "00";
    signal w_ramrw     : std_logic := '0'; -- RAM R/W flag
    signal w_regrw     : std_logic := '0'; -- registers R/W flag
    signal w_pcctrl    : std_logic_vector(2 downto 0) := "000";
    signal w_flagsctrl : std_logic := '0';
    signal w_aluctrl   : std_logic_vector(3 downto 0) := (others => '0');
    signal w_aluoctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal w_aludctrl  : std_logic := '0';

    signal w_regorig : std_logic_vector(3 downto 0) := (others => '0');
    signal w_regdest : std_logic_vector(3 downto 0) := (others => '0');

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

    signal w_done : std_logic := '0';

begin

    romctrl   <= w_romctrl;
    ramctrl   <= w_ramctrl;
    ramrw     <= w_ramrw;
    regrw     <= w_regrw;
    pcctrl    <= w_pcctrl;
    flagsctrl <= w_flagsctrl;
    aluctrl   <= w_aluctrl;
    aluoctrl  <= w_aluoctrl;
    aludctrl  <= w_aludctrl;

    regorig <= w_regorig;
    regdest <= w_regdest;

    instruction <= w_instruction;

    -- transition of state machine is synchronous
    sm_sequential : process (clk) is
        variable L : line;
    begin
        if (rst_n = '0') then
            state <= RESET;
        elsif (falling_edge(clk)) then
            case (state) is
                when RESET =>

                    w_ramrw <= '0';
                    w_regrw <= '0';
                    w_flagsctrl <= '0';
                    w_pcctrl <= "001";
                    w_done <= '1';
                    state  <= CONTROL_1;

                when CONTROL_1 =>

                    -- set ALU control
                    case (opcode) is
                        when MOV =>
                            w_aluctrl <= "0000";
                        when ADD =>
                            w_aluctrl <= "0001";
                        when SUB =>
                            w_aluctrl <= "0010";
                        when JMP =>
                            w_aluctrl <= "0000"; -- ALU is a wire
                        when others =>
                            w_aluctrl <= "0000";
                    end case;

                    -- addressing modes
                    if (opcode = MOV or opcode = ADD or opcode = SUB) then
                        if (addrmodeo = REG and addrmoded = REG) then
                            w_aluoctrl <= "100";
                            w_aludctrl <= '1';

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '1';
                            w_flagsctrl <= '1';
                            w_ramctrl <= "00";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = REG_ADDR and addrmoded = REG) then
                            w_aluoctrl <= "011";
                            w_aludctrl <= '1';

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= '0';
                            w_ramctrl <= "01";

                            w_pcctrl <= "000";
                            w_done <= '0';

                            state <= CONTROL_2;
                        elsif (addrmodeo = ADDR and addrmoded = REG) then
                            w_aluoctrl <= "011";
                            w_aludctrl <= '1';

                            w_regorig <= orig;
                            w_regdest <= REG0;

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= '0';
                            w_ramctrl <= "00";

                            w_pcctrl <= "000";
                            w_done <= '0';

                            state <= CONTROL_2;
                        elsif (addrmodeo = IMMEDIATE and addrmoded = REG) then
                            w_aluoctrl <= "000";
                            w_aludctrl <= '1';

                            w_regorig <= orig;
                            w_regdest <= REG0;

                            w_ramrw <= '0';
                            w_regrw <= '1';
                            w_flagsctrl <= '1';
                            w_ramctrl <= "00";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = REG and addrmoded = REG_ADDR) then
                            w_aluoctrl <= "100";
                            w_aludctrl <= '0';

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '1';
                            w_regrw <= '0';
                            w_flagsctrl <= '1';
                            w_ramctrl <= "10";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = REG and addrmoded = ADDR) then
                            w_aluoctrl <= "100";
                            w_aludctrl <= '0';

                            w_regorig <= REG0;
                            w_regdest <= dest;

                            w_ramrw <= '1';
                            w_regrw <= '0';
                            w_flagsctrl <= '1';
                            w_ramctrl <= "00";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                            --write(L, to_hstring(instruction));
                            --writeline(output, L);
                        end if;
                    elsif (opcode = JMP) then
                        if (addrmoded = "00") then
                            --w_pcctrl <= "010";
                            -- TODO: Finish this implementation
                        elsif (addrmoded = "01") then
                            --w_aluoctrl <= "011";

                            --w_regorig <= orig;
                            --w_regdest <= dest;

                            --w_ramrw <= '0';
                            --w_regrw <= '0';
                            --w_flagsctrl <= '0';
                            --w_ramctrl <= "10";

                            --w_pcctrl <= "100"; -- SET THIS on CONTROL_2 or 3
                            --w_done <= '0';

                            --state <= CONTROL_2;
                            -- TODO: Finish this implementation
                            -- Takes 3 cycles!!!
                        elsif (addrmoded = "10") then
                            w_aluoctrl <= "000";

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= '0';

                            w_pcctrl <= "101";
                            w_done <= '0';

                            state <= CONTROL_2;
                        end if;
                    else
                        state <= RESET;
                    end if;

                when CONTROL_2 =>

                    if (opcode = MOV or opcode = ADD or opcode = SUB) then
                        if (addrmodeo = REG_ADDR and addrmoded = REG) then
                            w_aluoctrl <= "011";
                            w_aludctrl <= '1';

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '1';
                            w_flagsctrl <= '1';
                            w_ramctrl <= "00";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = ADDR and addrmoded = REG) then
                            w_aluoctrl <= "011";
                            w_aludctrl <= '1';

                            w_regorig <= orig;
                            w_regdest <= REG0;

                            w_ramrw <= '0';
                            w_regrw <= '1';
                            w_flagsctrl <= '1';
                            w_ramctrl <= "00";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        end if;
                    elsif (opcode = JMP) then
                        if (addrmoded = "10") then
                            w_aluoctrl <= "000";

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= '0';

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmoded = "01") then
                            -- TODO: implement this jump from memory position
                        end if;
                    end if;

                when others =>
                    state <= RESET;
            end case;
        end if;
    end process;

    resgiter_instruction : process (clk) is
    begin
        if (rising_edge(clk)) then
            if (w_done = '1') then
                w_instruction <= romdata;    -- fetch rom instruction
            end if;
        end if;
    end process;

end architecture;
