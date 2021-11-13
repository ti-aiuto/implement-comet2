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

component multiplexer_16bit_8ways is
	port(
		SELECTOR : in std_logic_vector(2 downto 0);
		DATA_IN_1 : in std_logic_vector(15 downto 0);
		DATA_IN_2 : in std_logic_vector(15 downto 0);
		DATA_IN_3 : in std_logic_vector(15 downto 0);
		DATA_IN_4 : in std_logic_vector(15 downto 0);
		DATA_IN_5 : in std_logic_vector(15 downto 0);
		DATA_IN_6 : in std_logic_vector(15 downto 0);
		DATA_IN_7 : in std_logic_vector(15 downto 0);
		DATA_IN_8 : in std_logic_vector(15 downto 0);
		DATA_OUT : out std_logic_vector(15 downto 0)
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
signal PROM_OUT : std_logic_vector(15 downto 0);

signal PR_WRITE_FLAG : std_logic;
signal PR_WORD_ADDED : std_logic_vector(15 downto 0);
signal NEXT_PR_IN : std_logic_vector(15 downto 0);
signal PR_OUT : std_logic_vector(15 downto 0);
signal PR_OUT_REG_OUT : std_logic_vector(15 downto 0);
signal PR_OUT_PLUS1 : std_logic_vector(15 downto 0);
signal PROM_ADDR_IN : std_logic_vector(15 downto 0);

signal GR0_OUT : std_logic_vector(15 downto 0);
signal GR1_OUT : std_logic_vector(15 downto 0);
signal GR2_OUT : std_logic_vector(15 downto 0);
signal GR3_OUT : std_logic_vector(15 downto 0);
signal GR4_OUT : std_logic_vector(15 downto 0);
signal GR5_OUT : std_logic_vector(15 downto 0);
signal GR6_OUT : std_logic_vector(15 downto 0);
signal GR7_OUT : std_logic_vector(15 downto 0);

signal GRA_SELECT : std_logic_vector(2 downto 0);
signal GRB_SELECT : std_logic_vector(2 downto 0);
signal GRA_OUT : std_logic_vector(15 downto 0);
signal GRB_OUT : std_logic_vector(15 downto 0);
signal GRA_OUT_REG_OUT : std_logic_vector(15 downto 0);
signal GRB_OUT_REG_OUT : std_logic_vector(15 downto 0);

signal OP2_PLUS_GRB : std_logic_vector(15 downto 0);
signal OP2_PLUS_GRB_REG_OUT : std_logic_vector(15 downto 0);

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
	
	REGISTER_CURRENT_PR : register_16 port map(CLK_IN => CLK_FT1, DATA_IN => PR_OUT, DATA_OUT => PR_OUT_REG_OUT);
	
	PROM_ADDER : adder_16bit port map( CI => '0', 
	AIN => PR_OUT_REG_OUT, 
	BIN => "0000000000000001", 
	SUM(15 downto 0) => PR_OUT_PLUS1);
	PROM_MX : multiplexer_16bit_2ways port map( SELECTOR => CLK_FT2LOAD or CLK_FT2,
	DATA_IN_1 => PR_OUT, 
	DATA_IN_2 => PR_OUT_PLUS1, 
	DATA_OUT => PROM_ADDR_IN );
	
	PR_ADDER : adder_16bit port map( CI => '0', AIN => PR_OUT_REG_OUT, BIN => "0000000000000010", SUM(15 downto 0) => PR_WORD_ADDED);	
	
	NEXT_PR_MX : multiplexer_16bit_2ways port map( SELECTOR => RESET_IN, 
	DATA_IN_1 => PR_WORD_ADDED, 
	DATA_IN_2 => "0000000000000000", 
	DATA_OUT => NEXT_PR_IN );
	
	PR_WRITE_FLAG <= '1';
	
	OP1_REGISTER : register_16 port map(CLK_IN => CLK_FT1, DATA_IN => PROM_OUT, DATA_OUT => OP1_OUT);
	OP2_REGISTER : register_16 port map(CLK_IN => CLK_FT2, DATA_IN => PROM_OUT, DATA_OUT => OP2_OUT);
	PR : register_16 port map(CLK_IN => CLK_WB and PR_WRITE_FLAG, DATA_IN => NEXT_PR_IN, DATA_OUT => PR_OUT);
	
	GR0 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000000000", DATA_OUT => GR0_OUT);
	GR1 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000001111", DATA_OUT => GR1_OUT);
	GR2 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000011111", DATA_OUT => GR2_OUT);
	GR3 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000000000", DATA_OUT => GR3_OUT);
	GR4 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000000000", DATA_OUT => GR4_OUT);
	GR5 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000000000", DATA_OUT => GR5_OUT);
	GR6 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000000000", DATA_OUT => GR6_OUT);
	GR7 : register_16 port map(CLK_IN => CLK_WB, DATA_IN => "0000000000000000", DATA_OUT => GR7_OUT);

	GRA_SELECT <= OP1_OUT(6 downto 4);
	GRB_SELECT <= OP1_OUT(2 downto 0);
	
	GRA_REGISTER : register_16 port map(CLK_IN => CLK_DC, DATA_IN => GRA_OUT, DATA_OUT => GRA_OUT_REG_OUT);
	GRB_REGISTER : register_16 port map(CLK_IN => CLK_DC, DATA_IN => GRB_OUT, DATA_OUT => GRB_OUT_REG_OUT);
	
	MX_GRA: multiplexer_16bit_8ways port map(
		SELECTOR => GRA_SELECT, 
		DATA_IN_1 => GR0_OUT, 
		DATA_IN_2 => GR1_OUT, 
		DATA_IN_3 => GR2_OUT, 
		DATA_IN_4 => GR3_OUT, 
		DATA_IN_5 => GR4_OUT, 
		DATA_IN_6 => GR5_OUT, 
		DATA_IN_7 => GR6_OUT, 
		DATA_IN_8 => GR7_OUT, 
		DATA_OUT => GRA_OUT
	);
	
	MX_GRB: multiplexer_16bit_8ways port map(
		SELECTOR => GRB_SELECT, 
		DATA_IN_1 => "0000000000000000", -- 指標レジスタはGR0不可 
		DATA_IN_2 => GR1_OUT, 
		DATA_IN_3 => GR2_OUT, 
		DATA_IN_4 => GR3_OUT, 
		DATA_IN_5 => GR4_OUT, 
		DATA_IN_6 => GR5_OUT, 
		DATA_IN_7 => GR6_OUT, 
		DATA_IN_8 => GR7_OUT, 
		DATA_OUT => GRB_OUT
	);
	
	MEMORY : prom port map(P_COUNT => PROM_ADDR_IN, PROM_OUT => PROM_OUT);
	
	DEC1 : bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW_7SEG,
	BIN_IN => GRA_OUT, 
	SEG7 => SEG7A, 
	DIGIT_SELECT => DIGITA_SELECT);

	DEC2: bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW_7SEG,
	BIN_IN => GRB_OUT, 
	SEG7 => SEG7B, 
	DIGIT_SELECT => DIGITB_SELECT);
end RTL;
	