library IEEE;
use IEEE.std_logic_1164.all;

entity alu_logical_calc is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		OPERATION : in std_logic_vector(1 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end alu_logical_calc;

architecture RTL of alu_logical_calc is

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

begin
	MX: multiplexer_16bit_4ways port map(
		SELECTOR => OPERATION,
		DATA_IN_1 => DATA_IN_A AND DATA_IN_B, 
		DATA_IN_2 => DATA_IN_A OR DATA_IN_B, 
		DATA_IN_3 => DATA_IN_A XOR DATA_IN_B, 
		DATA_IN_4 => "0000000000000000", 
		DATA_OUT => DATA_OUT
	);
	
	OF_OUT <= '0'; -- 仕様
end RTL;

