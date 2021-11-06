library IEEE;
use IEEE.std_logic_1164.all;

entity async_counter_4bit is
	port(
		CLK : in std_logic;
		COUNT : out std_logic_vector(3 downto 0)
	);
end async_counter_4bit;

architecture RTL of async_counter_4bit is

component t_ff
	port(
		CLK : in std_logic;
		Q : out std_logic
	);
end component;

signal Q_TMP1 : std_logic;
signal Q_TMP2 : std_logic;
signal Q_TMP3 : std_logic;
signal Q_TMP4 : std_logic;

begin
	TFF1 : t_ff port map(CLK => CLK, Q => Q_TMP1);
	TFF2 : t_ff port map(CLK => Q_TMP1, Q => Q_TMP2);
	TFF3 : t_ff port map(CLK => Q_TMP2, Q => Q_TMP3);
	TFF4 : t_ff port map(CLK => Q_TMP3, Q => Q_TMP4);
	COUNT(0) <= Q_TMP1;
	COUNT(1) <= Q_TMP2;
	COUNT(2) <= Q_TMP3;
	COUNT(3) <= Q_TMP4;
end RTL;
