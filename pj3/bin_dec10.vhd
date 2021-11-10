library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity bin_dec10 is
	port( BIN_IN : in std_logic_vector(6 downto 0);
		DEC_OUT1 : out std_logic_vector(3 downto 0);
		REMINDER1 : out std_logic_vector(3 downto 0) );
end bin_dec10;

architecture RTL of bin_dec10 is

signal CMP_INT : integer range 0 to 65535;
signal REM_INT : integer range 0 to 65535;

begin
	CMP_INT <= conv_integer(BIN_IN);
	process(CMP_INT)
	begin
		if (CMP_INT > 89) then
			DEC_OUT1 <= "1001";
			REM_INT <= CMP_INT - 90;
		elsif (CMP_INT > 79) then
			DEC_OUT1 <= "1000";
			REM_INT <= CMP_INT - 80;
		elsif (CMP_INT > 69) then
			DEC_OUT1 <= "0111";
			REM_INT <= CMP_INT - 70;
		elsif (CMP_INT > 59) then
			DEC_OUT1 <= "0110";
			REM_INT <= CMP_INT - 60;
		elsif (CMP_INT > 49) then
			DEC_OUT1 <= "0101";
			REM_INT <= CMP_INT - 50;
		elsif (CMP_INT > 39) then
			DEC_OUT1 <= "0100";
			REM_INT <= CMP_INT - 40;
		elsif (CMP_INT > 29) then
			DEC_OUT1 <= "0011";
			REM_INT <= CMP_INT - 30;
		elsif (CMP_INT > 19) then
			DEC_OUT1 <= "0010";
			REM_INT <= CMP_INT - 20;
		elsif (CMP_INT > 9) then
			DEC_OUT1 <= "0001";
			REM_INT <= CMP_INT - 10;
		else
			DEC_OUT1 <= "0000";
			REM_INT <= CMP_INT;
		end if;
	end process;
	REMINDER1 <= conv_std_logic_vector(REM_INT, 4);
end RTL;
