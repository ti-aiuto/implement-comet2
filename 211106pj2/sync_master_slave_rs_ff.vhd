library IEEE;
use IEEE.std_logic_1164.all;

entity sync_master_slave_rs_ff is
	port(
		CLK : in std_logic;
		R : in std_logic;
		S : in std_logic;
		Q : out std_logic
	);
end sync_master_slave_rs_ff;

architecture RTL of sync_master_slave_rs_ff is

component sync_rs_ff
	port(
		CLK : in std_logic;
		R : in std_logic;
		S : in std_logic;
		Q : out std_logic
	);
end component;

signal Q_TMP: std_logic;

begin
	RSFF1 : sync_rs_ff port map(CLK => CLK, S => S, R => R, Q => Q_TMP);
	RSFF2 : sync_rs_ff port map(CLK => not CLK, S => Q_TMP, R => not Q_TMP, Q => Q);
end RTL;
