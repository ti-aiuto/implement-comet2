library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity clock_down is
	port(
		CLK_IN : in std_logic;
		CLK_OUT : out std_logic
	);
end clock_down;

architecture RTL of clock_down is
signal COUNT : std_logic_vector(22 downto 0);

begin
	process(CLK_IN)
	begin
		if (CLK_IN'event and CLK_IN = '1') then
			COUNT <= COUNT + 1;
		end if;
	end process;
	CLK_OUT <= COUNT(22);
end RTL;
