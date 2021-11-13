library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity clk_gen is
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
end clk_gen;

architecture RTL of clk_gen is

signal COUNT : std_logic_vector(2 downto 0) := "000";

begin
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			case COUNT is
				when "000" => 
					CLK_FT1 <= '1';
					CLK_FT2LOAD <= '0';
					CLK_FT2 <= '0';
					CLK_DC <= '0';
					CLK_MA <= '0';
					CLK_EX <= '0';
					CLK_WB <= '0';
					COUNT <= COUNT + 1;
				when "001" => 
					CLK_FT1 <= '0';
					CLK_FT2LOAD <= '1';
					CLK_FT2 <= '0';
					CLK_DC <= '0';
					CLK_MA <= '0';
					CLK_EX <= '0';
					CLK_WB <= '0';
					COUNT <= COUNT + 1;
				when "010" => 
					CLK_FT1 <= '0';
					CLK_FT2LOAD <= '0';
					CLK_FT2 <= '1';
					CLK_DC <= '0';
					CLK_MA <= '0';
					CLK_EX <= '0';
					CLK_WB <= '0';
					COUNT <= COUNT + 1;
				when "011" => 
					CLK_FT1 <= '0';
					CLK_FT2LOAD <= '0';
					CLK_FT2 <= '0';
					CLK_DC <= '1';
					CLK_MA <= '0';
					CLK_EX <= '0';
					CLK_WB <= '0';
					COUNT <= COUNT + 1;
				when "100" => 
					CLK_FT1 <= '0';
					CLK_FT2LOAD <= '0';
					CLK_FT2 <= '0';
					CLK_DC <= '0';
					CLK_MA <= '1';
					CLK_EX <= '0';
					CLK_WB <= '0';
					COUNT <= COUNT + 1;
				when "101" => 
					CLK_FT1 <= '0';
					CLK_FT2LOAD <= '0';
					CLK_FT2 <= '0';
					CLK_DC <= '0';
					CLK_MA <= '0';
					CLK_EX <= '1';
					CLK_WB <= '0';
					COUNT <= COUNT + 1;
				when "110" => 
					CLK_FT1 <= '0';
					CLK_FT2LOAD <= '0';
					CLK_FT2 <= '0';
					CLK_DC <= '0';
					CLK_MA <= '0';
					CLK_EX <= '0';
					CLK_WB <= '1';
					COUNT <= "000";
				when others => 
					null;
			end case;
		end if;
	end process;
end RTL;
