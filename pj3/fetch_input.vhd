library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fetch_input is
	port(
		CLK_FT : in std_logic; 
		P_COUNT : in std_logic_vector(15 downto 0);
		PROM_OUT : out std_logic_vector(7 downto 0)
	);
end fetch_input;

architecture RTL of fetch_input is

subtype WORD is std_logic_vector(0 to 7);

type MEMORY is array (0 to 15) of WORD;

constant MEM : MEMORY := 
	(
		"00000001", 
		"00000010", 
		"00000100", 
		"00001000", 
		"00010000", 
		"00100000", 
		"01000000", 
		"10000000",
		"00000001", 
		"00000011", 
		"00000101", 
		"00001001", 
		"00010001", 
		"00100001", 
		"01000001", 
		"10000001"
	);

begin 
	process(CLK_FT)
	begin
		if (CLK_FT'event and CLK_FT = '1') then
			PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
		end if;
	end process;
end RTL;
