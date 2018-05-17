---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 14/04/2018
-- File          : main.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.typedefs.all;

---------------------------------------------------------------------------
entity main is
end entity;

---------------------------------------------------------------------------
architecture arch of main is

    component clk_gen is
    port (
        clk : out std_logic
    );
    end component;

    -- the rom memory is 1024x16 and the addresses are 10 bits long
    constant ROM_ADDR   : integer := 10;
    constant ROM_DATA   : integer := 16;
    constant ROM_SIZE   : integer := 1024;

    -- rom inputs
    signal romaddr : std_logic_vector(9 downto 0) := (others => '0');
    signal romdata : std_logic_vector(15 downto 0) := (others => '0');

    -- instruction register
    signal instruction : std_logic_vector(15 downto 0) := (others => '0');

    -- instruction decode
    alias opcode      : std_logic_vector(3 downto 0) is instruction(15 downto 12); -- opcode

    -- the below definitions are for instructions of type MOV, ADD
    alias addrmoded   : std_logic_vector(1 downto 0) is instruction(11 downto 10); -- addrmode of dest
    alias addrmodeo   : std_logic_vector(1 downto 0) is instruction(9 downto 8);   -- addrmode of orig

    alias dest    : std_logic_vector(3 downto 0) is instruction(7 downto 4);   -- destination
    alias orig    : std_logic_vector(3 downto 0) is instruction(3 downto 0);   -- origin

    alias immed   : std_logic_vector(7 downto 0) is instruction(7 downto 0);
    alias memaddr : std_logic_vector(7 downto 0) is instruction(7 downto 0);

    -- registers
    signal regorig : std_logic_vector(3 downto 0);
    signal regdest : std_logic_vector(3 downto 0);

    signal pc  : std_logic_vector(9 downto 0) := (others => '0');
    signal r13 : std_logic_vector(7 downto 0) := (others => '0');
    signal r14 : std_logic_vector(7 downto 0) := (others => '0');
    signal r15 : std_logic_vector(7 downto 0) := (others => '0');
    signal ro  : std_logic_vector(7 downto 0) := (others => '0');
    signal rd  : std_logic_vector(7 downto 0) := (others => '0');

    -- flags of control registers
    alias rompartition : std_logic_vector(2 downto 0) is r14(6 downto 4);

    -- alu signals
    signal aluin1   : std_logic_vector(7 downto 0) := (others => '0');
    signal aluin2   : std_logic_vector(7 downto 0) := (others => '0');
    signal aluout   : std_logic_vector(7 downto 0) := (others => '0');
    signal aluflags : std_logic_vector(2 downto 0) := (others => '0');

    -- control signals
    signal romctrl   : std_logic_vector(1 downto 0) := "00";
    signal irctrl    : std_logic := '0';
    signal ramctrl   : std_logic_vector(1 downto 0) := "00";
    signal ramrw     : std_logic := '0';
    signal regrw     : std_logic := '0';
    signal pcctrl    : std_logic_vector(2 downto 0) := "000";
    signal flagsctrl : std_logic_vector(2 downto 0) := "000";
    signal aluctrl   : std_logic_vector(3 downto 0) := (others => '0');
    signal aluoctrl  : std_logic_vector(2 downto 0) := (others => '0');
    signal aludctrl  : std_logic := '0';

    -- ram signals
    signal ramaddr    : std_logic_vector(7 downto 0);
    signal ramdatain  : std_logic_vector(7 downto 0);
    signal ramdataout : std_logic_vector(7 downto 0);

    -- debug signal
    signal ramdebug  : bytearray_t(255 downto 0);
    signal regdebug  : bytearray_t(15 downto 0);

    -- clk and reset
    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '1';

begin

    -- process to print debug content
    debug : process (clk)
        variable L : line;
    begin
        write(L, string'("Registers Content:"));
        writeline(output, L);
        for i in 0 to 15 loop
            write(L, to_integer(unsigned(regdebug(i))));
            write(L, string'(" "));
        end loop;
        writeline(output, L);

        write(L, string'("RAM Content:"));
        writeline(output, L);
        for i in 0 to 15 loop
            write(L, to_integer(unsigned(ramdebug(i))));
            write(L, string'(" "));
        end loop;
        writeline(output, L);
        writeline(output, L);
    end process;

    clk_inst : clk_gen
    port map (
        clk  => clk
    );

    rom_inst : rom generic map(ROM_DATA, ROM_ADDR, ROM_SIZE)
    port map (
        addr => romaddr,
        data => romdata
    );

    instruction_register_inst : instruction_register
    port map (
        clk         => clk,
        rst_n       => rst_n,
        en          => irctrl,
        romdata     => romdata,
        instruction => instruction
    );

    mux_rom_inst : mux4 generic map(ROM_ADDR)
    port map (
        ctrl     => romctrl,
        in1      => pc,                                  -- pc register
        --in2      => rompartition & memaddr(7 downto 1),  -- in case of a MOV r0, (end)
        --in3      => rompartition & ro,                   -- in case of a MOV rd, (ro)
        in2      => (others => '0'),
        in3      => (others => '0'),
        in4      => (others => '0'),
        out1     => romaddr
    );

    registers_inst : register_file
    port map (
        clk     => clk,
        rw      => regrw,
        addro   => addrmodeo,
        pcctrl  => pcctrl,
        in1     => regorig,
        in2     => regdest,
        alu     => aluout,
        flags   => aluflags,
        flctrl  => flagsctrl,
        ro      => ro,
        rd      => rd,
        r15     => r15,
        pc      => pc,
        regdebug => regdebug
    );

    mux_alu_o_inst : mux8 generic map(8)
    port map (
        ctrl    => aluoctrl,
        in1     => immed,
        in2     => romdata(15 downto 8),
        in3     => romdata(7 downto 0),
        in4     => ramdataout,
        in5     => ro,
        in6     => (others => '0'),
        in7     => (others => '0'),
        in8     => (others => '0'),
        out1    => aluin1
    );

    mux_alu_d_inst : mux2 generic map(8)
    port map (
        ctrl    => aludctrl,
        in1     => ramdataout,
        in2     => rd,
        out1    => aluin2
    );

    alu_inst : alu
    port map (
        op      => aluctrl,
        Cin     => r15(7),
        uc      => r15(2),
        ed      => r15(1),
        in1     => aluin1,
        in2     => aluin2,
        out1    => aluout,
        Z       => aluflags(2),
        Cout    => aluflags(1),
        V_P     => aluflags(0)
    );

    control_unit_inst : control_unit
    port map (
        clk         => clk,
        rst_n       => rst_n,
        instruction => instruction,
        aluflags    => r15(7 downto 5),
        romctrl     => romctrl,
        irctrl      => irctrl,
        ramctrl     => ramctrl,
        ramrw       => ramrw,
        regrw       => regrw,
        pcctrl      => pcctrl,
        flagsctrl   => flagsctrl,
        aluctrl     => aluctrl,
        aluoctrl    => aluoctrl,
        aludctrl    => aludctrl,
        regorig     => regorig,
        regdest     => regdest
    );

    mux_ram_inst : mux4 generic map(8)
    port map (
        ctrl    => ramctrl,
        in1     => memaddr,
        in2     => ro,
        in3     => rd,
        in4     => (others => '0'),
        out1    => ramaddr
    );

    ram_inst : ram
    port map (
        clk     => clk,
        rst_n   => rst_n,
        rw      => ramrw,
        addr    => ramaddr,
        datain  => aluout,
        dataout => ramdataout,
        ramdebug => ramdebug
    );

end architecture;
