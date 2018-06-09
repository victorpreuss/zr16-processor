---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 13/04/2018
-- File          : control_unit_tb.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typedefs.all;

---------------------------------------------------------------------------
entity control_unit_tb is
end entity;

---------------------------------------------------------------------------
architecture arch of control_unit_tb is

    component clk_gen is
    port (
        clk : out std_logic
     );
    end component;

    -- control signals
    signal clk       : std_logic := '0';
    signal rst_n     : std_logic := '1';

    signal instruction : std_logic_vector(15 downto 0) := (others => '0');
    signal aluflags    : std_logic_vector(2 downto 0) := "000";

    signal romctrl   : std_logic_vector(1 downto 0) := "00";
    signal irctrl    : std_logic := '0';
    signal ramctrl   : std_logic_vector(1 downto 0) := "00";
    signal ramrw     : std_logic := '0';
    signal regrw     : std_logic := '0';
    signal pcctrl    : std_logic_vector(1 downto 0) := "00";
    signal flagsctrl : std_logic_vector(2 downto 0) := "000";
    signal stackctrl : std_logic_vector(1 downto 0) := "00";
    signal latchctrl : std_logic := '0';
    signal aluctrl   : aluop_t := ALU_WIRE;
    signal aluoctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal aludctrl  : std_logic := '0';

    signal regorig : std_logic_vector(3 downto 0) := (others => '0');
    signal regdest : std_logic_vector(3 downto 0) := (others => '0');

begin

    clk_inst : clk_gen
    port map (
        clk => clk
    );

    uut : control_unit
    port map (
        clk         => clk,
        rst_n       => rst_n,
        instruction => instruction,
        aluflags    => aluflags,
        romctrl     => romctrl,
        irctrl      => irctrl,
        ramctrl     => ramctrl,
        ramrw       => ramrw,
        regrw       => regrw,
        stackctrl   => stackctrl,
        pcctrl      => pcctrl,
        flagsctrl   => flagsctrl,
        latchctrl   => latchctrl,
        aluctrl     => aluctrl,
        aluoctrl    => aluoctrl,
        aludctrl    => aludctrl,
        regorig     => regorig,
        regdest     => regdest
    );

    stimulus : process
    begin

        rst_n <= '0';
        wait for 5 ns;
        rst_n <= '1';
        wait for 10 ns; -- 20 ns

        -- MOV rd, ro with rd = 0101 and ro = 1010
        instruction <= "1101000001011010";

        wait for 10 ns; -- 30 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('1'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("100"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- MOV rd, (ro) with rd = 1010 and (ro) = 0101
        instruction <= "1101000110100101";

        wait for 10 ns; -- 40 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("01"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("00"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("011"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 50 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("01"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('1'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("011"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- MOV rd, (end) with rd = r0 and (end) = 10101010
        instruction <= "1101001010101010";

        wait for 10 ns; -- 60 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("00"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("011"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0000"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 70 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('1'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("011"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0000"   = regdest)   report "regdest is wrong!" severity error;

        -- MOV rd, immed with rd = r0 and immed = 01010101
        instruction <= "1101001101010101";

        wait for 10 ns; -- 80 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('1'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0000"   = regdest)   report "regdest is wrong!" severity error;

        -- MOV (rd), ro with (rd) = 0101 and ro = 1010
        instruction <= "1101010001011010";

        wait for 10 ns; -- 90 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("10"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('1'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("100"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- MOV (end), r0 with (end) = 01010101 and ro = r0
        instruction <= "1101100001010101";

        wait for 10 ns; -- 100 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('1'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("100"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0000"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- MVS rd, immed with rd = 1010 and immed = "0101010"
        instruction <= "0011101000101010";

        wait for 10 ns; -- 110 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('1'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('1'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- JMP (end) with (end) = 1101010101
        instruction <= "0000101101010101";

        wait for 10 ns; -- 120 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("11"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 130 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- JZ (end) with (end) = 1010101010 and Z = 0
        aluflags <= "011";
        instruction <= "0001001010101010";

        wait for 10 ns; -- 140 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- JZ (end) with (end) = 0101010101 and Z = 1
        aluflags <= "100";
        instruction <= "0001000101010101";

        wait for 10 ns; -- 150 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("11"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 160 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- JNZ (end) with (end) = 1010101010 and Z = 1
        aluflags <= "100";
        instruction <= "0001011010101010";

        wait for 10 ns; -- 170 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- JNZ (end) with (end) = 0101010101 and Z = 0
        aluflags <= "011";
        instruction <= "0001010101010101";

        wait for 10 ns; -- 180 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("11"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 190 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- JC (end) with (end) = 1010101010 and C = 0
        aluflags <= "101";
        instruction <= "0001101010101010";

        wait for 10 ns; -- 200 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- JC (end) with (end) = 0101010101 and C = 1
        aluflags <= "010";
        instruction <= "0001100101010101";

        wait for 10 ns; -- 210 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("11"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 220 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- JVP (end) with (end) = 1010101010 and VP = 0
        aluflags <= "110";
        instruction <= "0001111010101010";

        wait for 10 ns; -- 230 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- JVP (end) with (end) = 0101010101 and VP = 1
        aluflags <= "001";
        instruction <= "0001110101010101";

        wait for 10 ns; -- 240 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("11"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 250 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_WIRE = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0101"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0101"   = regdest)   report "regdest is wrong!" severity error;

        -- INC (end) with (end) = 10100000
        instruction <= "1111100010100000";

        wait for 10 ns; -- 260 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("00"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_INC  = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0000"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 270 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('1'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_INC  = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("0000"   = regorig)   report "regorig is wrong!" severity error;
        assert ("1010"   = regdest)   report "regdest is wrong!" severity error;

        -- DEC (end) with (end) = 00001010
        instruction <= "1111100100001010";

        wait for 10 ns; -- 280 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('0'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('0'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("00"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("000"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_DEC  = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0000"   = regdest)   report "regdest is wrong!" severity error;

        wait for 10 ns; -- 290 ns
        assert ("00"     = romctrl)   report "romctrl is wrong!" severity error;
        assert ('1'      = irctrl)    report "irctrl is wrong!" severity error;
        assert ("00"     = ramctrl)   report "ramctrl is wrong!" severity error;
        assert ('1'      = ramrw)     report "ramrw is wrong!" severity error;
        assert ('0'      = regrw)     report "regrw is wrong!" severity error;
        assert ("01"     = pcctrl)    report "pcctrl is wrong!" severity error;
        assert ("100"    = flagsctrl) report "flagsctrl is wrong!" severity error;
        assert (ALU_DEC  = aluctrl)   report "aluctrl is wrong!" severity error;
        assert ("000"    = aluoctrl)  report "aluoctrl is wrong!" severity error;
        assert ('0'      = aludctrl)  report "aludctrl is wrong!" severity error;
        assert ("1010"   = regorig)   report "regorig is wrong!" severity error;
        assert ("0000"   = regdest)   report "regdest is wrong!" severity error;

    end process;

end architecture;

---------------------------------------------------------------------------
