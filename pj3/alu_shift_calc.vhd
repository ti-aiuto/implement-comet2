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

signal RIGHT_FLAG : std_logic;
signal LOGICAL_CALC_FLAG : std_logic;

begin
	RIGHT_FLAG <= OPERATION(0);
	LOGICAL_CALC_FLAG <= OPERATION(1);

	
end RTL;

