library IEEE;
use IEEE.std_logic_1164.all;

entity phase_write_back is
	port(
		CLK : in std_logic;
		RESET_IN : in std_logic;
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);
		CURRENT_PR : in std_logic_vector(15 downto 0);
		CURRENT_FR : in std_logic_vector(2 downto 0);
		EFFECTIVE_ADDR : in std_logic_vector(15 downto 0);
		NEXT_PR : out std_logic_vector(15 downto 0);
		WRITE_GR_FLAG : out std_logic;
		WRITE_PR_FLAG : out std_logic; 
		WRITE_FR_FLAG : out std_logic
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

component or_4bit_to_1bit is
	port( 
	DATA_IN : in std_logic_vector(3 downto 0); 
	DATA_OUT : out std_logic
	);
end component;

component parse_op_as_flag is
	port(
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);			
		MAIN_OP_IS_LD_ST_LAD_FLAG : out std_logic;
		MAIN_OP_IS_ADD_SUB_FLAG : out std_logic;
		MAIN_OP_IS_CP_FLAG : out std_logic;
		MAIN_OP_IS_JP_FLAG : out std_logic;
		OP_IS_LD_FLAG : out std_logic;
		OP_IS_LAD_FLAG : out std_logic;
		OP_IS_JMI_FLAG : out std_logic;
		OP_IS_JNZ_FLAG : out std_logic;
		OP_IS_JZE_FLAG : out std_logic;
		OP_IS_JUMP_FLAG : out std_logic;
		OP_IS_JPL_FLAG : out std_logic;
		OP_IS_JOV_FLAG : out std_logic;
		OP_IS_ADD_FLAG : out std_logic;
		OP_IS_SUB_FLAG : out std_logic;
		OP_LENGTH_IS_TWO_FLAG: out std_logic;
		OP_NEEDS_WRITE_GR_FLAG: out std_logic;
		OP_NEEDS_WRITE_FR_FLAG: out std_logic;
		OP_NEEDS_WRITE_PR_FLAG: out std_logic
	);
end component;

	signal MAIN_OP_IS_JP_FLAG : std_logic;
	signal OP_IS_JMI_FLAG : std_logic;
	signal OP_IS_JNZ_FLAG : std_logic;
	signal OP_IS_JZE_FLAG : std_logic;
	signal OP_IS_JUMP_FLAG : std_logic;
	signal OP_IS_JPL_FLAG : std_logic;
	signal OP_IS_JOV_FLAG : std_logic;
	signal OP_LENGTH_IS_TWO_FLAG: std_logic;
	signal OP_NEEDS_WRITE_GR_FLAG: std_logic;
	signal OP_NEEDS_WRITE_FR_FLAG: std_logic;
	signal OP_NEEDS_WRITE_PR_FLAG: std_logic;

	signal USE_JP_FLAG: std_logic;

	signal WORDS_COUNT_TO_ADD : std_logic_vector(15 downto 0);
	signal PR_WORD_ADDED : std_logic_vector(15 downto 0);
	signal NEXT_PR_OR_JP_ADDR : std_logic_vector(15 downto 0);
	
	signal WRITE_PR_OP_OR_RESET_FLAG : std_logic;
begin
	PARSE_OP : parse_op_as_flag port map(
		MAIN_OP => MAIN_OP,
		SUB_OP => SUB_OP,
		MAIN_OP_IS_JP_FLAG => MAIN_OP_IS_JP_FLAG, 
		OP_IS_JMI_FLAG => OP_IS_JMI_FLAG, 
		OP_IS_JNZ_FLAG => OP_IS_JNZ_FLAG, 
		OP_IS_JZE_FLAG => OP_IS_JZE_FLAG, 
		OP_IS_JUMP_FLAG => OP_IS_JUMP_FLAG, 
		OP_IS_JPL_FLAG => OP_IS_JPL_FLAG, 
		OP_IS_JOV_FLAG => OP_IS_JOV_FLAG, 
		OP_LENGTH_IS_TWO_FLAG => OP_LENGTH_IS_TWO_FLAG, 
		OP_NEEDS_WRITE_GR_FLAG => OP_NEEDS_WRITE_GR_FLAG, 
		OP_NEEDS_WRITE_FR_FLAG => OP_NEEDS_WRITE_FR_FLAG, 
		OP_NEEDS_WRITE_PR_FLAG => OP_NEEDS_WRITE_PR_FLAG
	);

	WORD_COUNT_MUX : multiplexer_16bit_2ways port map(
		SELECTOR => OP_LENGTH_IS_TWO_FLAG, 
		DATA_IN_1 => "0000000000000001", 
		DATA_IN_2 => "0000000000000010", 
		DATA_OUT => WORDS_COUNT_TO_ADD
	);
	PR_ADDER : adder_16bit port map( CI => '0', AIN => CURRENT_PR, BIN => WORDS_COUNT_TO_ADD, SUM(15 downto 0) => PR_WORD_ADDED);	
	
	-- このへんはWBの立ち上がりで使うものなのでレジスタで覚えない
	WRITE_PR_OP_OR_RESET_FLAG <= RESET_IN OR OP_NEEDS_WRITE_PR_FLAG;
	
	USE_JP_FLAG <= (OP_IS_JMI_FLAG and CURRENT_FR(1))
		or (OP_IS_JNZ_FLAG and not CURRENT_FR(2))
		or (OP_IS_JZE_FLAG and CURRENT_FR(2))
		or OP_IS_JUMP_FLAG
		or (OP_IS_JPL_FLAG and not CURRENT_FR(1) and not CURRENT_FR(2))
		or (OP_IS_JOV_FLAG and CURRENT_FR(0));
	
	NEXT_OR_JP_MUX : multiplexer_16bit_2ways port map(
		SELECTOR => MAIN_OP_IS_JP_FLAG and USE_JP_FLAG, 
		DATA_IN_1 => PR_WORD_ADDED, 
		DATA_IN_2 => EFFECTIVE_ADDR, 
		DATA_OUT => NEXT_PR_OR_JP_ADDR
	);
	
	-- execにうつしてもいいかも
	NEXT_PR_MX : multiplexer_16bit_2ways port map( SELECTOR => RESET_IN, 
	DATA_IN_1 => NEXT_PR_OR_JP_ADDR, 
	DATA_IN_2 => "0000000000000000", -- reset
	DATA_OUT => NEXT_PR );
	
	WRITE_GR_FLAG <= OP_NEEDS_WRITE_GR_FLAG;
	WRITE_PR_FLAG <= WRITE_PR_OP_OR_RESET_FLAG;
	WRITE_FR_FLAG <= OP_NEEDS_WRITE_FR_FLAG;
end RTL;
