library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library gen;
use gen.std.all;

entity display_controller_n is
	port(clk     : in  std_logic;
		 reset   : in  std_logic;
		 val_0   : in  std_logic_vector(63 downto 0); --"0 FFFF FFFF FFFF"  
		 val_1   : in  std_logic_vector(63 downto 0); --"K FFFF FFFF FFFF"  K=Kp value

		 data    : out std_logic_vector(7 downto 0);
		 addr    : out std_logic_vector(6 downto 0);
		 data_en : out std_logic;
		 nxt     : in  std_logic
	);
end;

architecture behav of display_controller_n is
	type t_sm is (idle, send_data);
	signal sm    : t_sm;
	signal n     : std_logic_vector(4 downto 0);
	signal nxt_d : std_logic;

begin
	process(clk, reset)
		variable i : integer range 0 to 60;

	begin
		if (reset = '1') then
			sm      <= idle;
			n       <= (others => '0');
			data    <= (others => '0');
			addr    <= (others => '0');
			data_en <= '0';
			nxt_d   <= '0';

		elsif (clk'event and clk = '1') then
			data_en <= '0';
			i       := conv_integer(n(3 downto 0) & "00");
			nxt_d   <= nxt;

			case sm is
				when idle =>
					if (nxt = '1') and (nxt_d = '0') then -- rising edge
						sm <= send_data;
					end if;

				when send_data =>
					if n(4) = '0' then
						addr <= "000" & not n(3 downto 0); --0x00;
						data <= hex2ascii(val_0((i + 3) downto i));
					else
						addr <= "100" & not n(3 downto 0); --0x40;
						data <= hex2ascii(val_1((i + 3) downto i));
					end if;
					if (n(3 downto 0) = 4) or (n(3 downto 0) = 9) or (n(3 downto 0) = 14) then
						data <= X"20";  -- " "
					end if;
					n       <= n + 1;
					data_en <= '1';
					sm      <= idle;

				when others => null;

			end case;

		end if;
	end process;

end; 
