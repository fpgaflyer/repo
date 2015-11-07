library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity control is
	port(
		clk          : in  std_logic;
		reset        : in  std_logic;
		sync_2ms     : in  std_logic;

		rotary_event : in  std_logic;
		rotary_left  : in  std_logic;
		press        : in  std_logic;
		btn_north    : in  std_logic;
		btn_west     : in  std_logic;
		btn_east     : in  std_logic;
		btn_south    : in  std_logic;
		sw0          : in  std_logic;
		sw1          : in  std_logic;
		sw2          : in  std_logic;
		sw3          : in  std_logic;

		start        : out std_logic;
		home_enable  : out std_logic;
		kp           : out std_logic_vector(3 downto 0);

		set_pos_1    : out std_logic_vector(7 downto 0);
		set_pos_2    : out std_logic_vector(7 downto 0);
		set_pos_3    : out std_logic_vector(7 downto 0);
		set_pos_4    : out std_logic_vector(7 downto 0);
		set_pos_5    : out std_logic_vector(7 downto 0);
		set_pos_6    : out std_logic_vector(7 downto 0);

		drv_mode_1   : out std_logic_vector(1 downto 0);
		drv_mode_2   : out std_logic_vector(1 downto 0);
		drv_mode_3   : out std_logic_vector(1 downto 0);
		drv_mode_4   : out std_logic_vector(1 downto 0);
		drv_mode_5   : out std_logic_vector(1 downto 0);
		drv_mode_6   : out std_logic_vector(1 downto 0);

		drv_man_1    : out std_logic_vector(10 downto 0);
		drv_man_2    : out std_logic_vector(10 downto 0);
		drv_man_3    : out std_logic_vector(10 downto 0);
		drv_man_4    : out std_logic_vector(10 downto 0);
		drv_man_5    : out std_logic_vector(10 downto 0);
		drv_man_6    : out std_logic_vector(10 downto 0);

		led          : out std_logic_vector(7 downto 0);
		val_1        : out std_logic_vector(63 downto 0)
	);

end;

architecture behav of control is
	signal press_d : std_logic;
	signal btn_w_d : std_logic;
	signal btn_e_d : std_logic;
	type t_sm is (spd_mode, pos_mode, init);
	signal sm : t_sm;
	type t_cnt is array (1 to 6) of std_logic_vector(7 downto 0);
	signal cnt : t_cnt;
	signal i   : integer range 1 to 6;

begin
	process
		type t_setpos is array (1 to 6) of std_logic_vector(7 downto 0);
		variable setpos : t_setpos;
		type t_drvmode is array (1 to 6) of std_logic_vector(1 downto 0);
		variable drvmode : t_drvmode;
		type t_drvman is array (1 to 6) of std_logic_vector(10 downto 0);
		variable drvman : t_drvman;
		variable leds   : std_logic_vector(7 downto 0);

	begin
		wait until clk = '1';

		press_d     <= press;
		btn_w_d     <= btn_west;
		btn_e_d     <= btn_east;
		start       <= '0';
		home_enable <= '0';

		if (btn_west = '1') and (btn_w_d = '0') and (i > 1) then
			i  <= i - 1;
			sm <= init;
		end if;
		if (btn_east = '1') and (btn_e_d = '0') and (i < 6) then
			i  <= i + 1;
			sm <= init;
		end if;

		if rotary_event = '1' then
			if rotary_left = '0' then
				cnt(i) <= cnt(i) + 1;
			else
				cnt(i) <= cnt(i) - 1;
			end if;
		end if;

		if (press = '1') and (press_d = '0') then
			setpos(i) := cnt(i);
		end if;

		if sw0 = '1' then
			home_enable <= '1';
		end if;

		if sync_2ms = '1' then
			start <= '1';
			case sm is
				when init =>
					if drvmode(i) = "10" then
						sm <= pos_mode;
					else
						sm <= spd_mode;
					end if;
				when spd_mode =>
					drvmode(i) := "01";
					leds(i)    := '0';
					drvman(i)  := "00000000000";
					if btn_north = '1' then
						drvman(i) := "00000110010"; --  +50
					end if;
					if btn_south = '1' then
						drvman(i) := "11111001110"; -- -50
					end if;
					if press = '1' then
						sm <= pos_mode;
					end if;
				when pos_mode =>
					drvmode(i) := "10";
					leds(i)    := '1';
					if (btn_north = '1') or (btn_south = '1') then
						sm <= spd_mode;
					end if;
				when others =>
			end case;
		end if;

		set_pos_1 <= setpos(1);
		set_pos_2 <= setpos(2);
		set_pos_3 <= setpos(3);
		set_pos_4 <= setpos(4);
		set_pos_5 <= setpos(5);
		set_pos_6 <= setpos(6);

		drv_mode_1 <= drvmode(1);
		drv_mode_2 <= drvmode(2);
		drv_mode_3 <= drvmode(3);
		drv_mode_4 <= drvmode(4);
		drv_mode_5 <= drvmode(5);
		drv_mode_6 <= drvmode(6);

		drv_man_1 <= drvman(1);
		drv_man_2 <= drvman(2);
		drv_man_3 <= drvman(3);
		drv_man_4 <= drvman(4);
		drv_man_5 <= drvman(5);
		drv_man_6 <= drvman(6);

		kp <= '0' & sw3 & sw2 & sw1;

		val_1 <= conv_std_logic_vector(i, 4) & "0000" & cnt(1) & cnt(2) & "0000" & cnt(3) & cnt(4) & "0000" & cnt(5) & cnt(6); --LCD line 2  1.6mm

		led(0) <= leds(6);
		led(1) <= leds(5);
		led(2) <= leds(4);
		led(3) <= leds(3);
		led(4) <= leds(2);
		led(5) <= leds(1);
		led(6) <= '0';
		led(7) <= '0';

		if reset = '1' then
			sm <= init;
			i  <= 1;
			for j in 1 to 6 loop
				setpos(j)  := (others => '0');
				drvmode(j) := (others => '0');
				drvman(j)  := (others => '0');
			end loop;
		end if;

	end process;

end;