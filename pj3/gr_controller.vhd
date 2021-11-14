library IEEE;
use IEEE.std_logic_1164.all;

entity gr_controller is
	port(
		CLK : in std_logic;
		GR_WRITE_FLAG : in std_logic;
		GR_WRITE_SELECT : in std_logic_vector(2 downto 0);
		GR_WRITE_DATA : in std_logic_vector(15 downto 0);
		GR0_OUT : out std_logic_vector(15 downto 0);
		GR1_OUT : out std_logic_vector(15 downto 0);
		GR2_OUT : out std_logic_vector(15 downto 0);
		GR3_OUT : out std_logic_vector(15 downto 0);
		GR4_OUT : out std_logic_vector(15 downto 0);
		GR5_OUT : out std_logic_vector(15 downto 0);
		GR6_OUT : out std_logic_vector(15 downto 0);
		GR7_OUT : out std_logic_vector(15 downto 0)
	);
end gr_controller;

architecture RTL of gr_controller is

component register_16 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

signal GRA0_SELECTED: std_logic;
signal GRA1_SELECTED: std_logic;
signal GRA2_SELECTED: std_logic;
signal GRA3_SELECTED: std_logic;
signal GRA4_SELECTED: std_logic;
signal GRA5_SELECTED: std_logic;
signal GRA6_SELECTED: std_logic;
signal GRA7_SELECTED: std_logic;

begin
	GRA0_SELECTED <= not GR_WRITE_SELECT(2) and not GR_WRITE_SELECT(1) and not GR_WRITE_SELECT(0);
	GRA1_SELECTED <= not GR_WRITE_SELECT(2) and not GR_WRITE_SELECT(1) and GR_WRITE_SELECT(0);
	GRA2_SELECTED <= not GR_WRITE_SELECT(2) and GR_WRITE_SELECT(1) and not GR_WRITE_SELECT(0);
	GRA3_SELECTED <= not GR_WRITE_SELECT(2) and GR_WRITE_SELECT(1) and GR_WRITE_SELECT(0);
	GRA4_SELECTED <= GR_WRITE_SELECT(2) and not GR_WRITE_SELECT(1) and not GR_WRITE_SELECT(0);
	GRA5_SELECTED <= GR_WRITE_SELECT(2) and not GR_WRITE_SELECT(1) and GR_WRITE_SELECT(0);
	GRA6_SELECTED <= GR_WRITE_SELECT(2) and GR_WRITE_SELECT(1) and not GR_WRITE_SELECT(0);
	GRA7_SELECTED <= GR_WRITE_SELECT(2) and GR_WRITE_SELECT(1) and GR_WRITE_SELECT(0);
	
	GR0 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA0_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR0_OUT);
	GR1 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA1_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR1_OUT);
	GR2 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA2_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR2_OUT);
	GR3 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA3_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR3_OUT);
	GR4 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA4_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR4_OUT);
	GR5 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA5_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR5_OUT);
	GR6 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA6_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR6_OUT);
	GR7 : register_16 port map(CLK_IN => CLK and GR_WRITE_FLAG and GRA7_SELECTED, DATA_IN => GR_WRITE_DATA, DATA_OUT => GR7_OUT);
end RTL;
