library IEEE;
use IEEE.std_logic_1164.all;

entity shift_1 is
	port(
		DATA_IN: in std_logic_vector(15 downto 0);
		OF_IN: in std_logic;
		ENABLED_FLAG: in std_logic;
		RIGHT_FLAG: in std_logic;
		LOGICAL_MODE_FLAG: in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
	);
end shift_1;

architecture RTL of shift_1 is

component multiplexer_16bit_4ways is
	port(
		SELECTOR : in std_logic_vector(1 downto 0);
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_IN_3 : in std_logic_vector(15 downto 0);
		DATA_IN_4 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

component multiplexer_16bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

component multiplexer_1bit_4ways is
	port(
		SELECTOR : in std_logic_vector(1 downto 0);
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_IN_3 : in std_logic;
		DATA_IN_4 : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

component multiplexer_1bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic;
		DATA_IN_2 : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

signal INTERNAL_DATA: std_logic_vector(15 downto 0);
signal INTERNAL_OF: std_logic;

begin
	MX_DATA: multiplexer_16bit_4ways port map(
		SELECTOR => LOGICAL_MODE_FLAG & RIGHT_FLAG, 
		DATA_IN_1 => DATA_IN(15) & DATA_IN(13 downto 0) & "0", -- 左算術シフト
		DATA_IN_2 => DATA_IN(15) & DATA_IN(15) & DATA_IN(14 downto 1), -- 右算術シフト
		DATA_IN_3 => DATA_IN(14 downto 0) & "0", --左論理シフト
		DATA_IN_4 => "0" & DATA_IN(15 downto 1), --右論理シフト
		DATA_OUT => INTERNAL_DATA
	);
	
	MX_OF: multiplexer_1bit_4ways port map(
		SELECTOR => LOGICAL_MODE_FLAG & RIGHT_FLAG, 
		DATA_IN_1 => DATA_IN(14), -- 左算術シフト
		DATA_IN_2 => DATA_IN(0), -- 右算術シフト
		DATA_IN_3 => DATA_IN(15), --左論理シフト
		DATA_IN_4 => DATA_IN(0), --右論理シフト
		DATA_OUT => INTERNAL_OF
	);
	
	MX_OUT_DATA: multiplexer_16bit_2ways port map(
		SELECTOR => ENABLED_FLAG, 
		DATA_IN_1 => DATA_IN, 
		DATA_IN_2 => INTERNAL_DATA,
		DATA_OUT => DATA_OUT
	);
	
	MX_OUT_OF: multiplexer_1bit_2ways port map(
		SELECTOR => ENABLED_FLAG, 
		DATA_IN_1 => OF_IN, 
		DATA_IN_2 => INTERNAL_OF,
		DATA_OUT => OF_OUT
	);
end RTL;

