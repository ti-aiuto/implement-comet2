library IEEE;
use IEEE.std_logic_1164.all;

entity phrase_decode is
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
end phrase_decode;

architecture RTL of phrase_decode is
	component register_4 is
		port(
			CLK_IN : in std_logic;
			DATA_IN : in std_logic_vector(3 downto 0);
			DATA_OUT : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component register_16 is
	port(
		CLK_IN : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
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

	component adder_16bit is
		port(
			CI : in std_logic;
			AIN : in std_logic_vector(15 downto 0);
			BIN : in std_logic_vector(15 downto 0);
			SUM : out std_logic_vector(16 downto 0)
		);
	end component;

	signal INTERNAL_GRA_SELECT : std_logic_vector(2 downto 0);
	signal INTERNAL_GRB_SELECT : std_logic_vector(2 downto 0);
	signal INTERNAL_GRA_OUT : std_logic_vector(15 downto 0);
	signal INTERNAL_GRB_OUT : std_logic_vector(15 downto 0);
	
	signal OP2_PLUS_GRB : std_logic_vector(15 downto 0);
	signal OP2_PLUS_GRB_REG_OUT : std_logic_vector(15 downto 0);
	
	signal INTERNAL_MAIN_OP : std_logic_vector(3 downto 0);
	signal INTERNAL_SUB_OP : std_logic_vector(3 downto 0);
begin
	MX_GRA: multiplexer_16bit_8ways port map(
		SELECTOR => INTERNAL_GRA_SELECT, 
		DATA_IN_1 => GR0_IN, 
		DATA_IN_2 => GR1_IN, 
		DATA_IN_3 => GR2_IN, 
		DATA_IN_4 => GR3_IN, 
		DATA_IN_5 => GR4_IN, 
		DATA_IN_6 => GR5_IN, 
		DATA_IN_7 => GR6_IN, 
		DATA_IN_8 => GR7_IN, 
		DATA_OUT => INTERNAL_GRA_OUT
	);
	
	MX_GRB: multiplexer_16bit_8ways port map(
		SELECTOR => INTERNAL_GRB_SELECT, 
		DATA_IN_1 => "0000000000000000", -- 指標レジスタはGR0不可 
		DATA_IN_2 => GR1_IN, 
		DATA_IN_3 => GR2_IN, 
		DATA_IN_4 => GR3_IN, 
		DATA_IN_5 => GR4_IN, 
		DATA_IN_6 => GR5_IN, 
		DATA_IN_7 => GR6_IN, 
		DATA_IN_8 => GR7_IN, 
		DATA_OUT => INTERNAL_GRB_OUT
	);
	
	INTERNAL_MAIN_OP <= OP1_IN(15 downto 12);
	INTERNAL_SUB_OP <= OP1_IN(11 downto 8);
	INTERNAL_GRA_SELECT <= OP1_IN(6 downto 4);
	INTERNAL_GRB_SELECT <= OP1_IN(2 downto 0);
	
	GRA_SELECT_REGISTER : register_4 port map(CLK_IN => CLK, DATA_IN => "0" & INTERNAL_GRA_SELECT, DATA_OUT(2 downto 0) => GRA_SELECT);
	
	GRA_REGISTER : register_16 port map(CLK_IN => CLK, DATA_IN => INTERNAL_GRA_OUT, DATA_OUT => GRA_OUT);
	GRB_REGISTER : register_16 port map(CLK_IN => CLK, DATA_IN => INTERNAL_GRB_OUT, DATA_OUT => GRB_OUT);

	OP2_PLUS_GRB_ADDER : adder_16bit port map( CI => '0', AIN => OP2_IN, BIN => INTERNAL_GRB_OUT, SUM(15 downto 0) => OP2_PLUS_GRB );
	OP2_PLUS_GRB_REGISTER : register_16 port map(CLK_IN => CLK, DATA_IN => OP2_PLUS_GRB, DATA_OUT => EFFECTIVE_ADDR);
	
	MAIN_OP_REGISTER : register_4 port map(CLK_IN => CLK, DATA_IN => INTERNAL_MAIN_OP, DATA_OUT => MAIN_OP);
	SUB_OP_REGISTER : register_4 port map(CLK_IN => CLK, DATA_IN => INTERNAL_SUB_OP, DATA_OUT => SUB_OP);
end RTL;
