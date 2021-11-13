library IEEE;
use IEEE.std_logic_1164.all;

entity half_adder is
	port
	(
		A : in std_logic;
		B : in std_logic;
		S : out std_logic;
		CO : out std_logic
	);
end half_adder;

architecture RTL of half_adder is

begin
	S <= A xor B;
	CO <= A and B;
end RTL;
	
