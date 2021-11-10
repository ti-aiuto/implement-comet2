library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity bin_dec1000 is
	port( BIN_IN : in std_logic_vector(13 downto 0);
		DEC_OUT3 : out std_logic_vector(3 downto 0);
		REMINDER3 : out std_logic_vector(9 downto 0) );
end bin_dec1000;

architecture RTL of bin_dec1000 is

signal CMP_INT : integer range 0 to 65535;
signal REM_INT : integer range 0 to 65535;

begin
	CMP_INT <= conv_integer(BIN_IN);
	process(CMP_INT)
	begin
		if (CMP_INT > 8999) then
			DEC_OUT3 <= "1001";
			REM_INT <= CMP_INT - 9000;
		elsif (CMP_INT > 7999) then
			DEC_OUT3 <= "1000";
			REM_INT <= CMP_INT - 8000;
		elsif (CMP_INT > 6999) then
			DEC_OUT3 <= "0111";
			REM_INT <= CMP_INT - 7000;
		elsif (CMP_INT > 5999) then
			DEC_OUT3 <= "0110";
			REM_INT <= CMP_INT - 6000;
		elsif (CMP_INT > 4999) then
			DEC_OUT3 <= "0101";
			REM_INT <= CMP_INT - 5000;
		elsif (CMP_INT > 3999) then
			DEC_OUT3 <= "0100";
			REM_INT <= CMP_INT - 4000;
		elsif (CMP_INT > 2999) then
			DEC_OUT3 <= "0011";
			REM_INT <= CMP_INT - 3000;
		elsif (CMP_INT > 1999) then
			DEC_OUT3 <= "0010";
			REM_INT <= CMP_INT - 2000;
		elsif (CMP_INT > 999) then
			DEC_OUT3 <= "0001";
			REM_INT <= CMP_INT - 1000;
		else
			DEC_OUT3 <= "0000";
			REM_INT <= CMP_INT;
		end if;
	end process;
	REMINDER3 <= conv_std_logic_vector(REM_INT, 10);
end RTL;
