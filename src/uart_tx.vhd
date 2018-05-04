---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
-- 
-- Creation Date : 27/03/2018
-- File          : uart_tx.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity uart_tx is
    generic (
        CLKS_PER_BIT : integer := 434 -- 50MHz / 115200 (baud rate)
    );
    port (
        clk         : in std_logic;
        new_data    : in std_logic;
        in_byte     : in std_logic_vector(7 downto 0); -- parallel input
        busy        : out std_logic;
        done        : out std_logic;
        tx_out      : out std_logic                    -- serial output
    );
end entity;


---------------------------------------------------------------------------
architecture behavioral of uart_tx is

    type tx_state_t is (IDLE, START_BIT, DATA_BITS, STOP_BIT);

    signal state : tx_state_t := IDLE;

    signal counter : integer range 0 to CLKS_PER_BIT := 0;
    signal idx : integer range 0 to 7 := 0;

    -- register the input so that data won't change during the process
    signal in_byte_reg : std_logic_vector(7 downto 0) := (others => '0');

begin
    
    process (clk)
    begin
        if (rising_edge(clk)) then
            case (state) is
                when IDLE =>
                    busy <= '0';
                    done <= '0';
                    tx_out <= '1'; -- idle line is high
                    counter <= 0;
                    idx <= 0;

                    if (new_data = '1') then
                        in_byte_reg <= in_byte;
                        state <= START_BIT;
                    else
                        state <= IDLE;
                    end if;
                when START_BIT =>
                    busy <= '1';
                    tx_out <= '0';

                    if (counter < CLKS_PER_BIT) then
                        counter <= counter + 1;
                        state <= START_BIT;
                    else
                        counter <= 0;
                        state <= DATA_BITS;
                    end if;
                when DATA_BITS =>
                    tx_out <= in_byte_reg(idx);

                    if (counter < CLKS_PER_BIT) then
                        counter <= counter + 1;
                        state <= DATA_BITS;
                    else
                        counter <= 0;
                        if (idx < 7) then
                            idx <= idx + 1;
                            state <= DATA_BITS;
                        else
                            counter <= 0;
                            state <= STOP_BIT;
                        end if;
                    end if;

                when STOP_BIT =>
                    tx_out <= '1';
                    
                    if (counter < CLKS_PER_BIT) then
                        counter <= counter + 1;
                        state <= STOP_BIT;
                    else
                        busy <= '0';
                        done <= '1';
                        state <= IDLE;
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end architecture;

