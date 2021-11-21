library IEEE;
use IEEE.std_logic_1164.all;

entity phase_fetch is
	port(
		CLK_FT1 : in std_logic;
		CLK_FT2LOAD : in std_logic;
		CLK_FT2 : in std_logic;
		PR_IN : in std_logic_vector(15 downto 0);
		PROM_OUT : in std_logic_vector(15 downto 0);
		PROM_ADDR_IN : out std_logic_vector(15 downto 0);
		OP1_OUT : out std_logic_vector(15 downto 0);
		OP2_OUT : out std_logic_vector(15 downto 0);
		CURRENT_PR : out std_logic_vector(15 downto 0)
	);
end phase_fetch;

architecture RTL of phase_fetch is
	component register_16 is
		port(
			CLK_IN : in std_logic;
			WRITE_FLAG : in std_logic;
			DATA_IN : in std_logic_vector(15 downto 0);
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

	component multiplexer_16bit_2ways is
		port(
			SELECTOR : in std_logic;
			DATA_IN_1 : in std_logic_vector(15 downto 0);
			DATA_IN_2 : in std_logic_vector(15 downto 0);
			DATA_OUT : out std_logic_vector(15 downto 0)
		);
	end component;

	signal INTERNAL_PR_OUT_PLUS1 : std_logic_vector(15 downto 0);
	signal INTERNAL_CURRENT_PR : std_logic_vector(15 downto 0);

begin
	PROM_ADDER : adder_16bit port map( CI => '0', 
	AIN => INTERNAL_CURRENT_PR, 
	BIN => "0000000000000001", 
	SUM(15 downto 0) => INTERNAL_PR_OUT_PLUS1);
	
	PROM_MX : multiplexer_16bit_2ways port map( SELECTOR => CLK_FT2LOAD or CLK_FT2,
	DATA_IN_1 => PR_IN, 
	DATA_IN_2 => INTERNAL_PR_OUT_PLUS1, 
	DATA_OUT => PROM_ADDR_IN );
	
	OP1_REGISTER : register_16 port map(CLK_IN => CLK_FT1, WRITE_FLAG => '1', DATA_IN => PROM_OUT, DATA_OUT => OP1_OUT);
	OP2_REGISTER : register_16 port map(CLK_IN => CLK_FT2, WRITE_FLAG => '1', DATA_IN => PROM_OUT, DATA_OUT => OP2_OUT);

	REGISTER_CURRENT_PR : register_16 port map(CLK_IN => CLK_FT1, WRITE_FLAG => '1', DATA_IN => PR_IN, DATA_OUT => INTERNAL_CURRENT_PR);
	CURRENT_PR <= INTERNAL_CURRENT_PR;
end RTL;
