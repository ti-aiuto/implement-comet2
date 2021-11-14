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
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
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
		DATA_IN : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

signal USE_RAM_ADDR_AS_DATA_FLAG : std_logic;
signal EFFECTIVE_ADDR_OR_RAM_OUT : std_logic_vector(15 downto 0);

signal USE_ZERO_AS_GRA_FLAG: std_logic;
signal GRA_OR_ZERO: std_logic_vector(15 downto 0);

signal USE_RAM_AS_GRB_FLAG : std_logic;
signal GRB_OR_RAM : std_logic_vector(15 downto 0);

signal INTERNAL_ALU_DATA : std_logic_vector(15 downto 0);

signal OP_IS_LAD_FLAG : std_logic; -- これ切り出すか？

begin
	OP_IS_LAD_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and (not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0));

	USE_RAM_ADDR_AS_DATA_FLAG <= OP_IS_LAD_FLAG;
	USE_ZERO_AS_GRA_FLAG <= OP_IS_LAD_FLAG;
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
			
	USE_ZERO_AS_GRA_FLAG <= OP_IS_LAD_FLAG;
	
	ALU_INSTANCE : alu port map(MAIN_OP => MAIN_OP, 
	SUB_OP => SUB_OP, 
	DATA_IN_A => GRA_OR_ZERO, 
	DATA_IN_B => GRB_OR_RAM, 
	DATA_OUT => INTERNAL_ALU_DATA);

	ALU_DATA_REGISTER : register_16 port map(CLK_IN => CLK, DATA_IN => INTERNAL_ALU_DATA, DATA_OUT => DATA_OUT);
end RTL;
