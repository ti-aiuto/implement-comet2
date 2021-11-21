library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		SUB_FLAG : in std_logic;
		LOGICAL_CALC_FLAG : in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end alu;

architecture RTL of alu is

component multiplexer_16bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

component adder_16bit is
	port(
		CI : in std_logic;
		AIN : in std_logic_vector(15 downto 0);
		BIN : in std_logic_vector(15 downto 0);
		SUM : out std_logic_vector(16 downto 0)
	);
end component;

component multiplexer_1bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

signal DATA_B_OR_NEGATED_DATA_B : std_logic_vector(15 downto 0);

signal INTERNAL_ADD_SUB_DATA : std_logic_vector(15 downto 0);
signal INTERNAL_LOGICAL_OF: std_logic;
signal INTERNAL_ARITHMETIC_OF: std_logic;

signal DATA_A_FLAG : std_logic;
signal DATA_B_FLAG : std_logic;

begin
	MX_NEGATE_DATAB : multiplexer_16bit_2ways port map( 
		SELECTOR => SUB_FLAG, 
		DATA_IN_1 => DATA_IN_B, 
		DATA_IN_2 => NOT DATA_IN_B, 
		DATA_OUT => DATA_B_OR_NEGATED_DATA_B
	);
	
	ALU_ADDER : adder_16bit port map( 
		CI => SUB_FLAG, 
		AIN => DATA_IN_A, 
		BIN => DATA_B_OR_NEGATED_DATA_B, 
		SUM(15 downto 0) => INTERNAL_ADD_SUB_DATA, 
		SUM(16) => INTERNAL_LOGICAL_OF
	);

	DATA_A_FLAG <= DATA_IN_A(15);
	DATA_B_FLAG <= DATA_IN_B(15) xor SUB_FLAG; -- 負数かつ加算、正数かつ減算のとき1
	INTERNAL_ARITHMETIC_OF <= NOT(DATA_A_FLAG XOR DATA_B_FLAG) -- 正負が同じかつ
		AND (DATA_A_FLAG XOR INTERNAL_ADD_SUB_DATA(15)); -- 正負が変わっているときあふれ

	OF_SELECTOR : multiplexer_1bit_2ways port map(
		SELECTOR => LOGICAL_CALC_FLAG, 
		DATA_IN_1 => INTERNAL_ARITHMETIC_OF, 
		DATA_IN_2 => INTERNAL_LOGICAL_OF, 
		DATA_OUT => OF_OUT
	);

	DATA_OUT <= INTERNAL_ADD_SUB_DATA;
end RTL;

