entity tb_moving_avg_filter is 
end; 

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture structure of tb_moving_avg_filter is
	component moving_avg_filter
		port(
			clk   : in  std_logic;
			reset : in  std_logic;
			in_1  : in  std_logic_vector(7 downto 0);
			in_2  : in  std_logic_vector(7 downto 0);
			in_3  : in  std_logic_vector(7 downto 0);
			in_4  : in  std_logic_vector(7 downto 0);
			in_5  : in  std_logic_vector(7 downto 0);
			in_6  : in  std_logic_vector(7 downto 0);
			out_1 : out std_logic_vector(13 downto 0);
			out_2 : out std_logic_vector(13 downto 0);
			out_3 : out std_logic_vector(13 downto 0);
			out_4 : out std_logic_vector(13 downto 0);
			out_5 : out std_logic_vector(13 downto 0);
			out_6 : out std_logic_vector(13 downto 0);
			avg   : in  std_logic
		);
	end component moving_avg_filter;

	signal CLK   : std_logic := '1';
	signal RESET : std_logic;
	signal STIM  : std_logic_vector(7 downto 0);
	signal out_1 : std_logic_vector(13 downto 0);
	signal out_2 : std_logic_vector(13 downto 0);
	signal out_3 : std_logic_vector(13 downto 0);
	signal out_4 : std_logic_vector(13 downto 0);
	signal out_5 : std_logic_vector(13 downto 0);
	signal out_6 : std_logic_vector(13 downto 0);
	signal AVG   : std_logic;

begin
	CLK <= NOT CLK after 1 ms;

	RESET <= '1', '0' after 1 us;

	STIM <= X"00", X"34" after 50 ms, X"64" after 150 ms, X"A4" after 211 ms, X"96" after 262 ms, X"92" after 300 ms, X"B1" after 331 ms, X"A1" after 369 ms, X"A1" after 411 ms, X"A1" after 456 ms, X"65" after 507 ms, X"34" after 550 ms, X"27" after 561 ms, X"2A" after 622 ms, X"10" after 668
		ms, X"00" after 711 ms, X"34" after 767 ms, X"34" after 800 ms, X"00" after 844 ms, X"08" after 902 ms, X"FF" after 1000 ms, X"00" after 2000 ms;

	AVG <= '0';

	A1 : moving_avg_filter
		port map(
			clk   => CLK,
			reset => RESET,
			in_1  => STIM,
			in_2  => STIM,
			in_3  => STIM,
			in_4  => STIM,
			in_5  => STIM,
			in_6  => STIM,
			out_1 => out_1,
			out_2 => out_2,
			out_3 => out_3,
			out_4 => out_4,
			out_5 => out_5,
			out_6 => out_6,
			avg   => AVG
		);

end;

