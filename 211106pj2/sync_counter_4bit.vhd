library IEEE;
use IEEE.std_logic_1164.all;

entity sync_counter_4bit is
	port(
		CLK : in std_logic;
		COUNT : out std_logic_vector(3 downto 0)
	);
end sync_counter_4bit;

architecture RTL of sync_counter_4bit is

component d_ff
	port(
		CLK : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end component;

signal Q_TMP1 : std_logic;
signal Q_TMP2 : std_logic;
signal Q_TMP3 : std_logic;
signal Q_TMP4 : std_logic;

begin
	DFF1 : d_ff port map(CLK => CLK, D => not Q_TMP1, Q => Q_TMP1);
	DFF2 : d_ff port map(CLK => CLK, D => Q_TMP1 xor Q_TMP2, Q => Q_TMP2);
	DFF3 : d_ff port map(CLK => CLK, D => Q_TMP2 xor Q_TMP3, Q => Q_TMP3);
	DFF4 : d_ff port map(CLK => CLK, D => Q_TMP3 xor Q_TMP4, Q => Q_TMP4);
	COUNT(0) <= not Q_TMP1;
	COUNT(1) <= Q_TMP2;
	COUNT(2) <= Q_TMP3;
	COUNT(3) <= Q_TMP4;
end RTL;
