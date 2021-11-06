library IEEE;
use IEEE.std_logic_1164.all;

entity dec_7seg is
	port 
	(
		DIN : in std_logic_vector(3 downto 0);
		SEG7 : out std_logic_vector(6 downto 0)
	);
end dec_7seg;

architecture RTL of dec_7seg is
begin
	process(DIN)
	begin
		case DIN is
			when "0000" => SEG7 <= "1111110";
			when "0001" => SEG7 <= "0011000";
			when "0010" => SEG7 <= "1101101";
			when "0011" => SEG7 <= "0111101";
			when "0100" => SEG7 <= "0011011";
			when "0101" => SEG7 <= "0110111";
			when "0110" => SEG7 <= "1110111";
			when "0111" => SEG7 <= "0011110";
			when "1000" => SEG7 <= "1111111";
			when "1001" => SEG7 <= "0111111";
			when others => SEG7 <= "0000000";
		end case;
	end process;
end RTL;
	