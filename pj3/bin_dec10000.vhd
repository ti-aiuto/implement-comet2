library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity bin_dec10000 is
	port( BIN_IN : in std_logic_vector(15 downto 0);
		DEC_OUT4 : out std_logic_vector(3 downto 0);
		REMINDER4 : out std_logic_vector(13 downto 0) );
end bin_dec10000;

architecture RTL of bin_dec10000 is

signal CMP_INT : integer range 0 to 65535;
signal REM_INT : integer range 0 to 65535;

begin
	CMP_INT <= conv_integer(BIN_IN);
	process(CMP_INT)
	begin
		if (CMP_INT > 59999) then
			DEC_OUT4 <= "0110";
			REM_INT <= CMP_INT - 60000;
		elsif (CMP_INT > 49999) then
			DEC_OUT4 <= "0101";
			REM_INT <= CMP_INT - 50000;
		elsif (CMP_INT > 39999) then
			DEC_OUT4 <= "0100";
			REM_INT <= CMP_INT - 40000;
		elsif (CMP_INT > 29999) then
			DEC_OUT4 <= "0011";
			REM_INT <= CMP_INT - 30000;
		elsif (CMP_INT > 19999) then
			DEC_OUT4 <= "0010";
			REM_INT <= CMP_INT - 20000;
		elsif (CMP_INT > 9999) then
			DEC_OUT4 <= "0001";
			REM_INT <= CMP_INT - 10000;
		else
			DEC_OUT4 <= "0000";
			REM_INT <= CMP_INT;
		end if;
	end process;
	REMINDER4 <= conv_std_logic_vector(REM_INT, 14);
end RTL;
