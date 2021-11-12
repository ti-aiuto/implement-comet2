library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fetch_input is
	port(
		CLT_FT : in std_logic; 
		P_COUNT : in std_logic_vector(15 downto 0);
		PROM_OUT : out std_logic_vector(15 downto 0)
	);
end fetch_input;

architecture RTL of fetch_input is

subtype WORD is std_logic_vector(0 to 7);

type MEMORY is array (0 to 7) of WORD;

constant MEM : MEMORY := 
	(
		"00000000", 
		"00000010", 
		"00000100", 
		"00001000", 
		"00010000", 
		"00100000", 
		"01000000", 
		"10000000"
	);

begin 
	process(CLT_FT)
	begin
		if (CLT_FT'event and CLT_FT = '1') then
			PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
		end if;
	end process;
end RTL;
