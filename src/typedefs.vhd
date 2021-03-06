---------------------------------------------------------------------------
-- Company     : Universidade Federal de Santa Catarina
-- Author(s)   : Victor H B Preuss
--
-- Creation Date : 04/05/2018
-- File          : typedefs.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
package typedefs is

    subtype byte_t is std_logic_vector(7 downto 0);
    type bytearray_t is array(natural range <>) of byte_t;

    type aluop_t is (ALU_WIRE, ALU_ADD, ALU_SUB, ALU_INC, ALU_DEC,
                     ALU_AND, ALU_OR, ALU_XOR, ALU_ROT, ALU_SHL, ALU_SHA);

    component rom is
    generic (
        DATA_SIZE : integer;
        ADDR_SIZE : integer;
        MEM_SIZE  : integer
    );
    port (
        addr    : in std_logic_vector(ADDR_SIZE-1 downto 0);
        data    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
    end component;

    component mux4_rom is
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

    component instruction_register is
    port (
        clk         : in std_logic;
        rst_n       : in std_logic;
        en          : in std_logic;
        romdata     : in std_logic_vector(15 downto 0);
        instruction : out std_logic_vector(15 downto 0)
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
        clk       : in std_logic;
        rst_n     : in std_logic;
        rw        : in std_logic;
        addro     : in std_logic_vector(1 downto 0);
        pcctrl    : in std_logic_vector(1 downto 0);
        stackctrl : in std_logic_vector(1 downto 0);
        in1       : in std_logic_vector(3 downto 0);
        in2       : in std_logic_vector(3 downto 0);
        alu       : in std_logic_vector(7 downto 0);
        flags     : in std_logic_vector(2 downto 0);
        flctrl    : in std_logic_vector(2 downto 0);
        ro        : out std_logic_vector(7 downto 0);
        rd        : out std_logic_vector(7 downto 0);
        r13       : out std_logic_vector(7 downto 0);
        r14       : out std_logic_vector(7 downto 0);
        r15       : out std_logic_vector(7 downto 0);
        pc        : out std_logic_vector(9 downto 0);
        regdebug  : out bytearray_t(15 downto 0)
    );
    end component;

    component alu is
    port (
        op      : in aluop_t;
        Cin     : in std_logic;
        uc      : in std_logic;
        ed      : in std_logic;
        in1     : in std_logic_vector(7 downto 0);
        in2     : in std_logic_vector(7 downto 0);
        out1    : out std_logic_vector(7 downto 0);
        Z       : out std_logic;
        Cout    : out std_logic;
        V_P     : out std_logic
    );
    end component;

    component control_unit is
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
    end component;

    component ram is
    port (
        clk      : in std_logic;
        rst_n    : in std_logic;
        rw       : in std_logic;
        addr     : in std_logic_vector(7 downto 0);
        datain   : in std_logic_vector(7 downto 0);
        dataout  : out std_logic_vector(7 downto 0);
        ramdebug : out bytearray_t(255 downto 0)
    );
    end component;

end typedefs;

---------------------------------------------------------------------------
package body typedefs is
end typedefs;
