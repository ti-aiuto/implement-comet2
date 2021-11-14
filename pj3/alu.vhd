library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		SUB_FLAG : in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end alu;

architecture RTL of alu is

component not_16bit is
	port( 
	DATA_IN : in std_logic_vector(15 downto 0); 
	DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

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

signal SET_ALU_ADDER_CI_FLAG : std_logic;
signal DATA_B_NEGATED : std_logic_vector(15 downto 0);
signal USE_NEGATED_DATAB_FLAG: std_logic;
signal DATA_B_OR_NEGATED_DATA_B : std_logic_vector(15 downto 0);

begin
	-- 引き算
	USE_NEGATED_DATAB_FLAG <= SUB_FLAG;
	SET_ALU_ADDER_CI_FLAG <= SUB_FLAG;
	
	NOT_NEGATE_DATAB : not_16bit port map(DATA_IN => DATA_IN_B, DATA_OUT => DATA_B_NEGATED);
	
	MX_NEGATE_DATAB : multiplexer_16bit_2ways port map( SELECTOR => USE_NEGATED_DATAB_FLAG, 
	DATA_IN_1 => DATA_IN_B, 
	DATA_IN_2 => DATA_B_NEGATED, 
	DATA_OUT => DATA_B_OR_NEGATED_DATA_B);
	
	ALU_ADDER : adder_16bit port map( CI => SET_ALU_ADDER_CI_FLAG, 
	AIN => DATA_IN_A, 
	BIN => DATA_B_OR_NEGATED_DATA_B, 
	SUM(15 downto 0) => DATA_OUT); -- TODO: ここでOFとかのセット必要

	OF_OUT <= '0'; -- TODO: set
end RTL;

