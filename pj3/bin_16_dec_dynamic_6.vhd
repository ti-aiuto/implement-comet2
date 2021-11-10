library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity bin_16_dec_dynamic_6 is
	port( CLK_IN : in std_logic;
	BIN_IN : in std_logic_vector(15 downto 0);
		SEG7 : out std_logic_vector(6 downto 0);
		DIGIT_SELECT : out std_logic_vector(5 downto 0) );
end bin_16_dec_dynamic_6;

architecture RTL of bin_16_dec_dynamic_6 is

signal DEC_OUT4 : std_logic_vector(3 downto 0);
signal DEC_OUT3 : std_logic_vector(3 downto 0);
signal DEC_OUT2 : std_logic_vector(3 downto 0);
signal DEC_OUT1 : std_logic_vector(3 downto 0);
signal REMINDER4 : std_logic_vector(13 downto 0);
signal REMINDER3 : std_logic_vector(9 downto 0);
signal REMINDER2 : std_logic_vector(6 downto 0);
signal REMINDER1 : std_logic_vector(3 downto 0);

component bin_dec10000
	port( 
	BIN_IN : in std_logic_vector(15 downto 0);
		DEC_OUT4 : out std_logic_vector(3 downto 0);
		REMINDER4 : out std_logic_vector(13 downto 0) );
end component;

component bin_dec1000
	port( BIN_IN : in std_logic_vector(13 downto 0);
		DEC_OUT3 : out std_logic_vector(3 downto 0);
		REMINDER3 : out std_logic_vector(9 downto 0) );
end component;

component bin_dec100
	port( BIN_IN : in std_logic_vector(9 downto 0);
		DEC_OUT2 : out std_logic_vector(3 downto 0);
		REMINDER2 : out std_logic_vector(6 downto 0) );
end component;

component bin_dec10
	port( BIN_IN : in std_logic_vector(6 downto 0);
		DEC_OUT1 : out std_logic_vector(3 downto 0);
		REMINDER1 : out std_logic_vector(3 downto 0) );
end component;

component dynamic_6digits
	port 
	(
		CLK_IN : in std_logic;
		DIN1 : in std_logic_vector(3 downto 0);
		DIN2 : in std_logic_vector(3 downto 0);
		DIN3 : in std_logic_vector(3 downto 0);
		DIN4 : in std_logic_vector(3 downto 0);
		DIN5 : in std_logic_vector(3 downto 0);
		DIN6 : in std_logic_vector(3 downto 0);
		SEG7 : out std_logic_vector(6 downto 0);
		DIGIT_SELECT : out std_logic_vector(5 downto 0)
	);
end component;

begin
	DEC10000 : bin_dec10000 port map ( BIN_IN => BIN_IN, DEC_OUT4 => DEC_OUT4, REMINDER4 => REMINDER4 );
	DEC1000 : bin_dec1000 port map ( BIN_IN => REMINDER4, DEC_OUT3 => DEC_OUT3, REMINDER3 => REMINDER3 );
	DEC100 : bin_dec100 port map ( BIN_IN => REMINDER3, DEC_OUT2 => DEC_OUT2, REMINDER2 => REMINDER2 );
	DEC10 : bin_dec10 port map ( BIN_IN => REMINDER2, DEC_OUT1 => DEC_OUT1, REMINDER1 => REMINDER1 );
	
	DIGITS : dynamic_6digits port map( CLK_IN => CLK_IN,
	DIN1 => REMINDER1, 
	DIN2 => DEC_OUT1, 
	DIN3 => DEC_OUT2, 
	DIN4 => DEC_OUT3, 
	DIN5 => DEC_OUT4, 
	DIN6 => "0000" , 
	SEG7 => SEG7, 
	DIGIT_SELECT => DIGIT_SELECT);
end RTL;
