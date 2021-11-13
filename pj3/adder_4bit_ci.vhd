library IEEE;
use IEEE.std_logic_1164.all;

entity adder_4bit_ci is
	port(
		AIN : in std_logic_vector(3 downto 0);
		BIN : in std_logic_vector(3 downto 0);
		CIN : in std_logic;
		SUM : out std_logic_vector(4 downto 0)
	);
end adder_4bit_ci;

architecture RTL of adder_4bit_ci is

component full_adder
	port
	(
		A : in std_logic;
		B : in std_logic;
		CI : in std_logic;
		S : out std_logic;
		CO : out std_logic
	);
end component;

signal CO_TMP0 : std_logic;
signal CO_TMP1 : std_logic;
signal CO_TMP2 : std_logic;

begin
	C1 : full_adder port map(A => AIN(0), B => BIN(0), CI => CIN, S => SUM(0), CO => CO_TMP0);
	C2 : full_adder port map(A => AIN(1), B => BIN(1), CI => CO_TMP0, S => SUM(1), CO => CO_TMP1);
	C3 : full_adder port map(A => AIN(2), B => BIN(2), CI => CO_TMP1, S => SUM(2), CO => CO_TMP2);
	C4 : full_adder port map(A => AIN(3), B => BIN(3), CI => CO_TMP2, S => SUM(3), CO => SUM(4));
end RTL;
