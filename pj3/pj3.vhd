library IEEE;
use IEEE.std_logic_1164.all;

entity pj3 is
	port 
	(
		RESET_IN : in std_logic;
		CLK_IN : in std_logic;
		SEG7A : out std_logic_vector(6 downto 0);
		DIGITA_SELECT : out std_logic_vector(5 downto 0);
		SEG7B : out std_logic_vector(6 downto 0);
		DIGITB_SELECT : out std_logic_vector(5 downto 0);
		STATE_LED1 : out std_logic
	);
end pj3;

architecture RTL of pj3 is

component clock_down
	port(
		CLK_IN : in std_logic;
		CLK_OUT : out std_logic
	);
end component;

component clock_down_dynamyc_7seg
	port(
		CLK_IN : in std_logic;
		CLK_OUT : out std_logic
	);
end component;

component clk_gen
	port(
		CLK : in std_logic;
		CLK_FT1 : out std_logic;
		CLK_FT2LOAD: out std_logic;
		CLK_FT2 : out std_logic;
		CLK_DC : out std_logic;
		CLK_MA : out std_logic;
		CLK_EX : out std_logic;
		CLK_WB : out std_logic
	);
end component;

component bin_16_dec_dynamic_6
	port( CLK_IN : in std_logic;
	BIN_IN : in std_logic_vector(15 downto 0);
		SEG7 : out std_logic_vector(6 downto 0);
		DIGIT_SELECT : out std_logic_vector(5 downto 0) 
	);
end component;

component register_16 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
	);
end component;

component prom is
	port(
		P_COUNT : in std_logic_vector(15 downto 0);
		PROM_OUT : out std_logic_vector(15 downto 0)
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

component multiplexer_16bit_2ways is
	port(
		SELECTOR : in std_logic;
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
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

component alu is
	port(
		MAIN_OP : in std_logic_vector(3 downto 0);
		SUB_OP : in std_logic_vector(3 downto 0);
		DATA_IN_A: in std_logic_vector(15 downto 0);
		DATA_IN_B: in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0);
		DATA_OF : out std_logic
	);
end component;

component phase_decode is
	port(
		CLK : in std_logic;
		OP1_IN : std_logic_vector(15 downto 0);
		OP2_IN : std_logic_vector(15 downto 0);
		GR0_IN : in std_logic_vector(15 downto 0);
		GR1_IN : in std_logic_vector(15 downto 0);
		GR2_IN : in std_logic_vector(15 downto 0);
		GR3_IN : in std_logic_vector(15 downto 0);
		GR4_IN : in std_logic_vector(15 downto 0);
		GR5_IN : in std_logic_vector(15 downto 0);
		GR6_IN : in std_logic_vector(15 downto 0);
		GR7_IN : in std_logic_vector(15 downto 0);
		GRA_SELECT : out std_logic_vector(2 downto 0);
		GRA_OUT : out std_logic_vector(15 downto 0);
		GRB_OUT : out std_logic_vector(15 downto 0);
		MAIN_OP : out std_logic_vector(3 downto 0);
		SUB_OP : out std_logic_vector(3 downto 0);
		EFFECTIVE_ADDR : out std_logic_vector(15 downto 0)
	);
end component;

component phase_fetch is
	port(
		CLK_FT1 : in std_logic;
		CLK_FT2LOAD : in std_logic;
		CLK_FT2 : in std_logic;
		PR_IN : in std_logic_vector(15 downto 0);
		PROM_DATA : in std_logic_vector(15 downto 0);
		PROM_ADDR : out std_logic_vector(15 downto 0);
		OP1_OUT : out std_logic_vector(15 downto 0);
		OP2_OUT : out std_logic_vector(15 downto 0);
		CURRENT_PR : out std_logic_vector(15 downto 0)
	);
end component;

signal CLK_SLOW_7SEG : std_logic;
signal CLK_SLOW : std_logic;

signal CLK_FT1 : std_logic;
signal CLK_FT2LOAD : std_logic;
signal CLK_FT2 : std_logic;
signal CLK_DC : std_logic;
signal CLK_MA : std_logic;
signal CLK_EX : std_logic;
signal CLK_WB : std_logic;

signal OP1_OUT : std_logic_vector(15 downto 0);
signal OP2_OUT : std_logic_vector(15 downto 0);
signal PROM_DATA : std_logic_vector(15 downto 0);
signal PROM_ADDR : std_logic_vector(15 downto 0);

signal PR_WRITE_FLAG : std_logic;
signal PR_WORD_ADDED : std_logic_vector(15 downto 0);
signal NEXT_PR_IN : std_logic_vector(15 downto 0);
signal PR_OUT : std_logic_vector(15 downto 0);
signal CURRENT_PR : std_logic_vector(15 downto 0);

signal GR_WRITE_FLAG : std_logic;
signal NEXT_GR_DATA : std_logic_vector(15 downto 0);

signal GR0_OUT : std_logic_vector(15 downto 0);
signal GR1_OUT : std_logic_vector(15 downto 0);
signal GR2_OUT : std_logic_vector(15 downto 0);
signal GR3_OUT : std_logic_vector(15 downto 0);
signal GR4_OUT : std_logic_vector(15 downto 0);
signal GR5_OUT : std_logic_vector(15 downto 0);
signal GR6_OUT : std_logic_vector(15 downto 0);
signal GR7_OUT : std_logic_vector(15 downto 0);

signal MAIN_OP : std_logic_vector(3 downto 0);
signal SUB_OP : std_logic_vector(3 downto 0);

signal GRA_SELECT : std_logic_vector(2 downto 0);
signal GRB_SELECT : std_logic_vector(2 downto 0);
signal GRA_OUT : std_logic_vector(15 downto 0);
signal GRB_OUT : std_logic_vector(15 downto 0);
signal GRA_OUT_REG_OUT : std_logic_vector(15 downto 0);
signal GRB_OUT_REG_OUT : std_logic_vector(15 downto 0);


signal USE_RAM_ADDR_AS_DATA_FLAG : std_logic;
signal EFFECTIVE_ADDR : std_logic_vector(15 downto 0);
signal EFFECTIVE_ADDR_OR_RAM_OUT : std_logic_vector(15 downto 0);
signal EFFECTIVE_ADDR_OR_RAM_OUT_REG_OUT : std_logic_vector(15 downto 0);

signal ALU_DATA : std_logic_vector(15 downto 0);
signal ALU_DATA_REG_OUT : std_logic_vector(15 downto 0);

signal USE_ZERO_AS_GRA_FLAG: std_logic;
signal GRA_OR_ZERO: std_logic_vector(15 downto 0);
signal ALU_DATA_IN_A: std_logic_vector(15 downto 0);

signal USE_RAM_AS_GRB_FLAG : std_logic;
signal GRB_OR_RAM : std_logic_vector(15 downto 0);
signal ALU_DATA_IN_B: std_logic_vector(15 downto 0);

signal OP_IS_LAD_FLAG : std_logic;

begin
	CLOCK_7SEG_COMPONENT : clock_down_dynamyc_7seg port map(CLK_IN => CLK_IN, CLK_OUT => CLK_SLOW_7SEG);
	CLOCK_COMPONENT: clock_down port map(CLK_IN => CLK_IN, CLK_OUT => CLK_SLOW);
	CLOCK_GEN_COMPONENT: clk_gen port map(
	CLK => CLK_SLOW,
	CLK_FT1 => CLK_FT1, 
	CLK_FT2LOAD => CLK_FT2LOAD,
	CLK_FT2 => CLK_FT2, 
	CLK_DC => CLK_DC, 
	CLK_MA => CLK_MA, 
	CLK_EX => CLK_EX, 
	CLK_WB => CLK_WB);
	
	STATE_LED1 <= CLK_FT1;
	ROM : prom port map(P_COUNT => PROM_ADDR, PROM_OUT => PROM_DATA);

	PR_ADDER : adder_16bit port map( CI => '0', AIN => CURRENT_PR, BIN => "0000000000000010", SUM(15 downto 0) => PR_WORD_ADDED);	
	PR : register_16 port map(CLK_IN => CLK_WB and PR_WRITE_FLAG, DATA_IN => NEXT_PR_IN, DATA_OUT => PR_OUT);

	NEXT_PR_MX : multiplexer_16bit_2ways port map( SELECTOR => RESET_IN, 
	DATA_IN_1 => PR_WORD_ADDED, 
	DATA_IN_2 => "0000000000000000", 
	DATA_OUT => NEXT_PR_IN );
	
	PR_WRITE_FLAG <= '1';	

	PHASE_FETCH_COMPONENT : phase_fetch port map(
		CLK_FT1 => CLK_FT1, 
		CLK_FT2LOAD => CLK_FT2LOAD, 
		CLK_FT2 => CLK_FT2, 
		PR_IN => PR_OUT, 
		PROM_DATA => PROM_DATA, 
		PROM_ADDR => PROM_ADDR, 
		OP1_OUT => OP1_OUT, 
		OP2_OUT => OP2_OUT, 
		CURRENT_PR => CURRENT_PR
	);
	
	PHASE_DECODE_INSTANCE : phase_decode port map(
		CLK => CLK_DC, 
		OP1_IN => OP1_OUT,
		OP2_IN => OP2_OUT,
		GR0_IN => GR0_OUT,
		GR1_IN => GR1_OUT,
		GR2_IN => GR2_OUT,
		GR3_IN => GR3_OUT,
		GR4_IN => GR4_OUT,
		GR5_IN => GR5_OUT,
		GR6_IN => GR6_OUT,
		GR7_IN => GR7_OUT,
		GRA_SELECT => GRA_SELECT, 
		GRA_OUT => GRA_OUT, 
		GRB_OUT => GRB_OUT, 
		MAIN_OP => MAIN_OP, 
		SUB_OP => SUB_OP, 
		EFFECTIVE_ADDR => EFFECTIVE_ADDR
	);
	
	-- 仮実装
	GR_WRITE_FLAG <= '1';
	
	GR_CONTROLLER_INSTANCE : gr_controller port map( CLK => CLK_WB, 
	GR_WRITE_FLAG => GR_WRITE_FLAG, 
	GR_WRITE_SELECT => GRA_SELECT, 
	GR_WRITE_DATA => NEXT_GR_DATA, 
	GR0_OUT => GR0_OUT, 
	GR1_OUT => GR1_OUT, 
	GR2_OUT => GR2_OUT, 
	GR3_OUT => GR3_OUT, 
	GR4_OUT => GR4_OUT, 
	GR5_OUT => GR5_OUT, 
	GR6_OUT => GR6_OUT, 
	GR7_OUT => GR7_OUT);
	
	-- ここにどの命令か判定するフラグを作っていく
	OP_IS_LAD_FLAG <= (not MAIN_OP(3) and not MAIN_OP(2) and not MAIN_OP(1) and MAIN_OP(0)) and (not SUB_OP(3) and not SUB_OP(2) and SUB_OP(1) and not SUB_OP(0));
	
	USE_RAM_ADDR_AS_DATA_FLAG <= OP_IS_LAD_FLAG;

	RAM_MX : multiplexer_16bit_2ways port map( SELECTOR => USE_RAM_ADDR_AS_DATA_FLAG, 
	DATA_IN_1 => "0000000000000000", -- ここにRAMからの値を入れる
	DATA_IN_2 => EFFECTIVE_ADDR,
	DATA_OUT	=> EFFECTIVE_ADDR_OR_RAM_OUT);
	
	RAM_DATA_REGISTER : register_16 port map( CLK_IN => CLK_MA, 
	DATA_IN => EFFECTIVE_ADDR_OR_RAM_OUT, 
	DATA_OUT => EFFECTIVE_ADDR_OR_RAM_OUT_REG_OUT);
	
	USE_ZERO_AS_GRA_FLAG <= OP_IS_LAD_FLAG;
	
	MX_GRA_OR_ZERO : multiplexer_16bit_2ways port map( SELECTOR => USE_ZERO_AS_GRA_FLAG, 
	DATA_IN_1 => GRA_OUT, 
	DATA_IN_2 => "0000000000000000", 
	DATA_OUT => GRA_OR_ZERO);
	
	USE_RAM_AS_GRB_FLAG <= OP_IS_LAD_FLAG;
	MX_GRB_OR_RAM : multiplexer_16bit_2ways port map( SELECTOR => USE_RAM_AS_GRB_FLAG, 
	DATA_IN_1 => GRB_OUT, 
	DATA_IN_2 => EFFECTIVE_ADDR_OR_RAM_OUT_REG_OUT, 
	DATA_OUT => GRB_OR_RAM);
		
	ALU_INSTANCE : alu port map(MAIN_OP => MAIN_OP, 
	SUB_OP => SUB_OP, 
	DATA_IN_A => GRA_OR_ZERO, 
	DATA_IN_B => GRB_OR_RAM, 
	DATA_OUT => ALU_DATA);
	
	ALU_DATA_REGISTER : register_16 port map(CLK_IN => CLK_EX, DATA_IN => ALU_DATA, DATA_OUT => ALU_DATA_REG_OUT);

	NEXT_GR_DATA <= ALU_DATA_REG_OUT;
	-- ここにRAMに入れる実装もいる
		
	DEC1 : bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW_7SEG,
	BIN_IN => GR1_OUT, 
	SEG7 => SEG7A, 
	DIGIT_SELECT => DIGITA_SELECT);

	DEC2: bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW_7SEG,
	BIN_IN => GR2_OUT, 
	SEG7 => SEG7B, 
	DIGIT_SELECT => DIGITB_SELECT);
end RTL;
	