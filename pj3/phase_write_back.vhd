library IEEE;
use IEEE.std_logic_1164.all;

entity phase_write_back is
	port(
		CLK : in std_logic;
		RESET_IN : in std_logic;
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);
		CURRENT_PR : in std_logic_vector(15 downto 0);
		EFFECTIVE_ADDR : in std_logic_vector(15 downto 0);
		NEXT_PR : out std_logic_vector(15 downto 0);
		WRITE_GR_FLAG : out std_logic;
		WRITE_PR_FLAG : out std_logic
	);
end phase_write_back;

architecture RTL of phase_write_back is

component register_1 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

component register_16 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
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

component adder_16bit is
	port(
		CI : in std_logic;
		AIN : in std_logic_vector(15 downto 0);
		BIN : in std_logic_vector(15 downto 0);
		SUM : out std_logic_vector(16 downto 0)
	);
end component;
	signal OP_IS_LAD_FLAG : std_logic;
	signal PR_WORD_ADDED : std_logic_vector(15 downto 0);

	signal INTERNAL_NEXT_PR : std_logic_vector(15 downto 0);
	signal INTERNAL_WRITE_GR_FLAG : std_logic;
	signal INTERNAL_WRITE_PR_FLAG : std_logic;
begin
	INTERNAL_WRITE_GR_FLAG <= '1';
	INTERNAL_WRITE_PR_FLAG <= '1';	

	OP_IS_LAD_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and (not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0));

	-- ここで結果を切り替える
	PR_ADDER : adder_16bit port map( CI => '0', AIN => CURRENT_PR, BIN => "0000000000000010", SUM(15 downto 0) => PR_WORD_ADDED);	
	
	NEXT_PR_MX : multiplexer_16bit_2ways port map( SELECTOR => RESET_IN, 
	DATA_IN_1 => PR_WORD_ADDED, 
	DATA_IN_2 => "0000000000000000", -- reset
	DATA_OUT => INTERNAL_NEXT_PR );
	
	GR_REGISTER : register_1 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => INTERNAL_WRITE_GR_FLAG, DATA_OUT => WRITE_GR_FLAG);
	PR_REGISTER : register_1 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => INTERNAL_WRITE_PR_FLAG, DATA_OUT => WRITE_PR_FLAG);
	NEXT_PR_REGISTER : register_16 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => INTERNAL_NEXT_PR, DATA_OUT => NEXT_PR);
end RTL;
