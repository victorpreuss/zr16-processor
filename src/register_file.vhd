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
use std.textio.all;

---------------------------------------------------------------------------
entity register_file is
    port (
        clk     : in std_logic;
        rw      : in std_logic;                    -- read = '0' / write = '1'
        addro   : in std_logic_vector(1 downto 0); -- bits 9:8 of instruction
        pcctrl  : in std_logic_vector(2 downto 0);
        in1     : in std_logic_vector(3 downto 0); -- origin register
        in2     : in std_logic_vector(3 downto 0); -- destination register
        alu     : in std_logic_vector(7 downto 0); -- alu data
        flags   : in std_logic_vector(2 downto 0);
        flctrl  : in std_logic; -- flag to overwrite register flags with alu
        ro      : out std_logic_vector(7 downto 0);
        rd      : out std_logic_vector(7 downto 0);
        r13     : out std_logic_vector(7 downto 0);
        r14     : out std_logic_vector(7 downto 0);
        r15     : out std_logic_vector(7 downto 0);
        pc      : out std_logic_vector(9 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture arch of register_file is

    subtype register_t is std_logic_vector(7 downto 0);
    type register_file_t is array(0 to 15) of register_t;

    signal rf : register_file_t := (others => (others => '0'));

    signal idx_o : integer := 0;
    signal idx_d : integer := 0;

    signal pc_int : std_logic_vector(9 downto 0) := (others => '0');

begin

    idx_o <= to_integer(unsigned(in1));
    idx_d <= to_integer(unsigned(in2));

    reg_rw_ctrl : process (clk) is
        variable L : line;
    begin
        if rising_edge(clk) then
            if (rw = '1') then -- write
                rf(idx_d) <= alu;
            end if;

            if (flctrl = '1') then
                rf(15)(7 downto 5) <= flags;
            end if;

            write(L, string'("Register Content"));
            writeline(output, L);
            hwrite(L, rf(0));
            writeline(output, L);
            hwrite(L, rf(1));
            writeline(output, L);
            hwrite(L, rf(2));
            writeline(output, L);

        end if;
    end process;

    pc_ctrl : process (clk) is
    begin
        if (rising_edge(clk)) then
            if (pcctrl = "001") then            -- increment pc
                pc_int <= std_logic_vector(unsigned(pc_int) + 1);
            elsif (pcctrl = "010") then         -- jmp par rd
                pc_int <= addro & rf(idx_d);
            elsif (pcctrl = "100") then         -- jmp par (rd)
                pc_int <= addro & alu;
            elsif (pcctrl = "101") then         -- jmp end
                pc_int <= addro & in2 & in1;
            else
                pc_int <= pc_int;
            end if;
        end if;
    end process;

    ro  <= rf(idx_o);
    rd  <= rf(idx_d);
    r13 <= rf(13);
    r14 <= rf(14);
    r15 <= rf(15);
    pc  <= pc_int;

end architecture;
