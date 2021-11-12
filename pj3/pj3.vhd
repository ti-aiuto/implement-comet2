library IEEE;
use IEEE.std_logic_1164.all;

entity pj3 is
	port 
	(
		CLK_IN : in std_logic;
		SEG7A : out std_logic_vector(6 downto 0);
		DIGITA_SELECT : out std_logic_vector(5 downto 0);
		SEG7B : out std_logic_vector(6 downto 0);
		DIGITB_SELECT : out std_logic_vector(5 downto 0)
	);
end pj3;

architecture RTL of pj3 is

component clock_down_dynamyc_7seg
	port(
		CLK_IN : in std_logic;
		CLK_OUT : out std_logic
	);
end component;

component bin_16_dec_dynamic_6
	port( CLK_IN : in std_logic;
	BIN_IN : in std_logic_vector(15 downto 0);
		SEG7 : out std_logic_vector(6 downto 0);
		DIGIT_SELECT : out std_logic_vector(5 downto 0) 
	);
end component;

signal CLK_SLOW : std_logic;

begin
	CLOCK_COMPONENT : clock_down_dynamyc_7seg port map(CLK_IN => CLK_IN, CLK_OUT => CLK_SLOW);
	
	DEC1 : bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW,
	BIN_IN => "0010011010010100", 
	SEG7 => SEG7A, 
	DIGIT_SELECT => DIGITA_SELECT);

		DEC2: bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW,
	BIN_IN => "1101010000110001", 
	SEG7 => SEG7B, 
	DIGIT_SELECT => DIGITB_SELECT);
end RTL;
	