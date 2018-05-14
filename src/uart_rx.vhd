---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 26/03/2018
-- File          : uart_rx.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity uart_rx is
    generic (
        CLKS_PER_BIT : integer := 434 -- 50MHz / 115200 (baud rate)
    );
    port (
        clk         : in std_logic;
        rx          : in std_logic;
        new_data    : out std_logic;
        data        : out std_logic_vector(7 downto 0)
    );
end entity;

---------------------------------------------------------------------------
architecture behavioral of uart_rx is

    type rx_state_t is (IDLE, WAIT_HALF, WAIT_BIT, WAIT_STOP);

    signal state : rx_state_t := IDLE;

    signal counter : integer range 0 to CLKS_PER_BIT := 0;
    signal idx : integer range 0 to 7 := 0;

    signal data_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal new_data_reg : std_logic := '0';

begin

    uart_rx_sm : process (clk)
    begin
        if (rising_edge(clk)) then
            case (state) is
                when IDLE =>
                    new_data_reg <= '0';
                    counter <= 0;
                    idx <= 0;

                    if (rx = '0') then
                        state <= WAIT_HALF;
                    else
                        state <= IDLE;
                    end if;
                when WAIT_HALF =>
                    if (counter = CLKS_PER_BIT/2) then
                        if (rx = '0') then
                            counter <= 0;
                            state <= WAIT_BIT;
                        else
                            state <= IDLE;
                        end if;
                    else
                        counter <= counter + 1;
                        state <= WAIT_HALF;
                    end if;
                when WAIT_BIT =>
                    if (counter < CLKS_PER_BIT) then
                        counter <= counter + 1;
                        state <= WAIT_BIT;
                    else
                        counter <= 0;
                        data_reg(idx) <= rx;
                        if (idx < 7) then
                            idx <= idx + 1;
                            state <= WAIT_BIT;
                        else
                            idx <= 0;
                            state <= WAIT_STOP;
                        end if;
                    end if;
                when WAIT_STOP =>
                    if (counter < CLKS_PER_BIT) then
                        counter <= counter + 1;
                        state <= WAIT_STOP;
                    else
                        new_data_reg <= '1';
                        counter <= 0;
                        state <= IDLE;
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

    new_data <= new_data_reg;
    data <= data_reg;

end architecture;

