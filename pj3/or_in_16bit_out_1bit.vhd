library IEEE;
use IEEE.std_logic_1164.all;

entity or_in_16bit_out_1bit is
	port( 
	DATA_IN : in std_logic_vector(15 downto 0); 
	DATA_OUT : out std_logic
	);
end or_in_16bit_out_1bit;

architecture RTL of or_in_16bit_out_1bit is

begin
	DATA_OUT <= DATA_IN(0) OR DATA_IN(1) OR DATA_IN(2) OR DATA_IN(3)
		OR DATA_IN(4) OR DATA_IN(5) OR DATA_IN(6) OR DATA_IN(7)
		OR DATA_IN(8) OR DATA_IN(9) OR DATA_IN(10) OR DATA_IN(11)
		OR DATA_IN(12) OR DATA_IN(13) OR DATA_IN(14) OR DATA_IN(15);
end RTL;
