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
        aluflags    : in std_logic_vector(2 downto 0);
        romctrl     : out std_logic_vector(1 downto 0);
        ramctrl     : out std_logic_vector(1 downto 0);
        ramrw       : out std_logic;
        regrw       : out std_logic;
        pcctrl      : out std_logic_vector(2 downto 0);
        flagsctrl   : out std_logic_vector(2 downto 0);
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
    constant JZ   : std_logic_vector(3 downto 0) := "0001";
    constant JNZ  : std_logic_vector(3 downto 0) := "0001"; -- same as JZ
    constant JC   : std_logic_vector(3 downto 0) := "0001"; -- same as JZ
    constant JVP  : std_logic_vector(3 downto 0) := "0001"; -- same as JZ
    constant ADD  : std_logic_vector(3 downto 0) := "1000";
    constant SUB  : std_logic_vector(3 downto 0) := "1001";
    constant CMP  : std_logic_vector(3 downto 0) := "0111";
    constant MOV  : std_logic_vector(3 downto 0) := "1101";
    constant MVS  : std_logic_vector(3 downto 0) := "0011";
    constant INC  : std_logic_vector(3 downto 0) := "1111";
    constant DEC  : std_logic_vector(3 downto 0) := "1111";
    constant DJNZ : std_logic_vector(3 downto 0) := "1110";

    constant ANDx : std_logic_vector(3 downto 0) := "0100";
    constant ORx  : std_logic_vector(3 downto 0) := "0101";
    constant XORx : std_logic_vector(3 downto 0) := "0110";

    constant ROT : std_logic_vector(3 downto 0) := "1010";
    constant SHL : std_logic_vector(3 downto 0) := "1011";
    constant SHA : std_logic_vector(3 downto 0) := "1100";


    -- addressing modes
    constant REG       : std_logic_vector(1 downto 0) := "00";
    constant REG_ADDR  : std_logic_vector(1 downto 0) := "01";
    constant ADDR      : std_logic_vector(1 downto 0) := "10";
    constant IMMEDIATE : std_logic_vector(1 downto 0) := "11";

    constant REG0      : std_logic_vector(3 downto 0) := "0000";
    constant REG1      : std_logic_vector(3 downto 0) := "0001";
    constant REG2      : std_logic_vector(3 downto 0) := "0010";
    constant REG3      : std_logic_vector(3 downto 0) := "0011";
    constant REG4      : std_logic_vector(3 downto 0) := "0100";

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
    signal w_flagsctrl : std_logic_vector(2 downto 0) := "000";
    signal w_aluctrl   : std_logic_vector(3 downto 0) := (others => '0');
    signal w_aluoctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal w_aludctrl  : std_logic := '0';

    signal w_regorig : std_logic_vector(3 downto 0) := (others => '0');
    signal w_regdest : std_logic_vector(3 downto 0) := (others => '0');

    -- instruction registers
    signal w_instruction : std_logic_vector(15 downto 0) := (others => '0');

    -- instruction decode
    alias opcode      : std_logic_vector(3 downto 0) is w_instruction(15 downto 12); -- opcode

    alias addrmoded   : std_logic_vector(1 downto 0) is w_instruction(11 downto 10); -- addrmode of dest
    alias addrmodeo   : std_logic_vector(1 downto 0) is w_instruction(9 downto 8);   -- addrmode of orig

    alias dest    : std_logic_vector(3 downto 0) is w_instruction(7 downto 4);   -- destination
    alias orig    : std_logic_vector(3 downto 0) is w_instruction(3 downto 0);   -- origin

    alias immed   : std_logic_vector(7 downto 0) is w_instruction(7 downto 0);
    alias memaddr : std_logic_vector(7 downto 0) is w_instruction(7 downto 0);

    alias mvsdest : std_logic_vector(3 downto 0) is w_instruction(11 downto 8);

    -- alu flags
    alias Z     : std_logic is aluflags(2);
    alias C     : std_logic is aluflags(1);
    alias V_P   : std_logic is aluflags(0);

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
    sm_sequential : process (clk, rst_n) is
        variable L : line;
    begin
        if (rst_n = '0') then
            state <= RESET;
        elsif (falling_edge(clk)) then
            case (state) is
                when RESET =>
                    w_ramrw <= '0';
                    w_regrw <= '0';
                    w_flagsctrl <= "000";
                    w_pcctrl <= "001";
                    w_done <= '1';
                    state  <= CONTROL_1;

                when CONTROL_1 =>

                    -- set ALU control
                    case (opcode) is
                        when MOV =>
                            w_aluctrl <= "0000";
                        when MVS =>
                            w_aluctrl <= "0000";
                        when ADD =>
                            w_aluctrl <= "0001";
                        when SUB =>
                            w_aluctrl <= "0010";
                        when CMP =>
                            w_aluctrl <= "0100";
                        when JMP =>
                            w_aluctrl <= "0000";
                        when JZ => -- JNZ, JC and JVP have the same opcode
                            w_aluctrl <= "0000";
                        when INC => -- DEC has the same opcode
                            if (w_instruction(8) = '0') then
                                w_aluctrl <= "1000"; -- INC
                            elsif (w_instruction(8) = '1') then
                                w_aluctrl <= "1001"; -- DEC
                            end if;
                        when DJNZ =>
                            w_aluctrl <= "1001"; -- DEC
                        when others =>
                            w_aluctrl <= "0000";
                    end case;

                    -- addressing modes
                    if (opcode = MOV or opcode = ADD or opcode = SUB or
                        opcode = CMP) then
                        if (addrmodeo = REG and addrmoded = REG) then
                            -- alu inputs
                            w_aluoctrl <= "100"; -- ro
                            w_aludctrl <= '1';   -- rd

                            -- register file in/out
                            w_regorig <= orig;   -- ro
                            w_regdest <= dest;   -- rd

                            -- CMP does not write to destination
                            if (opcode = CMP) then
                                w_regrw <= '0';
                            else
                                w_regrw <= '1';
                            end if;

                            -- set alu flags according to the instruction
                            if (opcode = MOV) then
                                w_flagsctrl <= "100";
                            elsif (opcode = ADD or opcode = SUB or opcode = CMP) then
                                w_flagsctrl <= "111";
                            elsif (opcode = ANDx or opcode = ORx or opcode = XORx) then
                                w_flagsctrl <= "110";
                            elsif (opcode = ROT or opcode = SHL or opcode = SHA) then
                                w_flagsctrl <= "101";
                            end if;

                            -- keep ram in read mode to avoid overwrite
                            w_ramrw <= '0';
                            w_ramctrl <= "00";

                            -- increment pc and enable instruction fetch
                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = REG_ADDR and addrmoded = REG) then
                            -- alu inputs
                            w_aluoctrl <= "011"; -- ram
                            w_aludctrl <= '1';   -- rd

                            -- register file in/out
                            w_regorig <= orig; -- ro
                            w_regdest <= dest; -- rd

                            -- keep registers in read mode to avoid overwrite
                            w_regrw <= '0';
                            w_flagsctrl <= "000";

                            -- ram in read mode to get operator
                            w_ramrw <= '0';
                            w_ramctrl <= "01"; -- addr comes from ro

                            -- halt pc increment and instruction fetch
                            w_pcctrl <= "000";
                            w_done <= '0';

                            -- next stage of instruction
                            state <= CONTROL_2;
                        elsif (addrmodeo = ADDR and addrmoded = REG) then
                            --alu inputs
                            w_aluoctrl <= "011"; -- ram
                            w_aludctrl <= '1';   -- rd

                            -- register file in/out
                            w_regorig <= orig; -- ro
                            w_regdest <= REG0; -- r0

                            -- keep registers in read mode to avoid overwrite
                            w_regrw <= '0';
                            w_flagsctrl <= "000";

                            -- ram in read mode to get operator
                            w_ramrw <= '0';
                            w_ramctrl <= "00"; -- addr comes from immediate

                            -- halt pc increment and instruction fetch
                            w_pcctrl <= "000";
                            w_done <= '0';

                            -- next stage of instruction
                            state <= CONTROL_2;
                        elsif (addrmodeo = IMMEDIATE and addrmoded = REG) then
                            -- alu inputs
                            w_aluoctrl <= "000"; -- immediate
                            w_aludctrl <= '1';   -- rd

                            w_regorig <= orig; -- ro
                            w_regdest <= REG0; -- r0

                            -- CMP does not write to destination
                            if (opcode = CMP) then
                                w_regrw <= '0';
                            else
                                w_regrw <= '1';
                            end if;

                            -- set alu flags according to the instruction
                            if (opcode = MOV) then
                                w_flagsctrl <= "100";
                            elsif (opcode = ADD or opcode = SUB or opcode = CMP) then
                                w_flagsctrl <= "111";
                            elsif (opcode = ANDx or opcode = ORx or opcode = XORx) then
                                w_flagsctrl <= "110";
                            elsif (opcode = ROT or opcode = SHL or opcode = SHA) then
                                w_flagsctrl <= "101";
                            end if;

                            -- keep ram in read mode to avoid overwrite
                            w_ramrw <= '0';
                            w_ramctrl <= "00";

                            -- increment pc and enable instruction fetch
                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = REG and addrmoded = REG_ADDR) then
                            -- alu inputs
                            w_aluoctrl <= "100"; -- ro
                            w_aludctrl <= '0';   -- ram

                            -- register file in/out
                            w_regorig <= orig; -- ro
                            w_regdest <= dest; -- rd

                            -- keep registers in read mode to avoid overwrite
                            w_regrw <= '0';

                            -- set alu flags according to the instruction
                            if (opcode = MOV) then
                                w_flagsctrl <= "100";
                            elsif (opcode = ADD or opcode = SUB or opcode = CMP) then
                                w_flagsctrl <= "111";
                            elsif (opcode = ANDx or opcode = ORx or opcode = XORx) then
                                w_flagsctrl <= "110";
                            elsif (opcode = ROT or opcode = SHL or opcode = SHA) then
                                w_flagsctrl <= "101";
                            end if;

                            -- CMP does not write to destination
                            if (opcode = CMP) then
                                w_ramrw <= '0';
                            else
                                w_ramrw <= '1'; -- set ram to write mode
                            end if;

                            -- set ram addr source
                            w_ramctrl <= "10"; -- (rd)

                            -- increment pc and enable instruction fetch
                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = REG and addrmoded = ADDR) then
                            w_aluoctrl <= "100";
                            w_aludctrl <= '0';

                            w_regorig <= REG0;
                            w_regdest <= dest;

                            -- keep registers in read mode to avoid overwrite
                            w_regrw <= '0';

                            -- set alu flags according to the instruction
                            if (opcode = MOV) then
                                w_flagsctrl <= "100";
                            elsif (opcode = ADD or opcode = SUB or opcode = CMP) then
                                w_flagsctrl <= "111";
                            elsif (opcode = ANDx or opcode = ORx or opcode = XORx) then
                                w_flagsctrl <= "110";
                            elsif (opcode = ROT or opcode = SHL or opcode = SHA) then
                                w_flagsctrl <= "101";
                            end if;

                            -- CMP does not write to destination
                            if (opcode = CMP) then
                                w_ramrw <= '0';
                            else
                                w_ramrw <= '1'; -- set ram to write mode
                            end if;

                            -- set ram addr source
                            w_ramctrl <= "00"; -- immediate address

                            -- increment pc and enable instruction fetch
                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        end if;
                    elsif (opcode = MVS) then
                        w_aluoctrl <= "000";
                        w_aludctrl <= '1';

                        w_regorig <= orig;
                        w_regdest <= mvsdest;

                        w_ramrw <= '0';
                        w_regrw <= '1';
                        w_flagsctrl <= "100";
                        w_ramctrl <= "00";

                        w_pcctrl <= "001";
                        w_done <= '1';

                        state <= CONTROL_1;
                    elsif (opcode = JMP) then
                        if (addrmoded = "10") then
                            w_aluoctrl <= "000";

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= "000";

                            w_pcctrl <= "101";
                            w_done <= '0';

                            state <= CONTROL_2;
                        end if;
                    elsif (opcode = JZ) then -- JNZ, JC and JVP have the same opcode
                        if ((addrmoded = "00" and Z = '1') or -- JZ
                            (addrmoded = "01" and Z = '0') or -- JNZ
                            (addrmoded = "10" and C = '1') or -- JC
                            (addrmoded = "11" and V_P = '1')) then -- JVP
                            w_aluoctrl <= "000";

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= "000";

                            w_pcctrl <= "101";
                            w_done <= '0';

                            state <= CONTROL_2;
                        else
                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= "000";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        end if;
                    elsif (opcode = INC) then -- DEC has the same opcode
                        if (addrmoded = ADDR) then
                            w_aluoctrl <= "000";
                            w_aludctrl <= '0';

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '0';
                            w_regrw <= '0';
                            w_flagsctrl <= "000";
                            w_ramctrl <= "00";

                            w_pcctrl <= "000";
                            w_done <= '0';

                            state <= CONTROL_2;
                        end if;
                    elsif (opcode = DJNZ) then
                        w_aluoctrl <= "000";
                        w_aludctrl <= '1';

                        w_regorig <= orig;
                        if (addrmoded = "00") then
                            w_regdest <= REG1;
                        elsif (addrmoded = "01") then
                            w_regdest <= REG2;
                        elsif (addrmoded = "10") then
                            w_regdest <= REG3;
                        elsif (addrmoded = "11") then
                            w_regdest <= REG4;
                        end if;

                        w_ramrw <= '0';
                        w_regrw <= '0';
                        w_flagsctrl <= "000";
                        w_ramctrl <= "00";

                        w_pcctrl <= "000";
                        w_done <= '0';

                        state <= CONTROL_2;
                    else
                        state <= RESET;
                    end if;

                when CONTROL_2 =>

                    if (opcode = MOV or opcode = ADD or opcode = SUB or
                        opcode = CMP) then
                        if (addrmodeo = REG_ADDR and addrmoded = REG) then
                            -- CMP does not write to destination
                            if (opcode = CMP) then
                                w_regrw <= '0';
                            else
                                w_regrw <= '1';
                            end if;

                            -- set alu flags according to the instruction
                            if (opcode = MOV) then
                                w_flagsctrl <= "100";
                            elsif (opcode = ADD or opcode = SUB or opcode = CMP) then
                                w_flagsctrl <= "111";
                            elsif (opcode = ANDx or opcode = ORx or opcode = XORx) then
                                w_flagsctrl <= "110";
                            elsif (opcode = ROT or opcode = SHL or opcode = SHA) then
                                w_flagsctrl <= "101";
                            end if;

                            -- ram doesn't matter
                            w_ramrw <= '0';
                            w_ramctrl <= "01";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        elsif (addrmodeo = ADDR and addrmoded = REG) then
                            -- CMP does not write to destination
                            if (opcode = CMP) then
                                w_regrw <= '0';
                            else
                                w_regrw <= '1';
                            end if;

                            -- set alu flags according to the instruction
                            if (opcode = MOV) then
                                w_flagsctrl <= "100";
                            elsif (opcode = ADD or opcode = SUB or opcode = CMP) then
                                w_flagsctrl <= "111";
                            elsif (opcode = ANDx or opcode = ORx or opcode = XORx) then
                                w_flagsctrl <= "110";
                            elsif (opcode = ROT or opcode = SHL or opcode = SHA) then
                                w_flagsctrl <= "101";
                            end if;

                            -- ram doesn't matter
                            w_ramrw <= '0';
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
                            w_flagsctrl <= "000";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        end if;
                    elsif (opcode = JZ) then -- JNZ, JC and JVP have the same opcode
                        w_aluoctrl <= "000";

                        w_ramrw <= '0';
                        w_regrw <= '0';
                        w_flagsctrl <= "000";

                        w_pcctrl <= "001";
                        w_done <= '1';

                        state <= CONTROL_1;
                    elsif (opcode = INC) then -- DEC has the same opcode
                        if (addrmoded = REG) then

                        elsif (addrmoded = REG_ADDR) then

                        elsif (addrmoded = ADDR) then
                            w_aluoctrl <= "000";
                            w_aludctrl <= '0';

                            w_regorig <= orig;
                            w_regdest <= dest;

                            w_ramrw <= '1';
                            w_regrw <= '0';
                            w_flagsctrl <= "100";
                            w_ramctrl <= "00";

                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        end if;
                    elsif (opcode = DJNZ) then
                        w_aludctrl <= '1';

                        w_regorig <= orig;
                        w_regdest <= dest;

                        w_ramrw <= '0';
                        w_regrw <= '1';
                        w_flagsctrl <= "100";

                        if (Z = '1') then
                            w_pcctrl <= "101";
                            w_done <= '0';

                            state <= CONTROL_3;
                        else
                            w_pcctrl <= "001";
                            w_done <= '1';

                            state <= CONTROL_1;
                        end if;
                    end if;

                when CONTROL_3 =>

                    if (opcode = DJNZ) then
                        w_aluoctrl <= "000";

                        w_ramrw <= '0';
                        w_regrw <= '0';
                        w_flagsctrl <= "000";

                        w_pcctrl <= "001";
                        w_done <= '1';

                        state <= CONTROL_1;
                    end if;

                when others =>
                    state <= RESET;
            end case;
        end if;
    end process;

    instruction_fetch : process (clk, rst_n) is
    begin
        if (rst_n = '0') then
            w_instruction <= "0000000000000000";
        elsif (rising_edge(clk)) then
            if (w_done = '1') then
                w_instruction <= romdata; -- fetch rom instruction
            end if;
        end if;
    end process;

end architecture;
