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
use work.typedefs.all;

---------------------------------------------------------------------------
entity control_unit is
    port (
        clk         : in std_logic;
        rst_n       : in std_logic;
        instruction : in std_logic_vector(15 downto 0);
        aluflags    : in std_logic_vector(2 downto 0);
        romctrl     : out std_logic_vector(1 downto 0);
        irctrl      : out std_logic;
        ramctrl     : out std_logic_vector(1 downto 0);
        ramrw       : out std_logic;
        regrw       : out std_logic;
        stackctrl   : out std_logic_vector(1 downto 0);
        pcctrl      : out std_logic_vector(1 downto 0);
        flagsctrl   : out std_logic_vector(2 downto 0);
        latchctrl   : out std_logic;
        aluctrl     : out aluop_t;
        aluoctrl    : out std_logic_vector(2 downto 0);
        aludctrl    : out std_logic;
        regorig     : out std_logic_vector(3 downto 0);
        regdest     : out std_logic_vector(3 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of control_unit is

    -- jump instructions
    constant JMP  : std_logic_vector(3 downto 0) := "0000";
    constant JZ   : std_logic_vector(3 downto 0) := "0001";
    constant JNZ  : std_logic_vector(3 downto 0) := "0001"; -- same as JZ
    constant JC   : std_logic_vector(3 downto 0) := "0001"; -- same as JZ
    constant JVP  : std_logic_vector(3 downto 0) := "0001"; -- same as JZ
    constant DJNZ : std_logic_vector(3 downto 0) := "1110";

    -- data movement instructions
    constant MOV  : std_logic_vector(3 downto 0) := "1101";
    constant MVS  : std_logic_vector(3 downto 0) := "0011";

    -- ALU instructions
    constant ADD  : std_logic_vector(3 downto 0) := "1000";
    constant SUB  : std_logic_vector(3 downto 0) := "1001";
    constant CMP  : std_logic_vector(3 downto 0) := "0111";

    constant INC  : std_logic_vector(3 downto 0) := "1111";
    constant DEC  : std_logic_vector(3 downto 0) := "1111";

    constant ANDx : std_logic_vector(3 downto 0) := "0100";
    constant ORx  : std_logic_vector(3 downto 0) := "0101";
    constant XORx : std_logic_vector(3 downto 0) := "0110";

    constant ROT : std_logic_vector(3 downto 0) := "1010";
    constant SHL : std_logic_vector(3 downto 0) := "1011";
    constant SHA : std_logic_vector(3 downto 0) := "1100";

    -- addressing modes
    constant REG       : std_logic_vector(1 downto 0) := "00";
    constant REGADDR   : std_logic_vector(1 downto 0) := "01";
    constant ADDR      : std_logic_vector(1 downto 0) := "10";
    constant IMMEDIATE : std_logic_vector(1 downto 0) := "11";

    -- register names
    constant REG0      : std_logic_vector(3 downto 0) := "0000";
    constant REG1      : std_logic_vector(3 downto 0) := "0001";
    constant REG2      : std_logic_vector(3 downto 0) := "0010";
    constant REG3      : std_logic_vector(3 downto 0) := "0011";
    constant REG4      : std_logic_vector(3 downto 0) := "0100";

    -- control signals
    signal romctrl_d   : std_logic_vector(1 downto 0) := "00";
    signal irctrl_d    : std_logic := '0';
    signal ramctrl_d   : std_logic_vector(1 downto 0) := "00";
    signal ramrw_d     : std_logic := '0';
    signal regrw_d     : std_logic := '0';
    signal stackctrl_d : std_logic_vector(1 downto 0) := "00";
    signal pcctrl_d    : std_logic_vector(1 downto 0) := "00";
    signal flagsctrl_d : std_logic_vector(2 downto 0) := "000";
    signal latchctrl_d : std_logic := '0';
    signal aluctrl_d   : aluop_t := ALU_WIRE;
    signal aluoctrl_d  : std_logic_vector(2 downto 0) := (others => '0');
    signal aludctrl_d  : std_logic := '0';
    signal regorig_d   : std_logic_vector(3 downto 0) := (others => '0');
    signal regdest_d   : std_logic_vector(3 downto 0) := (others => '0');

    -- instruction decode
    alias opcode    : std_logic_vector(3 downto 0) is instruction(15 downto 12);
    alias addrmoded : std_logic_vector(1 downto 0) is instruction(11 downto 10);
    alias addrmodeo : std_logic_vector(1 downto 0) is instruction(9 downto 8);
    alias dest      : std_logic_vector(3 downto 0) is instruction(7 downto 4);
    alias orig      : std_logic_vector(3 downto 0) is instruction(3 downto 0);
    alias immed     : std_logic_vector(7 downto 0) is instruction(7 downto 0);
    alias memaddr   : std_logic_vector(7 downto 0) is instruction(7 downto 0);
    alias mvsdest   : std_logic_vector(3 downto 0) is instruction(11 downto 8);

    -- alu flags
    alias Z   : std_logic is aluflags(2);
    alias C   : std_logic is aluflags(1);
    alias V_P : std_logic is aluflags(0);

    -- control unit state machine
    type state_t is (HALT,
                     MOV_REG_REG,
                     MOV_REGADDR_REG_1, MOV_REGADDR_REG_2,
                     MOV_ADDR_REG_1, MOV_ADDR_REG_2,
                     MOV_IMMED_REG,
                     MOV_REG_REGADDR,
                     MOV_REGADDR_REGADDR_1, MOV_REGADDR_REGADDR_2,
                     MOV_ADDR_REGADDR_1, MOV_ADDR_REGADDR_2,
                     MOV_IMMED_REGADDR,
                     MOV_REG_ADDR,
                     MOV_REGADDR_ADDR_1, MOV_REGADDR_ADDR_2,
                     MVS_IMMED_REG,
                     ADD_REGADDR_REGADDR_1, ADD_REGADDR_REGADDR_2, ADD_REGADDR_REGADDR_3,
                     ADD_ADDR_REGADDR_1, ADD_ADDR_REGADDR_2, ADD_ADDR_REGADDR_3,
                     ADD_REG_REGADDR_1,
                     ADD_IMMED_REGADDR_1,
                     ADD_REG_ADDR_1,
                     ADD_REGADDR_ADDR_1, ADD_REGADDR_ADDR_2, ADD_REGADDR_ADDR_3,
                     JMP_REG, JMP_REGADDR_1, JMP_REGADDR_2, JMP_ADDR, JMP_END,
                     INC_REG, INC_REGADDR_1, INC_REGADDR_2, INC_ADDR_1, INC_ADDR_2,
                     DJNZ_REG_ADDR_1
                    );

    signal state_d : state_t := HALT;
    signal state_q : state_t := HALT;

    signal regdest_aux   : std_logic_vector(3 downto 0) := "0000";
    signal rw_aux        : std_logic := '0';
    signal flagsctrl_aux : std_logic_vector(2 downto 0) := "000";

begin

    sm_sequential : process (clk, rst_n) is
    begin
        if (rst_n = '0') then
            state_q <= HALT;
        elsif (falling_edge(clk)) then
            state_q <= state_d;
        end if;
    end process;

    sm_transitions : process (state_q, instruction, aluflags) is
    begin
        if (opcode = MOV or opcode = ROT  or opcode = SHL or opcode = SHA) then
            if (addrmodeo = REG and addrmoded = REG) then
                state_d <= MOV_REG_REG;
            elsif (addrmodeo = REGADDR and addrmoded = REG) then
                if (state_q = MOV_REGADDR_REG_1) then
                    state_d <= MOV_REGADDR_REG_2;
                else
                    state_d <= MOV_REGADDR_REG_1;
                end if;
            elsif (addrmodeo = ADDR and addrmoded = REG) then
                if (state_q = MOV_ADDR_REG_1) then
                    state_d <= MOV_ADDR_REG_2;
                else
                    state_d <= MOV_ADDR_REG_1;
                end if;
            elsif (addrmodeo = IMMEDIATE and addrmoded = REG) then
                state_d <= MOV_IMMED_REG;
            elsif (addrmodeo = REGADDR and addrmoded = REGADDR) then
                if (state_q = MOV_REGADDR_REGADDR_1) then
                    state_d <= MOV_REGADDR_REGADDR_2;
                else
                    state_d <= MOV_REGADDR_REGADDR_1;
                end if;
            elsif (addrmodeo = ADDR and addrmoded = REGADDR) then
                if (state_q = MOV_ADDR_REGADDR_1) then
                    state_d <= MOV_ADDR_REGADDR_2;
                else
                    state_d <= MOV_ADDR_REGADDR_1;
                end if;
            elsif (addrmodeo = REG and addrmoded = REGADDR) then
                state_d <= MOV_REG_REGADDR;
            elsif (addrmodeo = IMMEDIATE and addrmoded = REGADDR) then
                state_d <= MOV_IMMED_REGADDR;
            elsif (addrmodeo = REG and addrmoded = ADDR) then
                state_d <= MOV_REG_ADDR;
            elsif (addrmodeo = REGADDR and addrmoded = ADDR) then
                if (state_q = MOV_REGADDR_ADDR_1) then
                    state_d <= MOV_REGADDR_ADDR_2;
                else
                    state_d <= MOV_REGADDR_ADDR_1;
                end if;
            else
                state_d <= HALT;
            end if;
        elsif (opcode = MVS) then
            state_d <= MVS_IMMED_REG;
        elsif (opcode = ADD or opcode = SUB or opcode = CMP or
               opcode = ANDx or opcode = ORx or opcode = XORx) then
            if (addrmodeo = REG and addrmoded = REG) then
                state_d <= MOV_REG_REG;
            elsif (addrmodeo = REGADDR and addrmoded = REG) then
                if (state_q = MOV_REGADDR_REG_1) then
                    state_d <= MOV_REGADDR_REG_2;
                else
                    state_d <= MOV_REGADDR_REG_1;
                end if;
            elsif (addrmodeo = ADDR and addrmoded = REG) then
                if (state_q = MOV_ADDR_REG_1) then
                    state_d <= MOV_ADDR_REG_2;
                else
                    state_d <= MOV_ADDR_REG_1;
                end if;
            elsif (addrmodeo = IMMEDIATE and addrmoded = REG) then
                state_d <= MOV_IMMED_REG;
            elsif (addrmodeo = REGADDR and addrmoded = REGADDR) then
                if (state_q = ADD_REGADDR_REGADDR_1) then
                    state_d <= ADD_REGADDR_REGADDR_2;
                elsif (state_q = ADD_REGADDR_REGADDR_2) then
                    state_d <= ADD_REGADDR_REGADDR_3;
                else
                    state_d <= ADD_REGADDR_REGADDR_1;
                end if;
            elsif (addrmodeo = ADDR and addrmoded = REGADDR) then
                if (state_q = ADD_ADDR_REGADDR_1) then
                    state_d <= ADD_ADDR_REGADDR_2;
                elsif (state_q = ADD_ADDR_REGADDR_2) then
                    state_d <= ADD_ADDR_REGADDR_3;
                else
                    state_d <= ADD_ADDR_REGADDR_1;
                end if;
            elsif (addrmodeo = REG and addrmoded = REGADDR) then
                if (state_q = ADD_REG_REGADDR_1) then
                    state_d <= MOV_REG_REGADDR;
                else
                    state_d <= ADD_REG_REGADDR_1;
                end if;
            elsif (addrmodeo = IMMEDIATE and addrmoded = REGADDR) then
                if (state_q = ADD_IMMED_REGADDR_1) then
                    state_d <= MOV_IMMED_REGADDR;
                else
                    state_d <= ADD_IMMED_REGADDR_1;
                end if;
            elsif (addrmodeo = REG and addrmoded = ADDR) then
                if (state_q = ADD_REG_ADDR_1) then
                    state_d <= MOV_REG_ADDR;
                else
                    state_d <= ADD_REG_ADDR_1;
                end if;
            elsif (addrmodeo = REGADDR and addrmoded = ADDR) then
                if (state_q = ADD_REGADDR_ADDR_1) then
                    state_d <= ADD_REGADDR_ADDR_2;
                elsif (state_q = ADD_REGADDR_ADDR_2) then
                    state_d <= ADD_REGADDR_ADDR_3;
                else
                    state_d <= ADD_REGADDR_ADDR_1;
                end if;
            else
                state_d <= HALT;
            end if;
        elsif (opcode = JMP) then
            if (addrmoded = REG) then
                if (state_q = JMP_REG) then
                    state_d <= JMP_END;
                else
                    state_d <= JMP_REG;
                end if;
            elsif (addrmoded = REGADDR) then
                if (state_q = JMP_REGADDR_1) then
                    state_d <= JMP_REGADDR_2;
                elsif (state_q = JMP_REGADDR_2) then
                    state_d <= JMP_END;
                else
                    state_d <= JMP_REGADDR_1;
                end if;
            elsif (addrmoded = ADDR or addrmoded = IMMEDIATE) then
                if (state_q = JMP_ADDR) then
                    state_d <= JMP_END;
                else
                    state_d <= JMP_ADDR;
                end if;
            else
                state_d <= HALT;
            end if;
        elsif (opcode = JZ) then -- JNZ, JC and JVP have the same opcode
            if ((addrmoded = "00" and Z = '1') or -- JZ
                (addrmoded = "01" and Z = '0') or -- JNZ
                (addrmoded = "10" and C = '1') or -- JC
                (addrmoded = "11" and V_P = '1')) then -- JVP
                if (state_q = JMP_ADDR) then
                    state_d <= JMP_END;
                else
                    state_d <= JMP_ADDR;
                end if;
            else
                state_d <= HALT;
            end if;
        elsif (opcode = INC) then -- DEC has the same opcode
            if (addrmoded = REG) then
                state_d <= INC_REG;
            elsif (addrmoded = REGADDR) then
                if (state_q = INC_REGADDR_1) then
                    state_d <= INC_REGADDR_2;
                else
                    state_d <= INC_REGADDR_1;
                end if;
            elsif (addrmoded = ADDR) then
                if (state_q = INC_ADDR_1) then
                    state_d <= INC_ADDR_2;
                else
                    state_d <= INC_ADDR_1;
                end if;
            else
                state_d <= HALT;
            end if;
        elsif (opcode = DJNZ) then
            if (state_q = DJNZ_REG_ADDR_1) then
                if (Z = '0') then
                    state_d <= JMP_ADDR;
                else
                    state_d <= JMP_END;
                end if;
            elsif (state_q = JMP_ADDR) then
                state_d <= JMP_END;
            else
                state_d <= DJNZ_REG_ADDR_1;
            end if;
        else
            state_d <= HALT;
        end if;
    end process;

    sm_outputs : process (state_q, instruction, aluflags, flagsctrl_aux, rw_aux) is
    begin
        case (state_q) is
            when INC_REGADDR_1 =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when INC_REGADDR_2 =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "100";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= '1';
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when INC_REG =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "100";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '1';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when INC_ADDR_1 =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when INC_ADDR_2 =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "100";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '1';
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when DJNZ_REG_ADDR_1 =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= regdest_aux; -- rd
                flagsctrl_d <= "100";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '1';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when JMP_ADDR =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "11";
                irctrl_d    <= '0';
            when JMP_REG =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "10";
                irctrl_d    <= '0';
            when JMP_REGADDR_1 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when JMP_REGADDR_2 =>
                aluoctrl_d  <= "011"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "11";
                irctrl_d    <= '0';
            when JMP_END =>
                aluoctrl_d  <= "000"; -- immed
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MVS_IMMED_REG =>
                aluoctrl_d  <= "000";    -- immed
                aludctrl_d  <= '0';      -- ram
                regorig_d   <= orig;     -- ro
                regdest_d   <= mvsdest;  -- rd
                flagsctrl_d <= "100";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '1';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REG_REG =>
                aluoctrl_d  <= "100"; -- ro
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= rw_aux;
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REGADDR_REG_1 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "01";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when MOV_ADDR_REG_1 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when MOV_IMMED_REG =>
                aluoctrl_d  <= "000"; -- immediate
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= rw_aux;
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REG_REGADDR =>
                aluoctrl_d  <= "100"; -- ro
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10";
                ramrw_d     <= rw_aux;
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REGADDR_REGADDR_1 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "01"; -- (ro)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when MOV_ADDR_REGADDR_1 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00"; -- (end)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when MOV_IMMED_REGADDR =>
                aluoctrl_d  <= "000"; -- immediate
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10";
                ramrw_d     <= rw_aux;
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REG_ADDR =>
                aluoctrl_d  <= "100"; -- ro
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= REG0;  -- r0
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= rw_aux;
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REGADDR_ADDR_1 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= REG0;  -- r0
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "01"; -- (r0)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            --when ADD_REGADDR_REGADDR_1 =>

            --when ADD_ADDR_REGADDR_1 =>

            when ADD_REG_REGADDR_1 =>
                aluoctrl_d  <= "100"; -- ro
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when ADD_IMMED_REGADDR_1 =>
                aluoctrl_d  <= "000"; -- immediate
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            when ADD_REG_ADDR_1 =>
                aluoctrl_d  <= "100"; -- ro
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= REG0;  -- r0
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00"; -- (end)
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "00";
                irctrl_d    <= '0';
            --when ADD_REGADDR_ADDR_1 =>

            when MOV_REGADDR_REG_2 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "01";
                ramrw_d     <= '0';
                regrw_d     <= rw_aux;
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_ADDR_REG_2 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '1';   -- rd
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= rw_aux;
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REGADDR_REGADDR_2 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (rd)
                ramrw_d     <= rw_aux;
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_ADDR_REGADDR_2 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= orig;  -- ro
                regdest_d   <= REG0;  -- r0
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "10"; -- (r0)
                ramrw_d     <= rw_aux;
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when MOV_REGADDR_ADDR_2 =>
                aluoctrl_d  <= "011"; -- ram
                aludctrl_d  <= '0';   -- ram
                regorig_d   <= REG0;  -- r0
                regdest_d   <= dest;  -- rd
                flagsctrl_d <= flagsctrl_aux;
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00"; -- (end)
                ramrw_d     <= rw_aux;
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            --when ADD_REGADDR_REGADDR_2 =>

            --when ADD_ADDR_REGADDR_2 =>

            --when ADD_REGADDR_ADDR_2 =>

            --when ADD_REGADDR_REGADDR_3 =>

            --when ADD_ADDR_REGADDR_3 =>

            --when ADD_REGADDR_ADDR_3 =>

            when HALT =>
                aluoctrl_d  <= "000";
                aludctrl_d  <= '0';
                regorig_d   <= "0000";
                regdest_d   <= "0000";
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
            when others =>
                aluoctrl_d  <= "000";
                aludctrl_d  <= '0';
                regorig_d   <= "0000";
                regdest_d   <= "0000";
                flagsctrl_d <= "000";
                stackctrl_d <= "00";
                latchctrl_d <= '0';
                romctrl_d   <= "00";
                ramctrl_d   <= "00";
                ramrw_d     <= '0';
                regrw_d     <= '0';
                pcctrl_d    <= "01";
                irctrl_d    <= '1';
        end case;
    end process;

    regdest_aux <= REG1 when (addrmoded = "00") else
                   REG2 when (addrmoded = "01") else
                   REG3 when (addrmoded = "10") else
                   REG4 when (addrmoded = "11") else
                   "0000";

    rw_aux <= '0' when (opcode = CMP) else '1';

    flagsctrl_aux <= "100" when (opcode = MOV) else
                     "111" when (opcode = ADD or opcode = SUB or opcode = CMP or opcode = SHA) else
                     "110" when (opcode = ANDx or opcode = ORx or opcode = XORx) else
                     "101" when (opcode = SHL or opcode = ROT) else
                     "000";

    aluctrl_d <= ALU_WIRE when (opcode = JMP) else
                 ALU_WIRE when (opcode = JZ) else
                 ALU_DEC  when (opcode = DJNZ and state_q = DJNZ_REG_ADDR_1) else
                 ALU_WIRE when (opcode = MOV) else
                 ALU_WIRE when (opcode = MVS) else
                 ALU_ADD  when (opcode = ADD) else
                 ALU_SUB  when (opcode = SUB) else
                 ALU_SUB  when (opcode = CMP) else
                 ALU_INC  when (opcode = INC and instruction(8) = '0') else
                 ALU_DEC  when (opcode = DEC and instruction(8) = '1') else
                 ALU_AND  when (opcode = ANDx) else
                 ALU_OR   when (opcode = ORx) else
                 ALU_XOR  when (opcode = XORx) else
                 ALU_ROT  when (opcode = ROT) else
                 ALU_SHL  when (opcode = SHL) else
                 ALU_SHA  when (opcode = SHA) else
                 ALU_WIRE;

     aluoctrl  <= aluoctrl_d;
     aludctrl  <= aludctrl_d;
     regorig   <= regorig_d;
     regdest   <= regdest_d;
     aluctrl   <= aluctrl_d;
     flagsctrl <= flagsctrl_d;
     stackctrl <= stackctrl_d;
     latchctrl <= latchctrl_d;
     romctrl   <= romctrl_d;
     ramctrl   <= ramctrl_d;
     ramrw     <= ramrw_d;
     regrw     <= regrw_d;
     pcctrl    <= pcctrl_d;
     irctrl    <= irctrl_d;

end architecture;
