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

signal USE_RAM_ADDR_AS_DATA_FLAG : std_logic;
signal EFFECTIVE_ADDR_OR_RAM_OUT : std_logic_vector(15 downto 0);

signal USE_ZERO_AS_GRA_FLAG: std_logic;
signal GRA_OR_ZERO: std_logic_vector(15 downto 0);

signal USE_RAM_AS_GRB_FLAG : std_logic;
signal GRB_OR_RAM : std_logic_vector(15 downto 0);

signal INTERNAL_ALU_OF : std_logic;
signal INTERNAL_ALU_DATA : std_logic_vector(15 downto 0);
signal INTERNAL_FR_DATA : std_logic_vector(2 downto 0);

signal OP_IS_LAD_FLAG : std_logic;
signal OP_IS_LD1_FLAG : std_logic;
signal OP_IS_ADD_SUB_FLAG : std_logic;
signal OP_IS_SUB_FLAG : std_logic;
signal OP_IS_CP_FLAG : std_logic;

begin
	OP_IS_LAD_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and (not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0));
	OP_IS_LD1_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and (not SUB_OP(3) and SUB_OP(2) and not SUB_OP(1) and not SUB_OP(0));
	
	-- 算術の場合
	OP_IS_ADD_SUB_FLAG <= not MAIN_OP(3) and not MAIN_OP(2) and MAIN_OP(1) and not MAIN_OP(0);
	OP_IS_SUB_FLAG <= OP_IS_ADD_SUB_FLAG AND SUB_OP(0);
	OP_IS_CP_FLAG <= not MAIN_OP(3) and MAIN_OP(2) and not MAIN_OP(1) and not MAIN_OP(0);
	
	USE_RAM_ADDR_AS_DATA_FLAG <= OP_IS_LAD_FLAG;
	USE_ZERO_AS_GRA_FLAG <= OP_IS_LAD_FLAG OR OP_IS_LD1_FLAG;
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
				
	ALU_INSTANCE : alu port map(SUB_FLAG => OP_IS_SUB_FLAG or OP_IS_CP_FLAG, -- 引き算に切り替え
	DATA_IN_A => GRA_OR_ZERO, 
	DATA_IN_B => GRB_OR_RAM, 
	DATA_OUT => INTERNAL_ALU_DATA, 
	OF_OUT => INTERNAL_ALU_OF);

	-- ZF, SF, OFの順
	INTERNAL_FR_DATA(0) <= INTERNAL_ALU_OF;
	INTERNAL_FR_DATA(1) <= INTERNAL_ALU_DATA(15); -- 最上位ビット
	INTERNAL_FR_DATA(2) <= not (INTERNAL_ALU_DATA(15) or INTERNAL_ALU_DATA(14) or INTERNAL_ALU_DATA(13) or INTERNAL_ALU_DATA(12) 
		or INTERNAL_ALU_DATA(11) or INTERNAL_ALU_DATA(10) or INTERNAL_ALU_DATA(9) or INTERNAL_ALU_DATA(8) 
		or INTERNAL_ALU_DATA(7) or INTERNAL_ALU_DATA(6) or INTERNAL_ALU_DATA(5) or INTERNAL_ALU_DATA(4) 
		or INTERNAL_ALU_DATA(3) or INTERNAL_ALU_DATA(2) or INTERNAL_ALU_DATA(1) or INTERNAL_ALU_DATA(0));
	
	ALU_DATA_REGISTER : register_16 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => INTERNAL_ALU_DATA, DATA_OUT => DATA_OUT);
	ALU_FR_REGISTER : register_4 port map(CLK_IN => CLK, WRITE_FLAG => '1', DATA_IN => "0" & INTERNAL_FR_DATA, DATA_OUT(2 downto 0) => FR_OUT);
end RTL;
