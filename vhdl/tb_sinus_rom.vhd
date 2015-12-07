-- run 50us
entity tb_sinus_rom is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture structure of tb_sinus_rom is
	component sinus_rom
		port(clk_in  : in  std_logic;
			 sin_0   : out std_logic_vector(7 downto 0);
			 sin_60  : out std_logic_vector(7 downto 0);
			 sin_120 : out std_logic_vector(7 downto 0);
			 sin_180 : out std_logic_vector(7 downto 0);
			 sin_240 : out std_logic_vector(7 downto 0);
			 sin_300 : out std_logic_vector(7 downto 0));
	end component sinus_rom;

	signal CLK50   : std_logic := '1';
	signal sin_0   : std_logic_vector(7 downto 0);
	signal sin_60  : std_logic_vector(7 downto 0);
	signal sin_120 : std_logic_vector(7 downto 0);
	signal sin_180 : std_logic_vector(7 downto 0);
	signal sin_240 : std_logic_vector(7 downto 0);
	signal sin_300 : std_logic_vector(7 downto 0);

begin
	CLK50 <= not CLK50 after 10 ns;

	A1 : component sinus_rom
		port map(
			clk_in  => CLK50,
			sin_0   => sin_0,
			sin_60  => sin_60,
			sin_120 => sin_120,
			sin_180 => sin_180,
			sin_240 => sin_240,
			sin_300 => sin_300
		);
end;

