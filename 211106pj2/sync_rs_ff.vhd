library IEEE;
use IEEE.std_logic_1164.all;

entity sync_rs_ff is
	port(
		CLK : in std_logic;
		R : in std_logic;
		S : in std_logic;
		Q : out std_logic
	);
end sync_rs_ff;

architecture RTL of sync_rs_ff is

signal NAND_LEFT_TOP : std_logic;
signal NAND_RIGHT_TOP : std_logic;
signal NAND_LEFT_DOWN : std_logic;
signal NAND_RIGHT_DOWN : std_logic;

begin
	NAND_LEFT_TOP <= S nand CLK;
	NAND_LEFT_DOWN <= R nand CLK;
	NAND_RIGHT_TOP <= NAND_LEFT_TOP nand NAND_RIGHT_DOWN;
	NAND_RIGHT_DOWN <= NAND_LEFT_DOWN nand NAND_RIGHT_TOP;
	Q <= NAND_RIGHT_TOP;
end RTL;
