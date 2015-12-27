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

		drv_mode      : out std_logic;

		drv_man_1     : out std_logic_vector(10 downto 0);
		drv_man_2     : out std_logic_vector(10 downto 0);
		drv_man_3     : out std_logic_vector(10 downto 0);
		drv_man_4     : out std_logic_vector(10 downto 0);
		drv_man_5     : out std_logic_vector(10 downto 0);
		drv_man_6     : out std_logic_vector(10 downto 0);

		led           : out std_logic_vector(7 downto 0);
		val_1         : out std_logic_vector(63 downto 0);
		blank         : out integer range 0 to 6;

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

		speed_limit   : out std_logic_vector(9 downto 0)
	);
end;

architecture behav of control is
	signal press_d : std_logic;
	signal btn_w_d : std_logic;
	signal btn_e_d : std_logic;
	type t_cnt is array (1 to 6) of std_logic_vector(7 downto 0);
	signal cnt : t_cnt;
	type t_err is array (1 to 6) of std_logic_vector(7 downto 0);
	signal err : t_err;
	signal i   : integer range 1 to 6;
	signal mde : integer range 10 to 15;
	type t_sim is (stop, wait4run, ramp, run, error);
	signal sim        : t_sim;
	signal speedlimit : std_logic_vector(9 downto 0);
	signal blink      : std_logic_vector(5 downto 0);
	signal blanks     : integer range 0 to 6;

begin
	process
		type t_setpos is array (1 to 6) of std_logic_vector(7 downto 0);
		variable setpos : t_setpos;
		type t_drvman is array (1 to 6) of std_logic_vector(10 downto 0);
		variable drvman      : t_drvman;
		variable homesensors : std_logic_vector(6 downto 1);
		variable errors      : std_logic_vector(23 downto 0);

	begin
		wait until clk = '1';

		press_d      <= press;
		btn_w_d      <= btn_west;
		btn_e_d      <= btn_east;
		start        <= '0';
		home_enable  <= '0';
		motor_enable <= '1';
		homesensors  := home_sensor_6 & home_sensor_5 & home_sensor_4 & home_sensor_3 & home_sensor_2 & home_sensor_1;
		errors       := err(1)(3 downto 0) & err(2)(3 downto 0) & err(3)(3 downto 0) & err(4)(3 downto 0) & err(5)(3 downto 0) & err(6)(3 downto 0);

		if sync_20ms = '1' then
			blink <= blink + 1;
		end if;

		case sim is
			when stop =>
				led(6)     <= '0';
				led(7)     <= '0';
				speedlimit <= (others => '0');
				if run_switch = '0' then
					sim <= wait4run;
				end if;
			when wait4run =>
				if run_switch = '1' then
					if sw0 = '1' and homesensors > 0 then
						for j in 1 to 6 loop
							err(j)(4) <= homesensors(j); -- not in home position before rampup
						end loop;
						sim <= error;
					else
						sim <= ramp;
					end if;
				end if;
			when ramp =>
				led(6)             <= blink(5);
				led(7)             <= not blink(5);
				err(1)(3 downto 0) <= errors_1(3) & '0' & errors_1(1 downto 0); -- ignore loop error
				err(2)(3 downto 0) <= errors_2(3) & '0' & errors_2(1 downto 0);
				err(3)(3 downto 0) <= errors_3(3) & '0' & errors_3(1 downto 0);
				err(4)(3 downto 0) <= errors_4(3) & '0' & errors_4(1 downto 0);
				err(5)(3 downto 0) <= errors_5(3) & '0' & errors_5(1 downto 0);
				err(6)(3 downto 0) <= errors_6(3) & '0' & errors_6(1 downto 0);
				if sw0 = '1' then
					led(7) <= blink(5);
					for j in 1 to 6 loop
						err(j)(0) <= '0'; -- ignore position low error during home_enable
					end loop;
				end if;
				if errors > 0 then      --any error
					sim <= error;
				end if;
				if sync_20ms = '1' then
					speedlimit <= speedlimit + 1;
				end if;
				if speedlimit = 1000 then
					if sw0 = '1' and homesensors /= "111111" then
						for j in 1 to 6 loop
							err(j)(5) <= not homesensors(j); -- still in home position after rampup
						end loop;
						sim <= error;
					else
						sim <= run;
					end if;
				end if;
				if run_switch = '0' then
					sim <= stop;
				end if;
			when run =>
				led(6)             <= blink(3);
				led(7)             <= not blink(3);
				err(1)(3 downto 0) <= errors_1;
				err(2)(3 downto 0) <= errors_2;
				err(3)(3 downto 0) <= errors_3;
				err(4)(3 downto 0) <= errors_4;
				err(5)(3 downto 0) <= errors_5;
				err(6)(3 downto 0) <= errors_6;
				if errors > 0 then      --any error
					sim <= error;
				end if;
				if sw0 = '1' then
					led(7) <= blink(3);
				end if;
				if run_switch = '0' then
					sim <= stop;
				end if;
			when error  => motor_enable <= '0';
			when others => sim <= stop;
		end case;

		if reset_button = '1' then
			sim <= stop;
			for i in 1 to 6 loop
				err(i) <= (others => '0');
			end loop;

		end if;

		if (btn_west = '1') and (btn_w_d = '0') and (i > 1) then
			i <= i - 1;
		end if;
		if (btn_east = '1') and (btn_e_d = '0') and (i < 6) then
			i <= i + 1;
		end if;

		if rotary_event = '1' then
			blanks <= i;                -- blanks intermittend selected set position values on LCD
			if rotary_left = '0' then
				cnt(i) <= cnt(i) + 1;
			else
				cnt(i) <= cnt(i) - 1;
			end if;
		end if;

		if (press = '1') and (press_d = '0') then
			setpos(i) := cnt(i);
			blanks    <= 0;
		end if;

		if blink(5) = '1' then
			blank <= blanks;
		else
			blank <= 0;
		end if;

		if sw0 = '1' then
			home_enable <= '1';
		end if;

		if sync_2ms = '1' then
			start <= '1';
			if run_switch = '1' then
				drv_mode <= '1';        -- position mode
				led(0)   <= '1';
				led(1)   <= '1';
				led(2)   <= '1';
				led(3)   <= '1';
				led(4)   <= '1';
				led(5)   <= '1';
			else
				drv_mode  <= '0';       -- speed mode
				led(0)    <= '0';
				led(1)    <= '0';
				led(2)    <= '0';
				led(3)    <= '0';
				led(4)    <= '0';
				led(5)    <= '0';
				drvman(i) := "00000000000";
				if btn_north = '1' then
					drvman(i) := "00000110010"; --  +50
				end if;
				if btn_south = '1' then
					drvman(i) := "11111001110"; -- -50
				end if;
			end if;
		end if;

		if sw3 = '1' then               --set mode 10..15 / A..F  
			mde <= i + 9;
		end if;

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

		drv_man_1 <= drvman(1);
		drv_man_2 <= drvman(2);
		drv_man_3 <= drvman(3);
		drv_man_4 <= drvman(4);
		drv_man_5 <= drvman(5);
		drv_man_6 <= drvman(6);

		kp <= '0' & '0' & sw2 & sw1;

		case mde is
			when 11 =>
				val_1 <= conv_std_logic_vector(i, 4) & "0000" & ext_setpos_1 & ext_setpos_2 & "0000" & ext_setpos_3 & ext_setpos_4 & "0000" & ext_setpos_5 & ext_setpos_6; --LCD line 2  1.6mm
				blank <= 0;
			when 12 | 13 | 14 | 15 =>
				val_1 <= conv_std_logic_vector(i, 4) & "0000" & sin_setpos_1 & sin_setpos_2 & "0000" & sin_setpos_3 & sin_setpos_4 & "0000" & sin_setpos_5 & sin_setpos_6; --LCD line 2  1.6mm
				blank <= 0;
			when others =>
				val_1 <= conv_std_logic_vector(i, 4) & "0000" & cnt(1) & cnt(2) & "0000" & cnt(3) & cnt(4) & "0000" & cnt(5) & cnt(6); --LCD line 2  1.6mm
		end case;
		if sw3 = '1' then
			val_1(63 downto 60) <= conv_std_logic_vector(mde, 4);
		end if;

		if sim = error then
			val_1  <= conv_std_logic_vector(i, 4) & "0000" & err(1) & err(2) & "0000" & err(3) & err(4) & "0000" & err(5) & err(6); --LCD line 2  1.6mm --LCD line 2  1.6mm
			blank  <= 0;
			led(0) <= '0';
			led(1) <= '0';
			led(2) <= '0';
			led(3) <= '0';
			led(4) <= '0';
			led(5) <= '0';
			led(6) <= '1';
			led(7) <= '1';
		end if;

		speed_limit <= speedlimit;

		-- com error flash led 6 7 oid

		if reset = '1' then
			sim <= stop;
			i   <= 1;
			mde <= 10;
			for j in 1 to 6 loop
				setpos(j) := (others => '0');
				drvman(j) := (others => '0');
				err(j)    <= (others => '0');
			end loop;
		end if;

	end process;

end;