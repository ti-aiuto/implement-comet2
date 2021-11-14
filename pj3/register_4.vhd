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

component register_1 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

begin
	DFF1 : register_1 port map(CLK_IN => CLK_IN, DATA_IN => DATA_IN(0), DATA_OUT => DATA_OUT(0));
	DFF2 : register_1 port map(CLK_IN => CLK_IN, DATA_IN => DATA_IN(1), DATA_OUT => DATA_OUT(1));
	DFF3 : register_1 port map(CLK_IN => CLK_IN, DATA_IN => DATA_IN(2), DATA_OUT => DATA_OUT(2));
	DFF4 : register_1 port map(CLK_IN => CLK_IN, DATA_IN => DATA_IN(3), DATA_OUT => DATA_OUT(3));
end RTL;
