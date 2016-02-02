library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity digital_filter is
	port(clk      : in  std_logic;
		 sync_2ms : in  std_logic;
		 reset    : in  std_logic;
		 i        : in  std_logic;
		 o        : out std_logic
	);
end;

architecture behav of digital_filter is
	signal cnt       : std_logic_vector(2 downto 0);
	signal i_r, i_rr : std_logic;

begin
	process
	begin
		wait until clk = '1';

		if reset = '1' then
			cnt  <= (others => '0');
			i_r  <= '0';
			i_rr <= '0';
			o    <= '0';
		else
			i_r  <= i;                  --asyn input
			i_rr <= i_r;

			if sync_2ms = '1' then
				if (i_rr = '1') and (cnt < 7) then
					cnt <= cnt + 1;
				end if;
				if (i_rr = '0') and (cnt > 0) then
					cnt <= cnt - 1;
				end if;
				if cnt = 7 then
					o <= '1';
				end if;
				if cnt = 0 then
					o <= '0';
				end if;
			end if;

		end if;
	end process;
end;







