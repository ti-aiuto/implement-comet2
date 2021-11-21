library IEEE;
use IEEE.std_logic_1164.all;

entity phase_execute is
	port(
		CLK : in std_logic;
		EFFECTIVE_ADDR : in std_logic_vector(15 downto 0);
		RAM_DATA : in std_logic_vector(15 downto 0);
		GRA_DATA : in std_logic_vector(15 downto 0);
		GRB_DATA : in std_logic_vector(15 downto 0); 
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		FR_OUT : out std_logic_vector(2 downto 0)
	);
end phase_execute;

architecture RTL of phase_execute is

component alu is
	port(
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		SUB_FLAG : in std_logic;
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

signal USE_RAM_ADDR_AS_DATA_FLAG : std_logic;
signal EFFECTIVE_ADDR_OR_RAM_OUT : std_logic_vector(15 downto 0);

signal USE_ZERO_AS_GRA_FLAG: std_logic;
signal GRA_OR_ZERO: std_logic_vector(15 downto 0);

signal USE_RAM_AS_GRB_FLAG : std_logic;
signal GRB_OR_RAM : std_logic_vector(15 downto 0);

signal INTERNAL_ALU_OF : std_logic;
signal INTERNAL_ALU_DATA : std_logic_vector(15 downto 0);
signal INTERNAL_ALU_DATA_OR : std_logic;
signal INTERNAL_FR_DATA : std_logic_vector(2 downto 0);

signal MAIN_OP_IS_CP_FLAG : std_logic;
signal OP_IS_LD_FLAG : std_logic;
signal OP_IS_LAD_FLAG : std_logic;
signal OP_IS_ADD_FLAG : std_logic;
signal OP_IS_SUB_FLAG : std_logic;

begin
	PARSE_OP : parse_op_as_flag port map(
		MAIN_OP => MAIN_OP,
		SUB_OP => SUB_OP,
		MAIN_OP_IS_CP_FLAG => MAIN_OP_IS_CP_FLAG,
		OP_IS_LD_FLAG => OP_IS_LD_FLAG, 
		OP_IS_LAD_FLAG => OP_IS_LAD_FLAG, 
		OP_IS_ADD_FLAG => OP_IS_ADD_FLAG, 
		OP_IS_SUB_FLAG => OP_IS_SUB_FLAG
	);

	USE_RAM_ADDR_AS_DATA_FLAG <= OP_IS_LAD_FLAG;
	USE_ZERO_AS_GRA_FLAG <= OP_IS_LAD_FLAG OR OP_IS_LD_FLAG;
	USE_RAM_AS_GRB_FLAG <= OP_IS_LAD_FLAG;
	
	RAM_MX : multiplexer_16bit_2ways port map( SELECTOR => USE_RAM_ADDR_AS_DATA_FLAG, 
	DATA_IN_1 => RAM_DATA,
	DATA_IN_2 => EFFECTIVE_ADDR,
	DATA_OUT	=> EFFECTIVE_ADDR_OR_RAM_OUT);

	MX_GRA_OR_ZERO : multiplexer_16bit_2ways port map( SELECTOR => USE_ZERO_AS_GRA_FLAG, 
	DATA_IN_1 => GRA_DATA, 
	DATA_IN_2 => "0000000000000000", 
	DATA_OUT => GRA_OR_ZERO);
	
	USE_RAM_AS_GRB_FLAG <= OP_IS_LAD_FLAG;
	MX_GRB_OR_RAM : multiplexer_16bit_2ways port map( SELECTOR => USE_RAM_AS_GRB_FLAG, 
	DATA_IN_1 => GRB_DATA, 
	DATA_IN_2 => EFFECTIVE_ADDR_OR_RAM_OUT, 
	DATA_OUT => GRB_OR_RAM);
				
	ALU_INSTANCE : alu port map(SUB_FLAG => OP_IS_SUB_FLAG or MAIN_OP_IS_CP_FLAG, -- 引き算に切り替え
	DATA_IN_A => GRA_OR_ZERO, 
	DATA_IN_B => GRB_OR_RAM, 
	DATA_OUT => INTERNAL_ALU_DATA, 
	OF_OUT => INTERNAL_ALU_OF);

	OR_FR_IN : or_in_16bit_out_1bit port map( 
		DATA_IN => INTERNAL_ALU_DATA, 
		DATA_OUT => INTERNAL_ALU_DATA_OR
	);
	
	-- ZF, SF, OFの順
	INTERNAL_FR_DATA(0) <= INTERNAL_ALU_OF;
	INTERNAL_FR_DATA(1) <= INTERNAL_ALU_DATA(15); -- 最上位ビット
	INTERNAL_FR_DATA(2) <= not INTERNAL_ALU_DATA_OR;
	
	ALU_DATA_REGISTER : register_16 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => INTERNAL_ALU_DATA, DATA_OUT => DATA_OUT);
	ALU_FR_REGISTER : register_4 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => "0" & INTERNAL_FR_DATA, DATA_OUT(2 downto 0) => FR_OUT);
end RTL;
