library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
	port(
		clk           : in  std_logic;
		reset         : in  std_logic;
		sync_2ms      : in  std_logic;
		press         : in  std_logic;
		btn_north     : in  std_logic;
		btn_west      : in  std_logic;
		btn_east      : in  std_logic;
		btn_south     : in  std_logic;
		kp            : out std_logic_vector(3 downto 0);
		sw0           : in  std_logic;

		setpos_in     : in  std_logic_vector(7 downto 0); -- 1.6mm
		setpos_out    : out std_logic_vector(13 downto 0); -- 25um

		drive_in      : in  std_logic_vector(10 downto 0);
		drive_out     : out std_logic_vector(10 downto 0);

		rtc           : out std_logic_vector(1 downto 0);
		start         : out std_logic;
		home_enable   : out std_logic;
		position_mode : out std_logic
	);

end;

architecture behav of control is
	signal press_d : std_logic;
	signal btn_w_d : std_logic;
	signal btn_e_d : std_logic;
	signal cnt     : std_logic_vector(3 downto 0);
	type t_sm is (spd_mode, pos_mode);
	signal sm : t_sm;

begin
	process
	begin
		wait until clk = '1';

		press_d <= press;
		btn_w_d <= btn_west;
		btn_e_d <= btn_east;

		start       <= '0';
		rtc         <= "01";            --go
		home_enable <= '0';

		if (press = '1') and (press_d = '0') then
			setpos_out <= setpos_in & "000000";
		end if;

		if sw0 = '1' then
			home_enable <= '1';
		end if;

		if (btn_west = '1') and (btn_w_d = '0') then --kp-1
			cnt <= cnt - 1;
		end if;

		if (btn_east = '1') and (btn_e_d = '0') then --kp+1
			cnt <= cnt + 1;
		end if;

		if sync_2ms = '1' then
			start <= '1';
			case sm is
				when spd_mode =>
					position_mode <= '0';
					drive_out     <= "00000000000";
					if btn_north = '1' then
						drive_out <= "00000110010"; --  +50
					end if;
					if btn_south = '1' then
						drive_out <= "11111001110"; -- -50
					end if;
					if press = '1' then
						sm <= pos_mode;
					end if;
				when pos_mode =>
					position_mode <= '1';
					if (btn_north = '1') or (btn_south = '1') then
						sm <= spd_mode;
					end if;
					drive_out <= drive_in;
				when others =>
			end case;
		end if;

		if reset = '1' then
			sm <= spd_mode;
		end if;

	end process;
	kp <= cnt;

end;
