library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer_1bit_4ways is
	port(
		SELECTOR : in std_logic_vector(1 downto 0);
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_IN_3 : in std_logic;
		DATA_IN_4 : in std_logic;
		DATA_OUT : out std_logic
	);
end multiplexer_1bit_4ways;

architecture RTL of multiplexer_1bit_4ways is

component multiplexer_1bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

signal MX1_OUT : std_logic;
signal MX2_OUT : std_logic;

begin
	MX1 : multiplexer_1bit_2ways port map(
	SELECTOR => SELECTOR(0),
	DATA_IN_1 => DATA_IN_1, 
	DATA_IN_2 => DATA_IN_2, 
	DATA_OUT => MX1_OUT);
	
	MX2 : multiplexer_1bit_2ways port map(
	SELECTOR => SELECTOR(0),
	DATA_IN_1 => DATA_IN_3, 
	DATA_IN_2 => DATA_IN_4, 
	DATA_OUT => MX2_OUT);
	
	MX_JOIN : multiplexer_1bit_2ways port map(
	SELECTOR => SELECTOR(1), 
	DATA_IN_1 => MX1_OUT, 
	DATA_IN_2 => MX2_OUT,
	DATA_OUT => DATA_OUT
	);
end RTL;
