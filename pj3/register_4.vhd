library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity register_4 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic_vector(3 downto 0);
		DATA_OUT : out std_logic_vector(3 downto 0)
	);
end register_4;

architecture RTL of register_4 is

component d_ff is
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end component;

begin
	DFF1 : d_ff port map(CLK => CLK_IN, D => DATA_IN(0), Q => DATA_OUT(0));
	DFF2 : d_ff port map(CLK => CLK_IN, D => DATA_IN(1), Q => DATA_OUT(1));
	DFF3 : d_ff port map(CLK => CLK_IN, D => DATA_IN(2), Q => DATA_OUT(2));
	DFF4 : d_ff port map(CLK => CLK_IN, D => DATA_IN(3), Q => DATA_OUT(3));
end RTL;
