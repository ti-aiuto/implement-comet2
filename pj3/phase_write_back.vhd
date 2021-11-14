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

component or_4bit_to_1bit is
	port( 
	DATA_IN : in std_logic_vector(3 downto 0); 
	DATA_OUT : out std_logic
	);
end component;

	signal OP_IS_ADD_SUB_FLAG : std_logic;
	signal OP_IS_LD_FLAG : std_logic;
	signal OP_IS_LAD_FLAG : std_logic;
	signal OP_IS_LD_LAD_FLAG : std_logic;
	signal OP_IS_CP_FLAG : std_logic;

	signal WORD_LENGTH_2_FLAG : std_logic;

	signal WORDS_COUNT_TO_ADD : std_logic_vector(15 downto 0);
	signal PR_WORD_ADDED : std_logic_vector(15 downto 0);

begin
	OP_IS_LD_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and 
		((not SUB_OP(3) and not SUB_OP(2) and not SUB_OP(1) and not SUB_OP(0)) or (not SUB_OP(3) and SUB_OP(2) and not SUB_OP(1) and not SUB_OP(0)));
	OP_IS_LAD_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and (not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0));
	OP_IS_LD_LAD_FLAG <= OP_IS_LD_FLAG OR OP_IS_LAD_FLAG;
	OP_IS_ADD_SUB_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and MAIN_OP(1) and not MAIN_OP(0));
	OP_IS_CP_FLAG <= not MAIN_OP(3) and MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0);
	
	WORD_LENGTH_2_FLAG <= (OP_IS_LD_LAD_FLAG OR OP_IS_ADD_SUB_FLAG) AND (not SUB_OP(3) and not SUB_OP(2)); -- 0,1,2,3が2語命令
	
	WRITE_FR_FLAG <= OP_IS_LD_FLAG OR OP_IS_ADD_SUB_FLAG OR OP_IS_CP_FLAG;
	
	-- 1語命令か2語命令か判定
	WORD_COUNT_MUX : multiplexer_16bit_2ways port map(
		SELECTOR => WORD_LENGTH_2_FLAG, 
		DATA_IN_1 => "0000000000000001", 
		DATA_IN_2 => "0000000000000010", 
		DATA_OUT => WORDS_COUNT_TO_ADD
	);
	-- ここで足すか結果を切り替える
	PR_ADDER : adder_16bit port map( CI => '0', AIN => CURRENT_PR, BIN => WORDS_COUNT_TO_ADD, SUM(15 downto 0) => PR_WORD_ADDED);	
	
	-- このへんはWBの立ち上がりで使うものなのでレジスタで覚えない
	WRITE_GR_FLAG <= OP_IS_LD_LAD_FLAG OR OP_IS_ADD_SUB_FLAG;
	WRITE_PR_FLAG <= RESET_IN OR OP_IS_LD_LAD_FLAG OR OP_IS_ADD_SUB_FLAG;	
	
	-- execにうつしてもいいかも
	NEXT_PR_MX : multiplexer_16bit_2ways port map( SELECTOR => RESET_IN, 
	DATA_IN_1 => PR_WORD_ADDED, 
	DATA_IN_2 => "0000000000000000", -- reset
	DATA_OUT => NEXT_PR );
end RTL;
