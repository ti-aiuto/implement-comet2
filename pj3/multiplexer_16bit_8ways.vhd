library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer_16bit_8ways is
	port(
		SELECTOR : in std_logic_vector(2 downto 0);
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_IN_3 : in std_logic_vector(15 downto 0);
		DATA_IN_4 : in std_logic_vector(15 downto 0);
		DATA_IN_5 : in std_logic_vector(15 downto 0);
		DATA_IN_6 : in std_logic_vector(15 downto 0);
		DATA_IN_7 : in std_logic_vector(15 downto 0);
		DATA_IN_8 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end multiplexer_16bit_8ways;

architecture RTL of multiplexer_16bit_8ways is

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
	MX1 : multiplexer_16bit_4ways port map(
	SELECTOR => SELECTOR(1 downto 0),
	DATA_IN_1 => DATA_IN_1, 
	DATA_IN_2 => DATA_IN_2, 
	DATA_IN_3 => DATA_IN_3, 
	DATA_IN_4 => DATA_IN_4, 
	DATA_OUT => MX1_OUT);
	
	MX2 : multiplexer_16bit_4ways port map(
	SELECTOR => SELECTOR(1 downto 0),
	DATA_IN_1 => DATA_IN_5, 
	DATA_IN_2 => DATA_IN_6, 
	DATA_IN_3 => DATA_IN_7, 
	DATA_IN_4 => DATA_IN_8, 
	DATA_OUT => MX2_OUT);
	
	MX_JOIN : multiplexer_16bit_2ways port map(
	SELECTOR => SELECTOR(2), 
	DATA_IN_1 => MX1_OUT, 
	DATA_IN_2 => MX2_OUT,
	DATA_OUT => DATA_OUT
	);
end RTL;
