library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	port(
		clk    : in  std_logic;
		reset  : in  std_logic;
		step   : in  std_logic;
		dir    : in  std_logic;
		val    : out std_logic_vector(13 downto 0)
	);
end;

architecture behav of counter is
	signal cnt : std_logic_vector(13 downto 0);

begin
	process
	begin
		wait until clk = '1';

		if reset = '1' then
			cnt    <= (others => '0');

		else
		
			if step = '1' then
				if dir = '0' then
					cnt <= cnt + 1;
				else
					cnt <= cnt - 1;
				end if;
			end if;

		end if;

		val <= cnt;

	end process;
end;
