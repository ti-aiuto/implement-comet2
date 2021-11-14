library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity register_8 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(7 downto 0);
		DATA_OUT : out std_logic_vector(7 downto 0)
	);
end register_8;

architecture RTL of register_8 is

component register_4 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(3 downto 0);
		DATA_OUT : out std_logic_vector(3 downto 0)
	);
end component;

begin
	REGISTER1 : register_4 port map(CLK_IN => CLK_IN, WRITE_FLAG => WRITE_FLAG, DATA_IN => DATA_IN(3 downto 0), DATA_OUT => DATA_OUT(3 downto 0));
	REGISTER2 : register_4 port map(CLK_IN => CLK_IN, WRITE_FLAG => WRITE_FLAG, DATA_IN => DATA_IN(7 downto 4), DATA_OUT => DATA_OUT(7 downto 4));
end RTL;
