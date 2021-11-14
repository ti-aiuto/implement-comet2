library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity register_16 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end register_16;

architecture RTL of register_16 is

component register_8 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(7 downto 0);
		DATA_OUT : out std_logic_vector(7 downto 0)
	);
end component;

begin
	REGISTER1 : register_8 port map(CLK_IN => CLK_IN, WRITE_FLAG => WRITE_FLAG, DATA_IN => DATA_IN(7 downto 0), DATA_OUT => DATA_OUT(7 downto 0));
	REGISTER2 : register_8 port map(CLK_IN => CLK_IN, WRITE_FLAG => WRITE_FLAG, DATA_IN => DATA_IN(15 downto 8), DATA_OUT => DATA_OUT(15 downto 8));
end RTL;
