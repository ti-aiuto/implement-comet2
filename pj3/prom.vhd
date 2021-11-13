library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity prom is
	port(
		P_COUNT : in std_logic_vector(15 downto 0);
		PROM_OUT : out std_logic_vector(15 downto 0)
	);
end prom;

architecture RTL of prom is

subtype WORD is std_logic_vector(0 to 15);

type MEMORY is array (0 to 15) of WORD;

constant MEM : MEMORY := 
	(
		"0000000000000001", 
		"0000000000000011", 
		"0000000000000111", 
		"0000000000001111", 
		"0000000000011111",
		"0000000000111111", 
		"0000000001111111", 
		"0000000011111111", 
		"0000000111111111",
		"0000001111111111", 
		"0000011111111111", 
		"0000111111111111", 
		"0001111111111111",
		"0011111111111111", 
		"0111111111111111", 
		"1111111111111111"
	);

begin 
	PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
end RTL;
