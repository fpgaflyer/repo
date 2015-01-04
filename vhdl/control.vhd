library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
	port(
		clk       : in  std_logic;
		sync_2ms  : in  std_logic;
		press     : in  std_logic;
		btn_west  : in  std_logic;
		btn_east  : in  std_logic;
		btn_south : in  std_logic;
		kp        : out std_logic_vector(3 downto 0);
		sw0       : in  std_logic;
		val_in0   : in  std_logic_vector(13 downto 0);
		val_in1   : in  std_logic_vector(13 downto 0);
		val_out   : out std_logic_vector(13 downto 0);
		val_dis   : out std_logic_vector(13 downto 0);
		rtc       : out std_logic_vector(1 downto 0);
		start     : out std_logic
	);

end;

architecture behav of control is
	signal press_d : std_logic;
	signal btn_w_d : std_logic;
	signal btn_e_d : std_logic;
	signal btn_s_d : std_logic;
	signal cnt     : std_logic_vector(3 downto 0);
	signal cnt_2ms : std_logic_vector(7 downto 0);
	type t_sm is (drive_cmd, mmod10_cmd, h1_cmd, mmod11_cmd);
	signal sm : t_sm;

begin
	process
	begin
		wait until clk = '1';

		press_d <= press;
		btn_w_d <= btn_west;
		btn_e_d <= btn_east;
		btn_s_d <= btn_south;

		val_dis <= val_in0;
		start   <= '0';

		if (press = '1') and (press_d = '0') then
			val_out <= val_in0;
		end if;

		if sw0 = '1' then
			val_out <= val_in1;
			val_dis <= val_in1;
		end if;

		if (btn_west = '1') and (btn_w_d = '0') then
			cnt <= cnt - 1;
		end if;

		if (btn_east = '1') and (btn_e_d = '0') then
			cnt <= cnt + 1;
		end if;

		if sync_2ms = '1' then
			cnt_2ms <= cnt_2ms + 1;
			case sm is
				when drive_cmd =>
					rtc   <= "00";
					start <= '1';
					if (btn_south = '1') and (btn_s_d = '0') then
						sm      <= mmod10_cmd;
						cnt_2ms <= (others => '0');
					end if;

				when mmod10_cmd =>      --open loop
					rtc <= "01";
					if cnt_2ms(7) = '1' then --delay 128x2ms
						start   <= '1';
						sm      <= h1_cmd;
						cnt_2ms <= (others => '0');
					end if;

				when h1_cmd =>          -- load home counter
					rtc <= "10";
					if cnt_2ms(7) = '1' then --delay 128x2ms
						start   <= '1';
						sm      <= mmod11_cmd;
						cnt_2ms <= (others => '0');
					end if;

				when mmod11_cmd =>      -- closed loop
					rtc <= "11";
					if cnt_2ms(7) = '1' then --delay 128x2ms
						start   <= '1';
						sm      <= drive_cmd;
						cnt_2ms <= (others => '0');
					end if;

				when others =>
					sm <= drive_cmd;
			end case;

		end if;

	end process;
	kp <= cnt;

end;
