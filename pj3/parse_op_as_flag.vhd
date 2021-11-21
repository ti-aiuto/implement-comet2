library IEEE;
use IEEE.std_logic_1164.all;

entity parse_op_as_flag is
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
		OP_IS_SUB_FLAG : out std_logic
	);
end parse_op_as_flag;

architecture RTL of parse_op_as_flag is
	signal INTERNAL_MAIN_OP_IS_LD_ST_LAD_FLAG : std_logic;
	signal INTERNAL_MAIN_OP_IS_ADD_SUB_FLAG : std_logic;
	signal INTERNAL_MAIN_OP_IS_JP_FLAG : std_logic;
begin
	INTERNAL_MAIN_OP_IS_LD_ST_LAD_FLAG <= not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0);
	MAIN_OP_IS_LD_ST_LAD_FLAG <= INTERNAL_MAIN_OP_IS_LD_ST_LAD_FLAG;
	OP_IS_LD_FLAG <= INTERNAL_MAIN_OP_IS_LD_ST_LAD_FLAG and 
		((not SUB_OP(3) and not SUB_OP(2) and not SUB_OP(1) and not SUB_OP(0)) or (not SUB_OP(3) and SUB_OP(2) and not SUB_OP(1) and not SUB_OP(0)));
	OP_IS_LAD_FLAG <= INTERNAL_MAIN_OP_IS_LD_ST_LAD_FLAG and (not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0));

	MAIN_OP_IS_CP_FLAG <= not MAIN_OP(3) and MAIN_OP(2) and not MAIN_OP(1) and not MAIN_OP(0);

	INTERNAL_MAIN_OP_IS_JP_FLAG <= not MAIN_OP(3) and MAIN_OP(2) and MAIN_OP(1) and not MAIN_OP(0);
	MAIN_OP_IS_JP_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG;
	OP_IS_JMI_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG AND not SUB_OP(3) and not SUB_OP(2) and not SUB_OP(1) and SUB_OP(0);
	OP_IS_JNZ_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG AND not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0);
	OP_IS_JZE_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG AND not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and SUB_OP(0);
	OP_IS_JUMP_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG AND not SUB_OP(3) and SUB_OP(2) and not SUB_OP(1) and not SUB_OP(0);
	OP_IS_JPL_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG AND not SUB_OP(3) and SUB_OP(2) and not SUB_OP(1) and SUB_OP(0);
	OP_IS_JOV_FLAG <= INTERNAL_MAIN_OP_IS_JP_FLAG AND not SUB_OP(3) and SUB_OP(2) and SUB_OP(1) and not SUB_OP(0);
	
	INTERNAL_MAIN_OP_IS_ADD_SUB_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and MAIN_OP(1) and not MAIN_OP(0));
	MAIN_OP_IS_ADD_SUB_FLAG <= INTERNAL_MAIN_OP_IS_ADD_SUB_FLAG;
	OP_IS_ADD_FLAG <= INTERNAL_MAIN_OP_IS_ADD_SUB_FLAG AND not SUB_OP(0);
	OP_IS_SUB_FLAG <= INTERNAL_MAIN_OP_IS_ADD_SUB_FLAG AND SUB_OP(0);
end RTL;
