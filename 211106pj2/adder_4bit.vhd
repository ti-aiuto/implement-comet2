library IEEE;
use IEEE.std_logic_1164.all;

entity adder_4bit is
	port(
		AIN : in std_logic_vector(3 downto 0);
		BIN : in std_logic_vector(3 downto 0);
		SUM : out std_logic_vector(4 downto 0)
	);
end adder_4bit;

architecture RTL of adder_4bit is

component adder_4bit_ci
	port
	(
		AIN : in std_logic_vector(3 downto 0);
		BIN : in std_logic_vector(3 downto 0);
		CIN : in std_logic;
		SUM : out std_logic_vector(4 downto 0)
	);
end component;

begin
	ADDER1 : adder_4bit_ci port map(AIN => AIN, BIN => BIN, SUM => SUM, CIN => '0');
end RTL;
