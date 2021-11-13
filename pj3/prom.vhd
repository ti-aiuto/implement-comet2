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
		"0000000100000010", 
		"0000010000001000", 
		"0001000000100000", 
		"0100000010000000",
		"0000000100000011", 
		"0000010100001001", 
		"0001000100100001", 
		"0100000110000001",
		"0000000100000010", 
		"0000010000001000", 
		"0001000000100000", 
		"0100000010000000",
		"0000000100000011", 
		"0000010100001001", 
		"0001000100100001", 
		"0100000110000001"
	);

begin 
	PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
end RTL;
