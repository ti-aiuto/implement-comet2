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
		"0001001000010000", -- GR1格納
		"0000011111001100", 
		"0001001000100000", -- GR2格納
		"0000001111111110", 
		"0001100000010010", -- LD GR1 GR2
		"0001100000010010", -- LD GR1 GR2
		"0001001000110000", -- LDA GR3 5
		"0000000000000101",
		"0001100000100011", -- LD GR2 GR3
		"0001100000100011", -- LD GR2 GR3
		"0001001000010011", -- LDA GR1 GR3 3
		"0000000000000011", 
		"0010010000010011", -- ADDA GR1 GR3
		"0010010000010011", -- ADDA GR1 GR3
		"0010010100010010", -- SUBA GR1 GR2
		"0010010100010010"  -- SUBA GR1 GR2
	);

begin 
	PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
end RTL;
