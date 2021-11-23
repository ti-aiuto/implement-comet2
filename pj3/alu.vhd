library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		OPERATION_TYPE : in std_logic_vector(1 downto 0); -- 00:ADDSUBCP, 01: LOGICAL, 10: SHIFT
		OP_ARITHMETIC_CALC_OPTIONS: in std_logic_vector(1 downto 0); -- LOGICAL_MODE, SUB_FLAG
		OP_LOGICAL_CALC_OPTIONS: in std_logic_vector(1 downto 0); -- 00: AND, 01: OR, 10: XOR
		OP_SHIFT_CALC_OPTIONS: in std_logic_vector(1 downto 0); -- LOGICAL_MODE, RIGHT_FLAG
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end alu;

architecture RTL of alu is

component multiplexer_16bit_4ways is
	port(
		SELECTOR : in std_logic_vector(1 downto 0);
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_IN_3 : in std_logic_vector(15 downto 0);
		DATA_IN_4 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

component multiplexer_1bit_4ways is
	port(
		SELECTOR : in std_logic_vector(1 downto 0);
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_IN_3 : in std_logic;
		DATA_IN_4 : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

component alu_arithmetic_calc is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		OPTIONS : in std_logic_vector(1 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

component alu_logical_calc is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		OPTIONS : in std_logic_vector(1 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

component alu_shift_calc is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		OPTIONS : in std_logic_vector(1 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

signal DATA_OUT_ARITHMETIC: std_logic_vector(15 downto 0);
signal DATA_OUT_LOGICAL_CALC: std_logic_vector(15 downto 0);
signal DATA_OUT_SHIFT: std_logic_vector(15 downto 0);

signal OF_OUT_ARITHMETIC: std_logic;
signal OF_OUT_LOGICAL_CALC: std_logic;
signal OF_OUT_SHIFT: std_logic;

begin
	ARITH_INSTANCE: alu_arithmetic_calc port map(
		DATA_IN_A => DATA_IN_A, 
		DATA_IN_B => DATA_IN_B, 
		OPTIONS => OP_ARITHMETIC_CALC_OPTIONS, 
		DATA_OUT => DATA_OUT_ARITHMETIC, 
		OF_OUT => OF_OUT_ARITHMETIC
	);
	
	LOGICAL_INSTANCE: alu_logical_calc port map(
		DATA_IN_A => DATA_IN_A, 
		DATA_IN_B => DATA_IN_B, 
		OPTIONS => OP_LOGICAL_CALC_OPTIONS, 
		DATA_OUT => DATA_OUT_LOGICAL_CALC, 
		OF_OUT => OF_OUT_LOGICAL_CALC
	);
	
	SHIFT_INSTANCE: alu_shift_calc port map(
		DATA_IN_A => DATA_IN_A, 
		DATA_IN_B => DATA_IN_B, 
		OPTIONS => OP_SHIFT_CALC_OPTIONS, 
		DATA_OUT => DATA_OUT_SHIFT, 
		OF_OUT => OF_OUT_SHIFT
	);
	
	MX4: multiplexer_16bit_4ways port map(
		SELECTOR => OPERATION_TYPE, 
		DATA_IN_1 => DATA_OUT_ARITHMETIC, 
		DATA_IN_2 => DATA_OUT_LOGICAL_CALC, 
		DATA_IN_3 => DATA_OUT_SHIFT, 
		DATA_IN_4 => "0000000000000000",
		DATA_OUT => DATA_OUT
	);
	
	MX1: multiplexer_1bit_4ways port map(
		SELECTOR => OPERATION_TYPE, 
		DATA_IN_1 => OF_OUT_ARITHMETIC, 
		DATA_IN_2 => OF_OUT_LOGICAL_CALC, 
		DATA_IN_3 => OF_OUT_SHIFT, 
		DATA_IN_4 => '0',
		DATA_OUT => OF_OUT
	);
end RTL;

