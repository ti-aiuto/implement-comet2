library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity not_16bit is
	port( 
	DATA_IN : in std_logic_vector(15 downto 0); 
	DATA_OUT : out std_logic_vector(15 downto 0)
	);
end not_16bit;

architecture RTL of not_16bit is

begin
	DATA_OUT(0) <= not DATA_IN(0);
	DATA_OUT(1) <= not DATA_IN(1);
	DATA_OUT(2) <= not DATA_IN(2);
	DATA_OUT(3) <= not DATA_IN(3);
	DATA_OUT(4) <= not DATA_IN(4);
	DATA_OUT(5) <= not DATA_IN(5);
	DATA_OUT(6) <= not DATA_IN(6);
	DATA_OUT(7) <= not DATA_IN(7);
	DATA_OUT(8) <= not DATA_IN(8);
	DATA_OUT(9) <= not DATA_IN(9);
	DATA_OUT(10) <= not DATA_IN(10);
	DATA_OUT(11) <= not DATA_IN(11);
	DATA_OUT(12) <= not DATA_IN(12);
	DATA_OUT(13) <= not DATA_IN(13);
	DATA_OUT(14) <= not DATA_IN(14);
	DATA_OUT(15) <= not DATA_IN(15);
end RTL;
