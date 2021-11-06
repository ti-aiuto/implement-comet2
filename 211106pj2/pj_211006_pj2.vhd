library IEEE;
use IEEE.std_logic_1164.all;

entity pj_211006_pj2 is
	port 
	(
		CLK_IN : in std_logic;
		DIGIT1 : out std_logic_vector(6 downto 0);
		DIGIT2 : out std_logic_vector(6 downto 0);
		DIGIT3 : out std_logic_vector(6 downto 0)
	);
end pj_211006_pj2;

architecture RTL of pj_211006_pj2 is
component dec_7seg
	port 
	(
		DIN : in std_logic_vector(3 downto 0);
		SEG7 : out std_logic_vector(6 downto 0)
	);
end component;

component adder_16bit
	port(
		AIN : in std_logic_vector(15 downto 0);
		BIN : in std_logic_vector(15 downto 0);
		SUM : out std_logic_vector(16 downto 0)
	);
end component;

component async_counter_4bit
	port(
		CLK : in std_logic;
		COUNT : out std_logic_vector(3 downto 0)
	);
end component;

component clock_down
	port(
		CLK_IN : in std_logic;
		CLK_OUT : out std_logic
	);
end component;

signal CLK_SLOW : std_logic;
signal SUM_TMP : std_logic_vector(16 downto 0);
signal NUM1 : std_logic_vector(3 downto 0);
signal NUM2 : std_logic_vector(3 downto 0);

begin
	NUM2 <= "0001";
	CLOCK_COMPONENT : clock_down port map(CLK_IN => CLK_IN, CLK_OUT => CLK_SLOW);
	COUNTER_COMPONENT : async_counter_4bit port map(CLK => CLK_SLOW, COUNT => NUM1);
	DIGIT1_COMPONENT : dec_7seg port map( DIN => NUM1, SEG7 => DIGIT1 );
	DIGIT2_COMPONENT : dec_7seg port map( DIN => NUM2, SEG7 => DIGIT2 );
	DIGIT3_COMPONENT : dec_7seg port map( DIN => SUM_TMP(3 downto 0), SEG7 => DIGIT3 );
	ADDER_COMPONENT : adder_16bit port map(AIN => "000000000000" & NUM1, BIN => "000000000000" & NUM2, SUM => SUM_TMP);
end RTL;
	