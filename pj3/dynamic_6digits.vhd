library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity dynamic_6digits is
	port 
	(
		CLK_IN : in std_logic;
		DIN1 : in std_logic_vector(3 downto 0);
		DIN2 : in std_logic_vector(3 downto 0);
		DIN3 : in std_logic_vector(3 downto 0);
		DIN4 : in std_logic_vector(3 downto 0);
		DIN5 : in std_logic_vector(3 downto 0);
		DIN6 : in std_logic_vector(3 downto 0);
		SEG7 : out std_logic_vector(6 downto 0);
		DIGIT_SELECT : out std_logic_vector(5 downto 0)
	);
end dynamic_6digits;

architecture RTL of dynamic_6digits is
signal COUNT_INT : integer range 0 to 6;
signal DIN_INPUT : std_logic_vector(3 downto 0);

component dec_7seg
	port 
	(
		DIN : in std_logic_vector(3 downto 0);
		SEG7 : out std_logic_vector(6 downto 0)
	);
end component;

begin
	DIGITA_COMPONENT : dec_7seg port map( DIN => DIN_INPUT, SEG7 => SEG7 );
	
	process(CLK_IN)
	begin
		if (CLK_IN'event and CLK_IN = '1') then
			if (COUNT_INT = 1) then
				COUNT_INT <= COUNT_INT + 1;
				DIN_INPUT <= DIN1;
				DIGIT_SELECT <= "100000";
			elsif (COUNT_INT = 2) then
				COUNT_INT <= COUNT_INT + 1;
				DIN_INPUT <= DIN2;
				DIGIT_SELECT <= "010000";
			elsif (COUNT_INT = 3) then
				COUNT_INT <= COUNT_INT + 1;
				DIN_INPUT <= DIN3;
				DIGIT_SELECT <= "001000";
			elsif (COUNT_INT = 4) then
				COUNT_INT <= COUNT_INT + 1;
				DIN_INPUT <= DIN4;
				DIGIT_SELECT <= "000100";
			elsif (COUNT_INT = 5) then
				COUNT_INT <= COUNT_INT + 1;
				DIN_INPUT <= DIN5;
				DIGIT_SELECT <= "000010";
			else
				COUNT_INT <= 1;			
				DIN_INPUT <= DIN6;
				DIGIT_SELECT <= "000001";
			end if;
		end if;
	end process;
end RTL;
	