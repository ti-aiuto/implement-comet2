library IEEE;
use IEEE.std_logic_1164.all;

entity t_ff is
	port(
		CLK : in std_logic;
		Q : out std_logic
	);
end t_ff;

architecture RTL of t_ff is

component d_ff
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end component;

signal Q_TMP : std_logic;

begin
	COMPONENT1 : d_ff port map(CLK => CLK, D => not Q_TMP, Q => Q_TMP);
	Q <= Q_TMP;
end RTL;
