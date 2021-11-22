library IEEE;
use IEEE.std_logic_1164.all;

entity alu_shift_calc is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		OPERATION : in std_logic_vector(1 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end alu_shift_calc;

architecture RTL of alu_shift_calc is

component shift_1 is
	port(
		DATA_IN: in std_logic_vector(15 downto 0);
		OF_IN: in std_logic;
		ENABLED_FLAG: in std_logic;
		RIGHT_FLAG: in std_logic;
		LOGICAL_CALC_FLAG: in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

component shift_2 is
	port(
		DATA_IN: in std_logic_vector(15 downto 0);
		OF_IN: in std_logic;
		ENABLED_FLAG: in std_logic;
		RIGHT_FLAG: in std_logic;
		LOGICAL_CALC_FLAG: in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

component shift_4 is
	port(
		DATA_IN: in std_logic_vector(15 downto 0);
		OF_IN: in std_logic;
		ENABLED_FLAG: in std_logic;
		RIGHT_FLAG: in std_logic;
		LOGICAL_CALC_FLAG: in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

component shift_8 is
	port(
		DATA_IN: in std_logic_vector(15 downto 0);
		OF_IN: in std_logic;
		ENABLED_FLAG: in std_logic;
		RIGHT_FLAG: in std_logic;
		LOGICAL_CALC_FLAG: in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end component;

signal RIGHT_FLAG : std_logic;
signal LOGICAL_CALC_FLAG : std_logic;

signal SHIFT1_DATA_OUT: std_logic_vector(15 downto 0);
signal SHIFT2_DATA_OUT: std_logic_vector(15 downto 0);
signal SHIFT4_DATA_OUT: std_logic_vector(15 downto 0);

signal SHIFT1_OF_OUT: std_logic;
signal SHIFT2_OF_OUT: std_logic;
signal SHIFT4_OF_OUT: std_logic;

begin
	RIGHT_FLAG <= OPERATION(0);
	LOGICAL_CALC_FLAG <= OPERATION(1);

	SHIFT1_INSTANCE: shift_1 port map(
		DATA_IN => DATA_IN_A, 
		OF_IN => '0', 
		ENABLED_FLAG => DATA_IN_B(0), 
		RIGHT_FLAG => RIGHT_FLAG, 
		LOGICAL_CALC_FLAG => LOGICAL_CALC_FLAG, 
		DATA_OUT => SHIFT1_DATA_OUT, 
		OF_OUT => SHIFT1_OF_OUT
	);
	
	SHIFT2_INSTANCE: shift_2 port map(
		DATA_IN => SHIFT1_DATA_OUT, 
		OF_IN => SHIFT1_OF_OUT, 
		ENABLED_FLAG => DATA_IN_B(1), 
		RIGHT_FLAG => RIGHT_FLAG, 
		LOGICAL_CALC_FLAG => LOGICAL_CALC_FLAG, 
		DATA_OUT => SHIFT2_DATA_OUT, 
		OF_OUT => SHIFT2_OF_OUT
	);
	
	SHIFT4_INSTANCE: shift_4 port map(
		DATA_IN => SHIFT2_DATA_OUT, 
		OF_IN => SHIFT2_OF_OUT, 
		ENABLED_FLAG => DATA_IN_B(2), 
		RIGHT_FLAG => RIGHT_FLAG, 
		LOGICAL_CALC_FLAG => LOGICAL_CALC_FLAG, 
		DATA_OUT => SHIFT4_DATA_OUT, 
		OF_OUT => SHIFT4_OF_OUT
	);
	
	SHIFT8_INSTANCE: shift_8 port map(
		DATA_IN => SHIFT4_DATA_OUT, 
		OF_IN => SHIFT4_OF_OUT, 
		ENABLED_FLAG => DATA_IN_B(3), 
		RIGHT_FLAG => RIGHT_FLAG, 
		LOGICAL_CALC_FLAG => LOGICAL_CALC_FLAG, 
		DATA_OUT => DATA_OUT, 
		OF_OUT => OF_OUT
	);
end RTL;

