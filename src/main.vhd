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
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;

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

    component rom is
    generic (
        DATA_SIZE : integer;
        ADDR_SIZE : integer;
        MEM_SIZE  : integer
    );
    port (
        clk     : in std_logic;
        addr    : in std_logic_vector(ADDR_SIZE-1 downto 0);
        data    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
    end component;
    
    component mux2 is
    generic (
        LENGTH : integer
    );
    port (
        ctrl : in std_logic;
        in1  : in std_logic_vector(LENGTH-1 downto 0);
        in2  : in std_logic_vector(LENGTH-1 downto 0);
        out1 : out std_logic_vector(LENGTH-1 downto 0)
    );
    end component;

    component mux4 is
    generic (
        LENGTH : integer
    );
    port (
        ctrl : in std_logic_vector(1 downto 0);
        in1  : in std_logic_vector(LENGTH-1 downto 0);
        in2  : in std_logic_vector(LENGTH-1 downto 0);
        in3  : in std_logic_vector(LENGTH-1 downto 0);
        in4  : in std_logic_vector(LENGTH-1 downto 0);
        out1 : out std_logic_vector(LENGTH-1 downto 0)
    );
    end component;
    
    component mux8 is
    generic (
        LENGTH : integer
    );
    port (
        ctrl : in std_logic_vector(2 downto 0);
        in1  : in std_logic_vector(LENGTH-1 downto 0);
        in2  : in std_logic_vector(LENGTH-1 downto 0);
        in3  : in std_logic_vector(LENGTH-1 downto 0);
        in4  : in std_logic_vector(LENGTH-1 downto 0);
        in5  : in std_logic_vector(LENGTH-1 downto 0);
        in6  : in std_logic_vector(LENGTH-1 downto 0);
        in7  : in std_logic_vector(LENGTH-1 downto 0);
        in8  : in std_logic_vector(LENGTH-1 downto 0);
        out1 : out std_logic_vector(LENGTH-1 downto 0)
    );   
    end component;

    component register_file is
    port (
        clk     : in std_logic;
        rw      : in std_logic;
        addro   : in std_logic_vector(1 downto 0);
        pcctrl  : in std_logic_vector(2 downto 0);
        in1     : in std_logic_vector(3 downto 0);
        in2     : in std_logic_vector(3 downto 0);
        alu     : in std_logic_vector(7 downto 0);
        ro      : out std_logic_vector(7 downto 0);
        rd      : out std_logic_vector(7 downto 0);
        r13     : out std_logic_vector(7 downto 0);
        r14     : out std_logic_vector(7 downto 0);
        r15     : out std_logic_vector(7 downto 0);
        pc      : out std_logic_vector(9 downto 0)
    );
    end component;

    -- the rom memory is 1024x16 and the addresses are 10 bits long
    constant ROM_ADDR   : integer := 10;
    constant ROM_DATA   : integer := 16;
    constant ROM_SIZE   : integer := 1024;

    -- opcodes
    constant JMP  : std_logic_vector(3 downto 0) := "0000"; 
    constant ADD  : std_logic_vector(3 downto 0) := "1000";
    constant MOV  : std_logic_vector(3 downto 0) := "1101"; 

    -- clock
    signal clk : std_logic := '0';
    
    -- rom inputs
    signal romaddr : std_logic_vector(9 downto 0) := (others => '0');
    signal romdata : std_logic_vector(15 downto 0) := (others => '0');

    -- control signals
    signal romctrl : std_logic_vector(1 downto 0) := "00";
    signal pcctrl  : std_logic_vector(2 downto 0) := "000";
    signal ramrw   : std_logic := '0'; -- RAM R/W flag
    signal regrw   : std_logic := '0'; -- registers R/W flag
    signal aluoctrl : std_logic_vector(2 downto 0) := (others => '0');
    signal aludctrl : std_logic := '0';
    
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
    signal pc  : std_logic_vector(9 downto 0) := (others => '0');
    signal r13 : std_logic_vector(7 downto 0) := (others => '0');
    signal r14 : std_logic_vector(7 downto 0) := (others => '0');
    signal r15 : std_logic_vector(7 downto 0) := (others => '0');
    signal ro  : std_logic_vector(7 downto 0) := (others => '0');
    signal rd  : std_logic_vector(7 downto 0) := (others => '0');

    -- flags of control registers
    alias rompartition : std_logic_vector(2 downto 0) is r14(6 downto 4);

    -- alu signals
    signal aluin1 : std_logic_vector(7 downto 0) := (others => '0');
    signal aluin2 : std_logic_vector(7 downto 0) := (others => '0');

    signal aluout : std_logic_vector(7 downto 0) := (others => '0');
    
    -- control unit state machine
    type state_t is (RESET, FETCH_1, FETCH_2, DECODE, MOV_1, MOV_2, ADD_1, ADD_2, JMP_1, JMP_2, HALT);
    signal state : state_t := RESET;

begin

    clk_inst : clk_gen
    port map (
        clk => clk
    );

    rom_inst : rom generic map(ROM_DATA, ROM_ADDR, ROM_SIZE)
    port map (
        clk  => clk,
        addr => romaddr,
        data => romdata
    );

    mux_rom_inst : mux4 generic map(ROM_ADDR)
    port map (
        ctrl     => romctrl,
        in1      => pc,                                  -- pc register
        --in2      => rompartition & memaddr(7 downto 1),  -- in case of a MOV r0, (end)
        --in3      => rompartition & ro,                   -- in case of a MOV rd, (ro)
        in2      => (others => '0'),
        in3      => (others => '0'),
        in4      => (others => '0'), -- nothing
        out1     => romaddr
    );

    registers_inst : register_file
    port map (
        clk     => clk,
        rw      => regrw,
        addro   => addrmodeo,
        pcctrl  => pcctrl,
        in1     => orig,
        in2     => dest,
        alu     => aluout,
        ro      => ro,
        rd      => rd,
        r13     => r13,
        r14     => r14,
        r15     => r15,
        pc      => pc
    );

    mux_alu_o_inst : mux8 generic map(8)
    port map (
        ctrl    => aluoctrl,
        in1     => immed,
        in2     => romdata(15 downto 8),
        in3     => romdata(7 downto 0),
        in4     => (others => '0'), -- TODO: RAM input
        in5     => ro,
        in6     => (others => '0'), -- nothing
        in7     => (others => '0'), -- nothing
        in8     => (others => '0'), -- nothing
        out1    => aluin1
    );

    mux_alu_d_inst : mux2 generic map(8)
    port map (
        ctrl    => aludctrl,
        in1     => (others => '0'), -- TODO: RAM input
        in2     => rd,
        out1    => aluin2
    );

    stimulus : process (clk) is
  
        variable L : line;

    begin
        if (rising_edge(clk)) then
            case (state) is
                when RESET =>
                    
                    -- TODO: reset ram, registers and control flags
                    state <= FETCH_1;

                when FETCH_1 =>

                    romctrl <= "00";           -- set rom input addr
                    pcctrl <= "001";           -- start pc increment

                    state <= FETCH_2;

                when FETCH_2 =>

                    instruction <= romdata;    -- fetch rom instruction
                    pcctrl <= "000";           -- stop pc increment

                    state <= DECODE;

                when DECODE =>

                    write(L, to_hstring(instruction));
                    writeline(output, L);
                    
                    case (opcode) is
                        when MOV => state <= MOV_1;
                        when ADD => state <= ADD_1;
                        when JMP => state <= JMP_1;
                        when others => state <= HALT;
                    end case;
                
                when MOV_1 =>
                    
                    regrw <= '1';

                    state <= MOV_2;

                when MOV_2 =>

                    regrw <= '0';

                    state <= FETCH_1;

                when ADD_1 =>
                    
                    write(L, to_hstring(ro));
                    writeline(output, L);
                    write(L, to_hstring(rd));
                    writeline(output, L);

                    aluout <= std_logic_vector(unsigned(rd) + unsigned(ro));
                    
                    regrw <= '1';      -- set registers to write 
                    addrmodeo <= "01"; -- writes alu to dest register

                    state <= ADD_2;

                when ADD_2 =>

                    regrw <= '0';      -- set registers back to read mode
                    
                    state <= FETCH_1;

                when JMP_1 =>

                    pcctrl <= "101";   -- set pc to 10 bit value
                    
                    state <= JMP_2;

                when JMP_2 =>
                    
                    romctrl <= "00";   -- send pc to rom
                    
                    state <= FETCH_1;

                when HALT =>
                    state <= RESET;
                when others =>
                    state <= RESET;
            end case;
        end if;
    end process;

end architecture;

