library IEEE;
use IEEE.std_logic_1164.all;

entity pj3 is
	port 
	(
		CLK_IN : in std_logic;
		SEG7A : out std_logic_vector(6 downto 0);
		DIGITA_SELECT : out std_logic_vector(5 downto 0);
		SEG7B : out std_logic_vector(6 downto 0);
		DIGITB_SELECT : out std_logic_vector(5 downto 0)
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

signal CLK_SLOW_7SEG : std_logic;
signal CLK_SLOW : std_logic;

signal CLK_FT1 : std_logic;
signal CLK_FT2 : std_logic;
signal CLK_DC : std_logic;
signal CLK_MA : std_logic;
signal CLK_EX : std_logic;
signal CLK_WB : std_logic;

signal REGISTER_A_OUT : std_logic_vector(15 downto 0);
signal REGISTER_B_OUT : std_logic_vector(15 downto 0);
signal PROM_OUT : std_logic_vector(15 downto 0);

signal RAM_WRITE_FLAG : std_logic;
signal NEXT_RAM_DATA : std_logic_vector(15 downto 0);
signal PR_OUT : std_logic_vector(15 downto 0);
signal PR_OUT_PLUS1 : std_logic_vector(16 downto 0);
signal PROM_ADDR_IN : std_logic_vector(15 downto 0);


begin
	CLOCK_7SEG_COMPONENT : clock_down_dynamyc_7seg port map(CLK_IN => CLK_IN, CLK_OUT => CLK_SLOW_7SEG);
	CLOCK_COMPONENT: clock_down port map(CLK_IN => CLK_IN, CLK_OUT => CLK_SLOW);
	CLOCK_GEN_COMPONENT: clk_gen port map(
	CLK => CLK_SLOW,
	CLK_FT1 => CLK_FT1, 
	CLK_FT2 => CLK_FT2, 
	CLK_DC => CLK_DC, 
	CLK_MA => CLK_MA, 
	CLK_EX => CLK_EX, 
	CLK_WB => CLK_WB);
		
	PROM_ADDER : adder_16bit port map( CI => '0', AIN => PR_OUT, BIN => "0000000000000001", SUM => PR_OUT_PLUS1);
	PROM_MX : multiplexer_16bit_2ways port map( SELECTOR => CLK_FT1,
	DATA_IN_1 => PR_OUT, 
	DATA_IN_2 => PR_OUT_PLUS1(15 downto 0), 
	DATA_OUT => PROM_ADDR_IN );
		
	REGISTER_A : register_16 port map(CLK_IN => CLK_FT1, DATA_IN => PROM_OUT, DATA_OUT => REGISTER_A_OUT);
	REGISTER_B : register_16 port map(CLK_IN => CLK_FT2, DATA_IN => PROM_OUT, DATA_OUT => REGISTER_B_OUT);
	PR : register_16 port map(CLK_IN => CLK_SLOW and RAM_WRITE_FLAG, DATA_IN => NEXT_RAM_DATA, DATA_OUT => PR_OUT);
	
	MEMORY : prom port map(P_COUNT => PROM_ADDR_IN, PROM_OUT => PROM_OUT);
	
	DEC1 : bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW_7SEG,
	BIN_IN => REGISTER_A_OUT, 
	SEG7 => SEG7A, 
	DIGIT_SELECT => DIGITA_SELECT);

	DEC2: bin_16_dec_dynamic_6 port map( CLK_IN => CLK_SLOW_7SEG,
	BIN_IN => REGISTER_B_OUT, 
	SEG7 => SEG7B, 
	DIGIT_SELECT => DIGITB_SELECT);
end RTL;
	