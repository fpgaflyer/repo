library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity reset_gen_n is
	port(
		clk   : in  std_logic;
		reset : out std_logic
	);

end;

architecture behav of reset_gen_n is
	signal cnt : std_logic_vector(21 downto 0) := (others => '0');

begin
	process(clk)
	begin
		if rising_edge(clk) then        -- use work edge for good synthese, wait until does not work !!!!!

			if cnt(21) = '1' then       -- >2097152 periods to reset = ~42ms to provide reset to slow clocks like 20ms !
				reset <= '0';
			else
				reset <= '1';
				cnt   <= cnt + 1;
			end if;

		end if;
	end process;

end;
