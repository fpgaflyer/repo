library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reset_gen_n is
	port(
		clk   : in  std_logic;
		reset : out std_logic
	);

end;

architecture behav of reset_gen_n is
	signal cnt : std_logic_vector(7 downto 0) := (others => '0');

begin
	process(clk)
	begin
		if rising_edge(clk) then        -- use work edge for good synthese, wait until does not work !!!!!

			if cnt(7) = '1' then        -- >32 periods to reset serial clock modules running on clk_o/32
				reset <= '0';
			else
				reset <= '1';
				cnt   <= cnt + 1;
			end if;

		end if;
	end process;

end;
