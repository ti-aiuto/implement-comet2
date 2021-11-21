library IEEE;
use IEEE.std_logic_1164.all;

entity phase_write_back is
	port(
		CLK : in std_logic;
		EFFECTIVE_ADDR : in std_logic_vector(15 downto 0);
		NEXT_PR : in std_logic_vector(15 downto 0);
		NEXT_DATA : in std_logic_vector(15 downto 0);
		NEXT_FR : in std_logic_vector(2 downto 0);
		WRITE_GR_FLAG : in std_logic;
		WRITE_PR_FLAG : in std_logic; 
		WRITE_FR_FLAG : in std_logic;
		GR_SELECT : in std_logic_vector(2 downto 0);
		GR0_OUT : out std_logic_vector(15 downto 0);
		GR1_OUT : out std_logic_vector(15 downto 0);
		GR2_OUT : out std_logic_vector(15 downto 0);
		GR3_OUT : out std_logic_vector(15 downto 0);
		GR4_OUT : out std_logic_vector(15 downto 0);
		GR5_OUT : out std_logic_vector(15 downto 0);
		GR6_OUT : out std_logic_vector(15 downto 0);
		GR7_OUT : out std_logic_vector(15 downto 0);
		PR_OUT : out std_logic_vector(15 downto 0);
		CURRENT_FR : out std_logic_vector(2 downto 0)
	);
end phase_write_back;

architecture RTL of phase_write_back is

component register_16 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;


component register_4 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(3 downto 0);
		DATA_OUT : out std_logic_vector(3 downto 0)
	);
end component;

component gr_controller is
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
end component;
begin
	PR : register_16 port map(CLK_IN => CLK, WRITE_FLAG => WRITE_PR_FLAG, DATA_IN => NEXT_PR, DATA_OUT => PR_OUT);
	FR : register_4 port map(CLK_IN => CLK, WRITE_FLAG => WRITE_FR_FLAG, DATA_IN => "0" & NEXT_FR, DATA_OUT(2 downto 0) => CURRENT_FR);
	
	-- ここにRAMに入れる実装もいる	
	GR_CONTROLLER_INSTANCE : gr_controller port map( CLK => CLK, 
	GR_WRITE_FLAG => WRITE_GR_FLAG, 
	GR_WRITE_SELECT => GR_SELECT, 
	GR_WRITE_DATA => NEXT_DATA, 
	GR0_OUT => GR0_OUT, 
	GR1_OUT => GR1_OUT, 
	GR2_OUT => GR2_OUT, 
	GR3_OUT => GR3_OUT, 
	GR4_OUT => GR4_OUT, 
	GR5_OUT => GR5_OUT, 
	GR6_OUT => GR6_OUT, 
	GR7_OUT => GR7_OUT);
end RTL;
