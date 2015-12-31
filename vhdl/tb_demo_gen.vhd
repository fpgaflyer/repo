-- run 50us
entity tb_demo_gen is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture structure of tb_demo_gen is
	component demo_gen
		port(clk_in        : in  std_logic;
			 reset         : in  std_logic;
			 calc_offsets  : in  std_logic;
			 demo_setpos_1 : out std_logic_vector(7 downto 0);
			 demo_setpos_2 : out std_logic_vector(7 downto 0);
			 demo_setpos_3 : out std_logic_vector(7 downto 0);
			 demo_setpos_4 : out std_logic_vector(7 downto 0);
			 demo_setpos_5 : out std_logic_vector(7 downto 0);
			 demo_setpos_6 : out std_logic_vector(7 downto 0));
	end component demo_gen;

	signal CLK50         : std_logic := '1';
	signal RESET         : std_logic;
	signal CALC_OFFSETS  : std_logic;
	signal demo_setpos_1 : std_logic_vector(7 downto 0);
	signal demo_setpos_2 : std_logic_vector(7 downto 0);
	signal demo_setpos_3 : std_logic_vector(7 downto 0);
	signal demo_setpos_4 : std_logic_vector(7 downto 0);
	signal demo_setpos_5 : std_logic_vector(7 downto 0);
	signal demo_setpos_6 : std_logic_vector(7 downto 0);

begin
	CLK50        <= not CLK50 after 10 ns;
	RESET        <= '1', '0' after 100 ns;
	CALC_OFFSETS <= '0', '1' after 10000 ns, '0' after 10020 ns;

	A1 : component demo_gen
		port map(
			clk_in        => CLK50,
			reset         => RESET,
			calc_offsets  => CALC_OFFSETS,
			demo_setpos_1 => demo_setpos_1,
			demo_setpos_2 => demo_setpos_2,
			demo_setpos_3 => demo_setpos_3,
			demo_setpos_4 => demo_setpos_4,
			demo_setpos_5 => demo_setpos_5,
			demo_setpos_6 => demo_setpos_6
		);
end;

