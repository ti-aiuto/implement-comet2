library IEEE;
use IEEE.std_logic_1164.all;

entity phase_execute is
	port(
		CLK : in std_logic; 
		RESET_IN : in std_logic;
		EFFECTIVE_ADDR_IN : in std_logic_vector(15 downto 0);
		RAM_IN : in std_logic_vector(15 downto 0);
		GRA_IN : in std_logic_vector(15 downto 0);
		GRB_IN : in std_logic_vector(15 downto 0); 
		MAIN_OP_IN : in std_logic_vector(3 downto 0);
		SUB_OP_IN : in std_logic_vector(3 downto 0);
		PR_IN : in std_logic_vector(15 downto 0);
		FR_IN : in std_logic_vector(2 downto 0);
		NEXT_DATA : out std_logic_vector(15 downto 0);
		NEXT_FR : out std_logic_vector(2 downto 0);
		NEXT_PR : out std_logic_vector(15 downto 0);
		WRITE_GR_FLAG : out std_logic;
		WRITE_PR_FLAG : out std_logic; 
		WRITE_FR_FLAG : out std_logic
	);
end phase_execute;

architecture RTL of phase_execute is

component alu is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		SUB_FLAG : in std_logic;
		LOGICAL_MODE_FLAG : in std_logic;
		DATA_OUT : out std_logic_vector(15 downto 0);
		OF_OUT : out std_logic
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

component register_1 is
	port(
		CLK_IN : in std_logic;
		WRITE_FLAG : in std_logic;
		DATA_IN : in std_logic;
		DATA_OUT : out std_logic
	);
end component;

component or_in_16bit_out_1bit is
	port( 
	DATA_IN : in std_logic_vector(15 downto 0); 
	DATA_OUT : out std_logic
	);
end component;

component parse_op_as_flag is
	port(
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);			
		MAIN_OP_IS_LD_ST_LAD_FLAG : out std_logic;
		MAIN_OP_IS_ADD_SUB_FLAG : out std_logic;
		MAIN_OP_IS_LOGICAL_CALC_FLAG : out std_logic;
		MAIN_OP_IS_CP_FLAG : out std_logic;
		MAIN_OP_IS_JP_FLAG : out std_logic;
		MAIN_OP_IS_SHIFT_FLAG : out std_logic;
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
		OP_IS_SHIFT_RIGHT_FLAG : out std_logic;
		OP_IS_LOGICAL_MODE_FLAG : out std_logic;
		OP_LENGTH_IS_TWO_FLAG: out std_logic;
		OP_NEEDS_WRITE_GR_FLAG: out std_logic;
		OP_NEEDS_WRITE_FR_FLAG: out std_logic;
		OP_NEEDS_WRITE_PR_FLAG: out std_logic
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

signal EFFECTIVE_ADDR_OR_RAM_OUT : std_logic_vector(15 downto 0);

signal USE_ZERO_AS_GRA_FLAG: std_logic;
signal GRA_OR_ZERO: std_logic_vector(15 downto 0);

signal USE_RAM_AS_GRB_FLAG : std_logic;
signal GRB_OR_RAM : std_logic_vector(15 downto 0);

signal INTERNAL_ALU_OF : std_logic;
signal INTERNAL_ALU_DATA : std_logic_vector(15 downto 0);
signal INTERNAL_ALU_DATA_OR : std_logic;
signal INTERNAL_NEXT_OF: std_logic;
signal INTERNAL_NEXT_SF: std_logic;
signal INTERNAL_NEXT_ZF: std_logic;

signal MAIN_OP_IS_JP_FLAG : std_logic;
signal MAIN_OP_IS_LOGICAL_CALC_FLAG: std_logic;
signal MAIN_OP_IS_CP_FLAG : std_logic;
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
signal OP_IS_LD_FLAG : std_logic;
signal OP_IS_LAD_FLAG : std_logic;
signal OP_IS_SUB_FLAG : std_logic;
signal OP_IS_SHIFT_RIGHT_FLAG: std_logic;
signal OP_IS_LOGICAL_MODE_FLAG: std_logic;

signal USE_JP_FLAG: std_logic;

signal WORDS_COUNT_TO_ADD : std_logic_vector(15 downto 0);
signal PR_WORD_ADDED : std_logic_vector(15 downto 0);
signal NEXT_PR_OR_JP_ADDR : std_logic_vector(15 downto 0);
signal INTERNAL_NEXT_PR : std_logic_vector(15 downto 0);

begin
	USE_ZERO_AS_GRA_FLAG <= OP_IS_LAD_FLAG OR OP_IS_LD_FLAG;
	USE_RAM_AS_GRB_FLAG <= OP_IS_LAD_FLAG; -- TODO: データBをRAMから読み込む2語命令をここに追加
	
	REGISTER_WRITE_GR : register_1 port map(
		CLK_IN => CLK, 
		WRITE_FLAG => '1', 
		DATA_IN => OP_NEEDS_WRITE_GR_FLAG, 
		DATA_OUT => WRITE_GR_FLAG
	);
	REGISTER_WRITE_PR : register_1 port map(
		CLK_IN => CLK, 
		WRITE_FLAG => '1', 
		DATA_IN => RESET_IN OR OP_NEEDS_WRITE_PR_FLAG, 
		DATA_OUT => WRITE_PR_FLAG
	);
	REGISTER_WRITE_FR : register_1 port map(
		CLK_IN => CLK, 
		WRITE_FLAG => '1', 
		DATA_IN => OP_NEEDS_WRITE_FR_FLAG, 
		DATA_OUT => WRITE_FR_FLAG
	);
		
	RAM_MX : multiplexer_16bit_2ways port map(
		SELECTOR => OP_IS_LAD_FLAG, -- LADの場合はRAM値ではなくRAM番地をデータBとして使う
		DATA_IN_1 => RAM_IN,
		DATA_IN_2 => EFFECTIVE_ADDR_IN,
		DATA_OUT	=> EFFECTIVE_ADDR_OR_RAM_OUT
	);

	MX_GRA_OR_ZERO : multiplexer_16bit_2ways port map(
		SELECTOR => USE_ZERO_AS_GRA_FLAG, 
		DATA_IN_1 => GRA_IN, 
		DATA_IN_2 => "0000000000000000", 
		DATA_OUT => GRA_OR_ZERO
	);
	
	MX_GRB_OR_RAM : multiplexer_16bit_2ways port map(
		SELECTOR => USE_RAM_AS_GRB_FLAG, 
		DATA_IN_1 => GRB_IN, 
		DATA_IN_2 => EFFECTIVE_ADDR_OR_RAM_OUT, 
		DATA_OUT => GRB_OR_RAM
	);
				
	ALU_INSTANCE : alu port map(
		SUB_FLAG => OP_IS_SUB_FLAG or MAIN_OP_IS_CP_FLAG, -- 引き算に切り替え
		LOGICAL_MODE_FLAG => OP_IS_LOGICAL_MODE_FLAG, 
		DATA_IN_A => GRA_OR_ZERO, 
		DATA_IN_B => GRB_OR_RAM, 
		DATA_OUT => INTERNAL_ALU_DATA, 
		OF_OUT => INTERNAL_ALU_OF
	);

	OR_FR_IN : or_in_16bit_out_1bit port map( 
		DATA_IN => INTERNAL_ALU_DATA, 
		DATA_OUT => INTERNAL_ALU_DATA_OR
	);
	
	INTERNAL_NEXT_OF <= INTERNAL_ALU_OF;
	INTERNAL_NEXT_SF <= INTERNAL_ALU_DATA(15); -- 最上位ビット
	INTERNAL_NEXT_ZF <= not INTERNAL_ALU_DATA_OR;
	
	ALU_DATA_REGISTER : register_16 port map(
		CLK_IN => CLK, 
		WRITE_FLAG => '1', 
		DATA_IN => INTERNAL_ALU_DATA, 
		DATA_OUT => NEXT_DATA
	);
	
	-- ZF, SF, OFの順
	ALU_FR_REGISTER : register_4 port map(
		CLK_IN => CLK, 
		WRITE_FLAG => '1', 
		DATA_IN => "0" & INTERNAL_NEXT_ZF & INTERNAL_NEXT_SF & INTERNAL_NEXT_OF, 
		DATA_OUT(2 downto 0) => NEXT_FR
	);
	
	PARSE_OP : parse_op_as_flag port map(
		MAIN_OP => MAIN_OP_IN,
		SUB_OP => SUB_OP_IN,
		MAIN_OP_IS_JP_FLAG => MAIN_OP_IS_JP_FLAG, 
		MAIN_OP_IS_LOGICAL_CALC_FLAG => MAIN_OP_IS_LOGICAL_CALC_FLAG, 
		MAIN_OP_IS_CP_FLAG => MAIN_OP_IS_CP_FLAG, 
		OP_IS_JMI_FLAG => OP_IS_JMI_FLAG, 
		OP_IS_JNZ_FLAG => OP_IS_JNZ_FLAG, 
		OP_IS_JZE_FLAG => OP_IS_JZE_FLAG, 
		OP_IS_JUMP_FLAG => OP_IS_JUMP_FLAG, 
		OP_IS_JPL_FLAG => OP_IS_JPL_FLAG, 
		OP_IS_JOV_FLAG => OP_IS_JOV_FLAG, 
		OP_IS_LD_FLAG => OP_IS_LD_FLAG, 
		OP_IS_LAD_FLAG => OP_IS_LAD_FLAG, 
		OP_IS_SUB_FLAG => OP_IS_SUB_FLAG,
		OP_IS_LOGICAL_MODE_FLAG => OP_IS_LOGICAL_MODE_FLAG, 
		OP_LENGTH_IS_TWO_FLAG => OP_LENGTH_IS_TWO_FLAG, 
		OP_NEEDS_WRITE_GR_FLAG => OP_NEEDS_WRITE_GR_FLAG, 
		OP_NEEDS_WRITE_FR_FLAG => OP_NEEDS_WRITE_FR_FLAG, 
		OP_NEEDS_WRITE_PR_FLAG => OP_NEEDS_WRITE_PR_FLAG
	);

	WORD_COUNT_MUX : multiplexer_16bit_2ways port map(
		SELECTOR => OP_LENGTH_IS_TWO_FLAG, 
		DATA_IN_1 => "0000000000000001", -- 1語命令
		DATA_IN_2 => "0000000000000010", -- 2語命令
		DATA_OUT => WORDS_COUNT_TO_ADD
	);
	PR_ADDER : adder_16bit port map(
		CI => '0', 
		AIN => PR_IN, 
		BIN => WORDS_COUNT_TO_ADD, 
		SUM(15 downto 0) => PR_WORD_ADDED
	);	
		
	USE_JP_FLAG <= (OP_IS_JMI_FLAG and FR_IN(1))
		or (OP_IS_JNZ_FLAG and not FR_IN(2))
		or (OP_IS_JZE_FLAG and FR_IN(2))
		or OP_IS_JUMP_FLAG
		or (OP_IS_JPL_FLAG and not FR_IN(1) and not FR_IN(2))
		or (OP_IS_JOV_FLAG and FR_IN(0));
	
	NEXT_OR_JP_MUX : multiplexer_16bit_2ways port map(
		SELECTOR => MAIN_OP_IS_JP_FLAG and USE_JP_FLAG, 
		DATA_IN_1 => PR_WORD_ADDED, 
		DATA_IN_2 => EFFECTIVE_ADDR_IN, 
		DATA_OUT => NEXT_PR_OR_JP_ADDR
	);
	
	NEXT_PR_MX : multiplexer_16bit_2ways port map(
		SELECTOR => RESET_IN, 
		DATA_IN_1 => NEXT_PR_OR_JP_ADDR, 
		DATA_IN_2 => "0000000000000000", -- reset
		DATA_OUT => INTERNAL_NEXT_PR
	);
	
	NEXT_PR_REGISTER : register_16 port map(
		CLK_IN => CLK, 
		WRITE_FLAG => '1', 
		DATA_IN => INTERNAL_NEXT_PR, 
		DATA_OUT => NEXT_PR
	);
end RTL;
