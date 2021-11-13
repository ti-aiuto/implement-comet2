library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer_1bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_OUT : out std_logic
	);
end multiplexer_1bit_2ways;

architecture RTL of multiplexer_1bit_2ways is

begin
	DATA_OUT <= (DATA_IN_1 and SELECTOR) or (DATA_IN_2 and not SELECTOR);
end RTL;
