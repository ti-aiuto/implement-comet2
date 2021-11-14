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

type MEMORY is array (0 to 31) of WORD;

constant MEM : MEMORY := 
	(
		"0001001000100000", -- LAD GR2 0
		"0000000000000000", 
		"0001010000010010", -- LD GR1 GR2
		"0000000000000010", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000", 
		"0000000000000000"
	);

begin 
	PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
end RTL;
