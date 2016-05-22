library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity moving_avg_filter is
	port(
		clk   : in  std_logic;          -- 2ms!
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
end;

architecture behav of moving_avg_filter is
	signal p     : integer range 0 to 1;
	signal sum_1 : std_logic_vector(14 downto 0);
	signal sum_2 : std_logic_vector(14 downto 0);
	signal sum_3 : std_logic_vector(14 downto 0);
	signal sum_4 : std_logic_vector(14 downto 0);
	signal sum_5 : std_logic_vector(14 downto 0);
	signal sum_6 : std_logic_vector(14 downto 0);

begin
	process(clk, reset)
	begin
		if reset = '1' then
			sum_1 <= (others => '0');
			sum_2 <= (others => '0');
			sum_3 <= (others => '0');
			sum_4 <= (others => '0');
			sum_5 <= (others => '0');
			sum_6 <= (others => '0');

		elsif (clk'event and clk = '1') then
			if avg = '1' then
				p <= 1;
			else
				p <= 0;
			end if;

			sum_1 <= sum_1 - sum_1((13 + p) downto (6 + p)) + in_1;
			out_1 <= sum_1((13 + p) downto p);

			sum_2 <= sum_2 - sum_2((13 + p) downto (6 + p)) + in_2;
			out_2 <= sum_2((13 + p) downto p);

			sum_3 <= sum_3 - sum_3((13 + p) downto (6 + p)) + in_3;
			out_3 <= sum_3((13 + p) downto p);

			sum_4 <= sum_4 - sum_4((13 + p) downto (6 + p)) + in_4;
			out_4 <= sum_4((13 + p) downto p);

			sum_5 <= sum_5 - sum_5((13 + p) downto (6 + p)) + in_5;
			out_5 <= sum_5((13 + p) downto p);

			sum_6 <= sum_6 - sum_6((13 + p) downto (6 + p)) + in_6;
			out_6 <= sum_6((13 + p) downto p);

		end if;

	end process;

end;
