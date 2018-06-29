---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 13/04/2018
-- File          : register_file.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.typedefs.all;

---------------------------------------------------------------------------
entity register_file is
    port (
        clk       : in std_logic;
        rst_n     : in std_logic;
        rw        : in std_logic;                    -- read = '0' / write = '1'
        addro     : in std_logic_vector(1 downto 0); -- bits 9:8 of instruction
        pcctrl    : in std_logic_vector(1 downto 0);
        stackctrl : in std_logic_vector(1 downto 0);
        in1       : in std_logic_vector(3 downto 0); -- origin register
        in2       : in std_logic_vector(3 downto 0); -- destination register
        alu       : in std_logic_vector(7 downto 0); -- alu data
        flags     : in std_logic_vector(2 downto 0);
        flctrl    : in std_logic_vector(2 downto 0); -- flag to overwrite register flags with alu
        ro        : out std_logic_vector(7 downto 0);
        rd        : out std_logic_vector(7 downto 0);
        r13       : out std_logic_vector(7 downto 0);
        r14       : out std_logic_vector(7 downto 0);
        r15       : out std_logic_vector(7 downto 0);
        pc        : out std_logic_vector(9 downto 0);
        regdebug  : out bytearray_t(15 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of register_file is

    signal rf    : bytearray_t(15 downto 0) := (others => (others => '0'));

    signal r13stack : bytearray_t(3 downto 0) := (others => (others => '0'));
    signal r14stack : bytearray_t(3 downto 0) := (others => (others => '0'));
    signal r15stack : bytearray_t(3 downto 0) := (others => (others => '0'));

    signal counter : integer range 0 to 3 := 0;
    signal top : integer range 0 to 3 := 0;

    signal idx_o : integer range 0 to 15 := 0;
    signal idx_d : integer range 0 to 15 := 0;

    signal r13top : std_logic_vector(7 downto 0) := (others => '0');
    signal r14top : std_logic_vector(7 downto 0) := (others => '0');
    signal r15top : std_logic_vector(7 downto 0) := (others => '0');

begin

    regdebug <= rf;

    idx_o <= to_integer(unsigned(in1));
    idx_d <= to_integer(unsigned(in2));

    reg_rw_ctrl : process (clk, rst_n, stackctrl, pcctrl, alu) is
        variable pc_int : std_logic_vector(9 downto 0) := (others => '0');
    begin
        if (rst_n = '0') then
            rf <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if (stackctrl = "10") then
                rf(13) <= r13top;
                rf(14) <= r14top;
                rf(15) <= r15top;
            else
                if (rw = '1') then
                    if (idx_d = 13) then
                        pc_int := rf(14)(3 downto 2) & alu;
                    elsif (idx_d = 14) then
                        rf(14)(7 downto 2) <= alu(7 downto 2);
                        pc_int(9 downto 8) := rf(14)(1 downto 0);
                    else
                        rf(idx_d) <= alu;
                    end if;
                end if;

                if (idx_d /= 15) then
                    if (flctrl(2) = '1') then -- update Z flag
                        rf(15)(7) <= flags(2);
                    end if;

                    if (flctrl(1) = '1') then -- update C flag
                        rf(15)(6) <= flags(1);
                    end if;

                    if (flctrl(0) = '1') then -- update V_P flag
                        rf(15)(5) <= flags(0);
                    end if;
                end if;

                if (pcctrl = "01") then            -- increment pc
                    pc_int := rf(14)(1 downto 0) & rf(13)(7 downto 0);
                    pc_int := std_logic_vector(unsigned(pc_int) + 1);
                elsif (pcctrl = "10") then         -- jmp par rd
                    pc_int := addro & rf(idx_d);
                elsif (pcctrl = "11") then         -- jmp par (rd) or jmp (end)
                    pc_int := addro & alu;
                end if;

                rf(13)(7 downto 0) <= pc_int(7 downto 0);
                rf(14)(1 downto 0) <= pc_int(9 downto 8);
            end if;
        end if;
    end process;

    process (clk, rst_n, counter, stackctrl) is
    begin
        if (rst_n = '0') then
            counter <= 0;
        elsif (rising_edge(clk)) then
            if (stackctrl = "01") then
                r13stack(top) <= rf(13);
                r14stack(top) <= rf(14);
                r15stack(top) <= rf(15);
                if (counter < 3) then
                    counter <= counter + 1;
                end if;
            elsif (stackctrl = "10") then
                if (counter > 0) then
                    counter <= counter - 1;
                end if;
            end if;
        end if;
        if (counter > 0) then
            top <= counter-1;
        end if;
    end process;

    r13top <= r13stack(top);
    r14top <= r14stack(top);
    r15top <= r15stack(top);

    ro  <= rf(idx_o);
    rd  <= rf(idx_d);
    r13 <= rf(13);
    r14 <= rf(14);
    r15 <= rf(15);
    pc  <= rf(14)(1 downto 0) & rf(13)(7 downto 0);

end architecture;
