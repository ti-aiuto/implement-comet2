library IEEE;
use IEEE.std_logic_1164.all;

entity d_ff is
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end d_ff;

architecture RTL of d_ff is

component sync_jk_ff
	port(
		CLK : in std_logic;
		J : in std_logic;
		K : in std_logic;
		Q : out std_logic
	);
end component;

begin
	RSFF: sync_jk_ff port map(CLK => CLK, J => D, K => not D, Q => Q);
end RTL;
