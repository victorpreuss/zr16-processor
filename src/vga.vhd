---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 02/04/2018
-- File          : vga.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity vga is
    generic (
        h_pixels    : integer;
        h_bp        : integer;
        h_fp        : integer;
        h_pulse     : integer;
        v_pixels    : integer;
        v_bp        : integer;
        v_fp        : integer;
        v_pulse     : integer
    );
    port (
        clk         : in std_logic;
        rst_n       : in std_logic;
        h_sync      : out std_logic;
        v_sync      : out std_logic;
        enabled     : out std_logic;
        col         : out integer;
        row         : out integer
    );
end entity;

--------------------------------------------------------------------------
architecture behavioral of vga is

    constant h_length : integer := h_pixels + h_bp + h_pulse + h_fp;
    constant v_length : integer := v_pixels + v_bp + v_pulse + v_fp;

begin

    vga_process : process (clk, rst_n) is

        variable h_count : integer range 0 to h_length-1 := 0;
        variable v_count : integer range 0 to v_length-1 := 0;

    begin
        if (rst_n = '0') then
            h_count := 0;
            v_count := 0;
            h_sync <= '0';
            v_sync <= '0';
            enabled <= '0';
            col <= 0;
            row <= 0;
        elsif (rising_edge(clk)) then
            
            -- h_sync and v_sync counters
            if (h_count < h_length-1) then
                h_count := h_count + 1;
            else
                h_count := 0;
                if (v_count < v_length-1) then
                    v_count := v_count + 1;
                else
                    v_count := 0;
                end if;
            end if;

            -- check h_sync region to set level
            if ((h_count < h_pixels + h_fp) or (h_count >= h_pixels + h_fp + h_pulse)) then
                h_sync <= '1';
            else
                h_sync <= '0';
            end if;

            -- check v_sync region to set level
            if ((v_count < v_pixels + v_fp) or (v_count >= v_pixels + v_fp + v_pulse)) then
                v_sync <= '1';
            else
                v_sync <= '0';
            end if;

            if (h_count < h_pixels) then
                col <= h_count;
            end if;

            if (v_count < v_pixels) then
                row <= v_count;
            end if;

            if ((h_count < h_pixels) and (v_count < v_pixels)) then
                enabled <= '1';
            else
                enabled <= '0';
            end if;
        end if;
    end process;

end architecture;

