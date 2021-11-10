library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity bin_dec100 is
	port( BIN_IN : in std_logic_vector(9 downto 0);
		DEC_OUT2 : out std_logic_vector(3 downto 0);
		REMINDER2 : out std_logic_vector(6 downto 0) );
end bin_dec100;

architecture RTL of bin_dec100 is

signal CMP_INT : integer range 0 to 65535;
signal REM_INT : integer range 0 to 65535;

begin
	CMP_INT <= conv_integer(BIN_IN);
	process(CMP_INT)
	begin
		if (CMP_INT > 899) then
			DEC_OUT2 <= "1001";
			REM_INT <= CMP_INT - 900;
		elsif (CMP_INT > 799) then
			DEC_OUT2 <= "1000";
			REM_INT <= CMP_INT - 800;
		elsif (CMP_INT > 699) then
			DEC_OUT2 <= "0111";
			REM_INT <= CMP_INT - 700;
		elsif (CMP_INT > 599) then
			DEC_OUT2 <= "0110";
			REM_INT <= CMP_INT - 600;
		elsif (CMP_INT > 499) then
			DEC_OUT2 <= "0101";
			REM_INT <= CMP_INT - 500;
		elsif (CMP_INT > 399) then
			DEC_OUT2 <= "0100";
			REM_INT <= CMP_INT - 400;
		elsif (CMP_INT > 299) then
			DEC_OUT2 <= "0011";
			REM_INT <= CMP_INT - 300;
		elsif (CMP_INT > 199) then
			DEC_OUT2 <= "0010";
			REM_INT <= CMP_INT - 200;
		elsif (CMP_INT > 99) then
			DEC_OUT2 <= "0001";
			REM_INT <= CMP_INT - 100;
		else
			DEC_OUT2 <= "0000";
			REM_INT <= CMP_INT;
		end if;
	end process;
	REMINDER2 <= conv_std_logic_vector(REM_INT, 7);
end RTL;
