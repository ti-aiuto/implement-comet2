library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity register_16 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end register_16;

architecture RTL of register_16 is

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
	DFF5 : d_ff port map(CLK => CLK_IN, D => DATA_IN(4), Q => DATA_OUT(4));
	DFF6 : d_ff port map(CLK => CLK_IN, D => DATA_IN(5), Q => DATA_OUT(5));
	DFF7 : d_ff port map(CLK => CLK_IN, D => DATA_IN(6), Q => DATA_OUT(6));
	DFF8 : d_ff port map(CLK => CLK_IN, D => DATA_IN(7), Q => DATA_OUT(7));
	DFF9 : d_ff port map(CLK => CLK_IN, D => DATA_IN(8), Q => DATA_OUT(8));
	DFF10 : d_ff port map(CLK => CLK_IN, D => DATA_IN(9), Q => DATA_OUT(9));
	DFF11 : d_ff port map(CLK => CLK_IN, D => DATA_IN(10), Q => DATA_OUT(10));
	DFF12 : d_ff port map(CLK => CLK_IN, D => DATA_IN(11), Q => DATA_OUT(11));
	DFF13 : d_ff port map(CLK => CLK_IN, D => DATA_IN(12), Q => DATA_OUT(12));
	DFF14 : d_ff port map(CLK => CLK_IN, D => DATA_IN(13), Q => DATA_OUT(13));
	DFF15 : d_ff port map(CLK => CLK_IN, D => DATA_IN(14), Q => DATA_OUT(14));
	DFF16 : d_ff port map(CLK => CLK_IN, D => DATA_IN(15), Q => DATA_OUT(15));
end RTL;
