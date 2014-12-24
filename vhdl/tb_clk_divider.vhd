entity tb_clk_divider_n is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture structure of tb_clk_divider_n is
	component clk_divider_n
		port(
			clk        : in  std_logic;
			sync_2ms   : out std_logic;
			en_16xbaud : out std_logic
		);
	end component;

	signal CLK50      : std_logic := '1';
	signal sync_2ms   : std_logic;
	signal en_16xbaud : std_logic;

begin
	CLK50 <= NOT CLK50 after 10 ns;

	A1 : clk_divider_n port map(
			clk        => CLK50,
			sync_2ms   => sync_2ms,
			en_16xbaud => en_16xbaud
		);

end;

