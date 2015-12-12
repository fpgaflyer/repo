library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity control is
	port(
		clk           : in  std_logic;
		reset         : in  std_logic;
		sync_2ms      : in  std_logic;
		sync_20ms     : in  std_logic;

		rotary_event  : in  std_logic;
		rotary_left   : in  std_logic;
		press         : in  std_logic;
		btn_north     : in  std_logic;
		btn_west      : in  std_logic;
		btn_east      : in  std_logic;
		btn_south     : in  std_logic;
		sw0           : in  std_logic;
		sw1           : in  std_logic;
		sw2           : in  std_logic;
		sw3           : in  std_logic;

		start         : out std_logic;
		home_enable   : out std_logic;
		kp            : out std_logic_vector(3 downto 0);

		set_pos_1     : out std_logic_vector(7 downto 0);
		set_pos_2     : out std_logic_vector(7 downto 0);
		set_pos_3     : out std_logic_vector(7 downto 0);
		set_pos_4     : out std_logic_vector(7 downto 0);
		set_pos_5     : out std_logic_vector(7 downto 0);
		set_pos_6     : out std_logic_vector(7 downto 0);

		drv_mode_1    : out std_logic_vector(1 downto 0);
		drv_mode_2    : out std_logic_vector(1 downto 0);
		drv_mode_3    : out std_logic_vector(1 downto 0);
		drv_mode_4    : out std_logic_vector(1 downto 0);
		drv_mode_5    : out std_logic_vector(1 downto 0);
		drv_mode_6    : out std_logic_vector(1 downto 0);

		drv_man_1     : out std_logic_vector(10 downto 0);
		drv_man_2     : out std_logic_vector(10 downto 0);
		drv_man_3     : out std_logic_vector(10 downto 0);
		drv_man_4     : out std_logic_vector(10 downto 0);
		drv_man_5     : out std_logic_vector(10 downto 0);
		drv_man_6     : out std_logic_vector(10 downto 0);

		led           : out std_logic_vector(7 downto 0);
		val_1         : out std_logic_vector(63 downto 0);

		ext_setpos_1  : in  std_logic_vector(7 downto 0);
		ext_setpos_2  : in  std_logic_vector(7 downto 0);
		ext_setpos_3  : in  std_logic_vector(7 downto 0);
		ext_setpos_4  : in  std_logic_vector(7 downto 0);
		ext_setpos_5  : in  std_logic_vector(7 downto 0);
		ext_setpos_6  : in  std_logic_vector(7 downto 0);

		sin_setpos_1  : in  std_logic_vector(7 downto 0);
		sin_setpos_2  : in  std_logic_vector(7 downto 0);
		sin_setpos_3  : in  std_logic_vector(7 downto 0);
		sin_setpos_4  : in  std_logic_vector(7 downto 0);
		sin_setpos_5  : in  std_logic_vector(7 downto 0);
		sin_setpos_6  : in  std_logic_vector(7 downto 0);

		mode          : out std_logic_vector(3 downto 0);

		errors_1      : in  std_logic_vector(3 downto 0);
		errors_2      : in  std_logic_vector(3 downto 0);
		errors_3      : in  std_logic_vector(3 downto 0);
		errors_4      : in  std_logic_vector(3 downto 0);
		errors_5      : in  std_logic_vector(3 downto 0);
		errors_6      : in  std_logic_vector(3 downto 0);
		com_error     : in  std_logic;

		home_sensor_1 : in  std_logic;
		home_sensor_2 : in  std_logic;
		home_sensor_3 : in  std_logic;
		home_sensor_4 : in  std_logic;
		home_sensor_5 : in  std_logic;
		home_sensor_6 : in  std_logic;

		run_switch    : in  std_logic;
		reset_button  : in  std_logic;
		motor_enable  : out std_logic;

		speedlimit    : out std_logic_vector(9 downto 0)
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
	type t_err is array (1 to 6) of std_logic_vector(7 downto 0);
	signal err : t_err;
	signal i   : integer range 1 to 6;
	signal mde : integer range 10 to 15;
	type t_sim is (stop, wait4run, ramp, run, error);
	signal sim : t_sim;

	signal runswitch   : std_logic;
	signal resetbutton : std_logic;

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

		press_d      <= press;
		btn_w_d      <= btn_west;
		btn_e_d      <= btn_east;
		start        <= '0';
		home_enable  <= '0';
		motor_enable <= '0';

		runswitch   <= sw3;             --test
		resetbutton <= sw2;             --test

		case sim is
			when stop =>
				if runswitch = '0' then
					sim <= wait4run;
				end if;
			when wait4run =>
				if runswitch = '1' then
					sim        <= ramp;
					speedlimit <= (others => '0');
				end if;
				if sw0 = '1' and home_sensor_1 = '1' then
					err(4)(0) <= '1';   -- not in home position before rampup
					sim       <= error; -- do not start to ramp
				end if;
			when ramp =>
				motor_enable <= '1';
				if sync_20ms = '1' then
					speedlimit <= speedlimit + 1;
				end if;
				if speedlimit = 1000 then
					sim <= run;
					if sw0 = '1' and home_sensor_1 = '0' then
						err(5)(0) <= '1'; -- still in home position after rampup
					end if;
				end if;
				if runswitch = '0' then
					sim <= stop;
				end if;
			when run =>
				motor_enable       <= '1';
				err(1)(3 downto 0) <= errors_1;
				if or (err(1)) = '1' then --any error
					sim <= error;
				end if;
				if runswitch = '0' then
					sim <= stop;
				end if;
			when error  =>
			when others => sim <= stop;
		end case;

		if resetbutton = '1' then
			sim <= stop;
			for i in 1 to 6 loop
				err(i) <= (others => '0');
			end loop;

		end if;

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

		--		if sw3 = '1' then               --set mode 10..15 / A..F  
		--			mde <= i + 9;
		--		end if;
		mde <= 10;                      -- tbv test


		mode <= conv_std_logic_vector(mde, 4);

		case mde is
			when 11 =>                  --B
				set_pos_1 <= ext_setpos_1;
				set_pos_2 <= ext_setpos_2;
				set_pos_3 <= ext_setpos_3;
				set_pos_4 <= ext_setpos_4;
				set_pos_5 <= ext_setpos_5;
				set_pos_6 <= ext_setpos_6;
			when 12 | 13 | 14 | 15 =>   --C | D | E | F
				set_pos_1 <= sin_setpos_1;
				set_pos_2 <= sin_setpos_2;
				set_pos_3 <= sin_setpos_3;
				set_pos_4 <= sin_setpos_4;
				set_pos_5 <= sin_setpos_5;
				set_pos_6 <= sin_setpos_6;
			when others =>              --A 
				set_pos_1 <= setpos(1);
				set_pos_2 <= setpos(2);
				set_pos_3 <= setpos(3);
				set_pos_4 <= setpos(4);
				set_pos_5 <= setpos(5);
				set_pos_6 <= setpos(6);
		end case;

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

		kp <= '0' & '0' & '0' & sw1;

		--		if sw3 = '1' then
		--			val_1 <= conv_std_logic_vector(mde, 4) & "0000" & cnt(1) & cnt(2) & "0000" & cnt(3) & cnt(4) & "0000" & cnt(5) & cnt(6); --LCD line 2  1.6mm
		--		else
		case mde is
			when 11                => val_1 <= conv_std_logic_vector(i, 4) & "0000" & ext_setpos_1 & ext_setpos_2 & "0000" & ext_setpos_3 & ext_setpos_4 & "0000" & ext_setpos_5 & ext_setpos_6; --LCD line 2  1.6mm
			when 12 | 13 | 14 | 15 => val_1 <= conv_std_logic_vector(i, 4) & "0000" & sin_setpos_1 & sin_setpos_2 & "0000" & sin_setpos_3 & sin_setpos_4 & "0000" & sin_setpos_5 & sin_setpos_6; --LCD line 2  1.6mm
			when others            => val_1 <= conv_std_logic_vector(i, 4) & "0000" & cnt(1) & cnt(2) & "0000" & cnt(3) & cnt(4) & "0000" & cnt(5) & cnt(6); --LCD line 2  1.6mm
		end case;
		--		end if;

		led(0) <= leds(6);
		led(1) <= leds(5);
		led(2) <= leds(4);
		led(3) <= leds(3);
		led(4) <= leds(2);
		led(5) <= leds(1);
		led(6) <= '0';
		led(7) <= '0';

		if sim = error then
			val_1  <= conv_std_logic_vector(i, 4) & "0000" & err(1) & "00000000" & "0000" & "00000000" & "00000000" & "0000" & "00000000" & "00000000"; --LCD line 2  1.6mm
			led(0) <= '0';
			led(1) <= '0';
			led(2) <= '0';
			led(3) <= '0';
			led(4) <= '0';
			led(5) <= '0';
			led(6) <= '1';
			led(7) <= '1';
		end if;

		-- com error flash led 6 7 oid

		if reset = '1' then
			sm  <= init;
			sim <= stop;
			i   <= 1;
			mde <= 10;
			for j in 1 to 6 loop
				setpos(j)  := (others => '0');
				drvmode(j) := (others => '0');
				drvman(j)  := (others => '0');
			end loop;
		end if;

	end process;

end;