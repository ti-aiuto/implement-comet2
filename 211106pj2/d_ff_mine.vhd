library IEEE;
use IEEE.std_logic_1164.all;

entity d_ff_mine is
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end d_ff_mine;

architecture RTL of d_ff_mine is

component sync_master_slave_rs_ff
	port(
		CLK : in std_logic;
		R : in std_logic;
		S : in std_logic;
		Q : out std_logic
	);
end component;

begin
	RSFF: sync_master_slave_rs_ff port map(CLK => CLK, S => D, R => not D, Q => Q);
end RTL;
