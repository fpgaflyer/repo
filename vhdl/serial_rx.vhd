library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity serial_rx is
	port(
		clk           : in  std_logic;
		reset         : in  std_logic;
		rx            : in  std_logic;
		rx_data       : out std_logic_vector(7 downto 0);
		rx_data_valid : out std_logic
	);

end;

architecture behav of serial_rx is
	constant clkdiv   : std_logic_vector(8 downto 0) := "110110010"; --434 115200 BAUD @ 50MHZ
	constant clkdiv2  : std_logic_vector(8 downto 0) := "011011001"; --217
	signal rx_d       : std_logic;
	signal rx_brdcnt  : std_logic_vector(8 downto 0);
	signal rx_datacnt : std_logic_vector(2 downto 0);
	type t_sm is (init, edge_detect, start, data, stop, ready);
	signal sm : t_sm;

begin
	process
		variable rx_r : std_logic_vector(7 downto 0);

	begin
		wait until clk = '1';

		if reset = '1' then
			rx_data       <= (others => '0');
			rx_r          := (others => '0');
			rx_data_valid <= '0';
			rx_d          <= '0';
			rx_brdcnt     <= (others => '0');
			rx_datacnt    <= "000";
			sm            <= init;

		else
			rx_d <= rx;

			case sm is
				when init =>
					rx_data_valid <= '0';
					rx_brdcnt     <= clkdiv2;
					rx_datacnt    <= "000";
					sm            <= edge_detect;

				when edge_detect =>
					if (rx = '0') and (rx_d = '1') then
						sm <= start;
					end if;

				when start =>
					if rx_brdcnt = 0 then
						if rx = '0' then
							rx_brdcnt <= clkdiv;
							sm        <= data;
						else
							rx_brdcnt <= clkdiv2;
							sm        <= edge_detect;
						end if;
					else
						rx_brdcnt <= rx_brdcnt - 1;
					end if;

				when data =>
					if rx_brdcnt = 0 then
						if rx_datacnt = 7 then
							sm <= stop;
						end if;
						rx_brdcnt                      <= clkdiv;
						rx_datacnt                     <= rx_datacnt + 1;
						rx_r(conv_integer(rx_datacnt)) := rx;
					else
						rx_brdcnt <= rx_brdcnt - 1;
					end if;

				when stop =>
					if (rx_brdcnt = 0) then
						sm <= ready;
					else
						rx_brdcnt <= rx_brdcnt - '1';
					end if;

				when ready =>
					rx_data_valid <= '1';
					rx_data       <= rx_r;
					sm            <= init;

				when others => sm <= init;

			end case;
		end if;

	end process;

end;
