library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer_16bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end multiplexer_16bit_2ways;

architecture RTL of multiplexer_16bit_2ways is

component multiplexer_1bit_2ways
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

begin
	MX1 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(0), 
	DATA_IN_2 => DATA_IN_2(0), 
	DATA_OUT => DATA_OUT(0));

	MX2 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(1), 
	DATA_IN_2 => DATA_IN_2(1), 
	DATA_OUT => DATA_OUT(1));

	MX3 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(2), 
	DATA_IN_2 => DATA_IN_2(2), 
	DATA_OUT => DATA_OUT(2));

	MX4 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(3), 
	DATA_IN_2 => DATA_IN_2(3), 
	DATA_OUT => DATA_OUT(3));

	MX5 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(4), 
	DATA_IN_2 => DATA_IN_2(4), 
	DATA_OUT => DATA_OUT(4));

	MX6 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(5), 
	DATA_IN_2 => DATA_IN_2(5), 
	DATA_OUT => DATA_OUT(5));

	MX7 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(6), 
	DATA_IN_2 => DATA_IN_2(6), 
	DATA_OUT => DATA_OUT(6));

	MX8 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(7), 
	DATA_IN_2 => DATA_IN_2(7), 
	DATA_OUT => DATA_OUT(7));

	MX9 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(8), 
	DATA_IN_2 => DATA_IN_2(8), 
	DATA_OUT => DATA_OUT(8));

	MX10 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(9), 
	DATA_IN_2 => DATA_IN_2(9), 
	DATA_OUT => DATA_OUT(9));

	MX11 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(10), 
	DATA_IN_2 => DATA_IN_2(10), 
	DATA_OUT => DATA_OUT(10));

	MX12 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(11), 
	DATA_IN_2 => DATA_IN_2(11), 
	DATA_OUT => DATA_OUT(11));

	MX13 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(12), 
	DATA_IN_2 => DATA_IN_2(12), 
	DATA_OUT => DATA_OUT(12));

	MX14 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(13), 
	DATA_IN_2 => DATA_IN_2(13), 
	DATA_OUT => DATA_OUT(13));

	MX15 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(14), 
	DATA_IN_2 => DATA_IN_2(14), 
	DATA_OUT => DATA_OUT(14));

	MX16 : multiplexer_1bit_2ways port map(SELECTOR => SELECTOR, 
	DATA_IN_1 => DATA_IN_1(15), 
	DATA_IN_2 => DATA_IN_2(15), 
	DATA_OUT => DATA_OUT(15));
end RTL;
