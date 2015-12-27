library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library gen;
use gen.std.all;

entity display_controller_n is
	port(clk     : in  std_logic;
		 reset   : in  std_logic;
		 val_0   : in  std_logic_vector(63 downto 0); --"K FFFF FFFF FFFF"  K=Kp value
		 val_1   : in  std_logic_vector(63 downto 0); --"X FFFF FFFF FFFF"  X= select or mode
		 blank   : in  integer range 0 to 6; -- blanks val_1 setpositions X 1122 3344 5566, 0 is no blank

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
						case blank is
							when 1 =>
								if (not n(3 downto 0) = 2) or (not n(3 downto 0) = 3) then
									data <= X"20"; -- " "  
								end if;
							when 2 =>
								if (not n(3 downto 0) = 4) or (not n(3 downto 0) = 5) then
									data <= X"20"; -- " "   
								end if;
							when 3 =>
								if (not n(3 downto 0) = 7) or (not n(3 downto 0) = 8) then
									data <= X"20"; -- " "  
								end if;
							when 4 =>
								if (not n(3 downto 0) = 9) or (not n(3 downto 0) = 10) then
									data <= X"20"; -- " "  
								end if;
							when 5 =>
								if (not n(3 downto 0) = 12) or (not n(3 downto 0) = 13) then
									data <= X"20"; -- " "  
								end if;
							when 6 =>
								if (not n(3 downto 0) = 14) or (not n(3 downto 0) = 15) then
									data <= X"20"; -- " "  
								end if;
							when others => null;
						end case;
					end if;
					if (not n(3 downto 0) = 1) or (not n(3 downto 0) = 6) or (not n(3 downto 0) = 11) then
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
