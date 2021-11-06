library IEEE;
use IEEE.std_logic_1164.all;

entity adder_16bit is
	port(
		AIN : in std_logic_vector(15 downto 0);
		BIN : in std_logic_vector(15 downto 0);
		SUM : out std_logic_vector(16 downto 0)
	);
end adder_16bit;

architecture RTL of adder_16bit is

component adder_4bit_ci
	port
	(
		AIN : in std_logic_vector(3 downto 0);
		BIN : in std_logic_vector(3 downto 0);
		CIN : in std_logic;
		SUM : out std_logic_vector(4 downto 0)
	);
end component;

signal SUM_TMP1 : std_logic_vector(4 downto 0);
signal SUM_TMP2 : std_logic_vector(4 downto 0);
signal SUM_TMP3 : std_logic_vector(4 downto 0);
signal SUM_TMP4 : std_logic_vector(4 downto 0);

begin
	ADDER1 : adder_4bit_ci port map(AIN => AIN(3 downto 0), BIN => BIN(3 downto 0), SUM => SUM_TMP1, CIN => '0');
	ADDER2 : adder_4bit_ci port map(AIN => AIN(7 downto 4), BIN => BIN(7 downto 4), SUM => SUM_TMP2, CIN => SUM_TMP1(4));
	ADDER3 : adder_4bit_ci port map(AIN => AIN(11 downto 8), BIN => BIN(11 downto 8), SUM => SUM_TMP3, CIN => SUM_TMP2(4));
	ADDER4 : adder_4bit_ci port map(AIN => AIN(15 downto 12), BIN => BIN(15 downto 12), SUM => SUM_TMP4, CIN => SUM_TMP3(4));
	SUM <= SUM_TMP4 & SUM_TMP3(3 downto 0) & SUM_TMP2(3 downto 0) & SUM_TMP1(3 downto 0);
end RTL;
