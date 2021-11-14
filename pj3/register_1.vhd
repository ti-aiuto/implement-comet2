library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity register_1 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic;
		DATA_OUT : out std_logic
	);
end register_1;

architecture RTL of register_1 is

component d_ff is
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end component;

begin
	DFF1 : d_ff port map(CLK => CLK_IN, D => DATA_IN, Q => DATA_OUT);
end RTL;
