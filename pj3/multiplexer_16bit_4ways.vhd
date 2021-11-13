library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer_16bit_4ways is
	port(
		SELECTOR : in std_logic_vector(1 downto 0);
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_IN_3 : in std_logic_vector(15 downto 0);
		DATA_IN_4 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end multiplexer_16bit_4ways;

architecture RTL of multiplexer_16bit_4ways is

component multiplexer_16bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

signal MX1_OUT : std_logic_vector(15 downto 0);
signal MX2_OUT : std_logic_vector(15 downto 0);

begin
	MX1 : multiplexer_16bit_2ways port map(
	SELECTOR => SELECTOR(0),
	DATA_IN_1 => DATA_IN_1, 
	DATA_IN_2 => DATA_IN_2, 
	DATA_OUT => MX1_OUT);
	
	MX2 : multiplexer_16bit_2ways port map(
	SELECTOR => SELECTOR(0),
	DATA_IN_1 => DATA_IN_3, 
	DATA_IN_2 => DATA_IN_4, 
	DATA_OUT => MX2_OUT);
	
	MX_JOIN : multiplexer_16bit_2ways port map(
	SELECTOR => SELECTOR(1), 
	DATA_IN_1 => MX1_OUT, 
	DATA_IN_2 => MX2_OUT,
	DATA_OUT => DATA_OUT
	);
end RTL;
