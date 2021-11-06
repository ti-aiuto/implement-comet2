library IEEE;
use IEEE.std_logic_1164.all;

entity d_ff_sample is
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end d_ff_sample;

architecture RTL of d_ff_sample is

begin
	process(CLK)
	begin
	-- ここはあとで純粋な論理回路に直す
		if (CLK'event and CLK = '1') then
			Q <= D;
		end if;
	end process;
end RTL;
