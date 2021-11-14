library IEEE;
use IEEE.std_logic_1164.all;

entity sync_jk_ff is
	port(
		CLK : in std_logic;
		J : in std_logic;
		K : in std_logic;
		Q : out std_logic
	);
end sync_jk_ff;

architecture RTL of sync_jk_ff is

signal NAND_LEFT_1 : std_logic;
signal NAND_LEFT_2 : std_logic;
signal NAND_MIDDLE_1 : std_logic;
signal NAND_MIDDLE_2 : std_logic;
signal NAND_MIDDLE_3 : std_logic;
signal NAND_MIDDLE_4 : std_logic;
signal NAND_RIGHT_1 : std_logic;
signal NAND_RIGHT_2 : std_logic;

begin
	NAND_LEFT_1 <= J nand NAND_RIGHT_2;
	NAND_LEFT_2 <= K nand NAND_RIGHT_1;
	
	NAND_MIDDLE_1 <= NAND_LEFT_1 nand NAND_MIDDLE_2;
	NAND_MIDDLE_2 <= not(NAND_MIDDLE_1 AND CLK AND NAND_MIDDLE_3);
	NAND_MIDDLE_3 <= not(NAND_MIDDLE_2 AND CLK AND NAND_MIDDLE_4);
	NAND_MIDDLE_4 <= NAND_MIDDLE_3 nand NAND_LEFT_2;
	
	NAND_RIGHT_1 <= NAND_MIDDLE_2 nand NAND_RIGHT_2;
	NAND_RIGHT_2 <= NAND_RIGHT_1 nand NAND_MIDDLE_3;
	
	Q <= not NAND_RIGHT_2;
end RTL;
