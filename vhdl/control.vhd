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
		avg           : out std_logic;
		lcd_char0     : out std_logic_vector(3 downto 0);
		set_pos_1     : out std_logic_vector(13 downto 0);
		set_pos_2     : out std_logic_vector(13 downto 0);
		set_pos_3     : out std_logic_vector(13 downto 0);
		set_pos_4     : out std_logic_vector(13 downto 0);
		set_pos_5     : out std_logic_vector(13 downto 0);
		set_pos_6     : out std_logic_vector(13 downto 0);
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
		ext_setpos_1  : in  std_logic_vector(13 downto 0);
		ext_setpos_2  : in  std_logic_vector(13 downto 0);
		ext_setpos_3  : in  std_logic_vector(13 downto 0);
		ext_setpos_4  : in  std_logic_vector(13 downto 0);
		ext_setpos_5  : in  std_logic_vector(13 downto 0);
		ext_setpos_6  : in  std_logic_vector(13 downto 0);
		demo_setpos_1 : in  std_logic_vector(7 downto 0);
		demo_setpos_2 : in  std_logic_vector(7 downto 0);
		demo_setpos_3 : in  std_logic_vector(7 downto 0);
		demo_setpos_4 : in  std_logic_vector(7 downto 0);
		demo_setpos_5 : in  std_logic_vector(7 downto 0);
		demo_setpos_6 : in  std_logic_vector(7 downto 0);
		calc_offsets  : out std_logic;
		errors_1      : in  std_logic_vector(4 downto 0);
		errors_2      : in  std_logic_vector(4 downto 0);
		errors_3      : in  std_logic_vector(4 downto 0);
		errors_4      : in  std_logic_vector(4 downto 0);
		errors_5      : in  std_logic_vector(4 downto 0);
		errors_6      : in  std_logic_vector(4 downto 0);
		singul_error  : in  std_logic;
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
		power_off     : out std_logic;
		buzzer        : out std_logic;
		log_enable    : out std_logic;
		send_log      : out std_logic;
		tx_datalog    : in  std_logic;
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
	type t_cnttt_20ms is array (1 to 6) of std_logic_vector(4 downto 0);
	signal cnttt_20ms : t_cnttt_20ms;
	signal i          : integer range 1 to 6;
	signal mde        : integer range 10 to 15;
	type t_sim is (stop, wait4run, ramp, run, rampdown, error);
	signal sim          : t_sim;
	signal speedlimit   : std_logic_vector(9 downto 0);
	signal cnt_20ns     : std_logic_vector(9 downto 0);
	signal cnt_20ms     : std_logic_vector(5 downto 0);
	signal cntt_20ms    : std_logic_vector(9 downto 0);
	signal cntttt_20ms  : std_logic_vector(6 downto 0);
	signal cnttttt_20ms : std_logic_vector(7 downto 0);

	signal blanks          : integer range 0 to 6;
	signal leds            : std_logic_vector(7 downto 0);
	signal cnt_20ms_d      : std_logic;
	signal home            : std_logic;
	signal scroll          : std_logic_vector(7 downto 0);
	signal gohome          : std_logic;
	signal gohome_start    : std_logic;
	signal gohome_start_d  : std_logic;
	signal not_homed_alarm : std_logic;
	signal onetime         : std_logic;

begin
	process
		type t_setpos is array (1 to 6) of std_logic_vector(7 downto 0);
		variable setpos : t_setpos;
		type t_drvman is array (1 to 6) of std_logic_vector(10 downto 0);
		variable drvman      : t_drvman;
		variable homesensors : std_logic_vector(6 downto 1);
		variable errors      : std_logic_vector(29 downto 0);
		variable setpos_1    : std_logic_vector(13 downto 0);
		variable setpos_2    : std_logic_vector(13 downto 0);
		variable setpos_3    : std_logic_vector(13 downto 0);
		variable setpos_4    : std_logic_vector(13 downto 0);
		variable setpos_5    : std_logic_vector(13 downto 0);
		variable setpos_6    : std_logic_vector(13 downto 0);
		variable glow        : std_logic;

	begin
		wait until clk = '1';

		press_d        <= press;
		btn_w_d        <= btn_west;
		btn_e_d        <= btn_east;
		gohome_start_d <= gohome_start;
		start          <= '0';
		home_enable    <= '0';
		motor_enable   <= '1';
		log_enable     <= '1';
		send_log       <= '0';
		buzzer         <= '0';
		homesensors    := home_sensor_6 & home_sensor_5 & home_sensor_4 & home_sensor_3 & home_sensor_2 & home_sensor_1;
		errors         := err(1)(4 downto 0) & err(2)(4 downto 0) & err(3)(4 downto 0) & err(4)(4 downto 0) & err(5)(4 downto 0) & err(6)(4 downto 0);

		if sync_20ms = '1' then
			cnt_20ms     <= cnt_20ms + 1;
			cnttttt_20ms <= cnttttt_20ms + 1;
		end if;
		cnt_20ms_d <= cnt_20ms(2);

		if (reset_button = '1') and (sync_20ms = '1') and (cntt_20ms(9) = '0') then
			cntt_20ms    <= cntt_20ms + 1;
			home         <= '0';
			gohome_start <= '0';
			if cntt_20ms(8 downto 7) = "01" or cntt_20ms(8 downto 7) = "10" then
				home <= '1';
			elsif cntt_20ms(8 downto 7) = "11" then
				gohome_start <= '1';
			end if;
		end if;
		if gohome_start = '1' and gohome_start_d = '0' then
			gohome <= '1';              -- bring platform down to lowest position
		end if;
		if homesensors = 0 then         -- disable gohome mode after all actuators are in lowest position
			gohome <= '0';
		end if;

		if reset_button = '0' then
			cntt_20ms <= (others => '0');
		end if;

		cnt_20ns <= cnt_20ns + 1;
		if cnt_20ns > "1110000000" then
			glow := '1';
		else
			glow := '0';
		end if;

		case sim is
			when stop =>
				if home = '1' then
					for j in 0 to 7 loop
						leds(j) <= glow;
					end loop;
				else
					leds <= (others => '0');
				end if;
				speedlimit   <= (others => '0');
				calc_offsets <= '0';
				if run_switch = '0' then
					sim <= wait4run;
				end if;
			when wait4run =>
				if home = '1' then
					for j in 0 to 7 loop
						leds(j) <= glow;
					end loop;
				else
					leds <= (others => '0');
				end if;
				for j in 1 to 6 loop
					cnttt_20ms(j) <= (others => '0');
				end loop;
				if run_switch = '1' then
					if home = '1' and homesensors > 0 then
						for j in 1 to 6 loop
							err(j)(5) <= homesensors(j); -- not in home position before rampup
						end loop;
						sim <= error;
					else
						sim          <= ramp;
						scroll       <= "10000000";
						calc_offsets <= '1'; -- must be high for >20ms !!
					end if;
				end if;
			when ramp =>
				if cnt_20ms(2) = '1' and cnt_20ms_d = '0' then
					scroll <= scroll(0) & scroll(7 downto 1);
				end if;
				leds               <= scroll;
				err(1)(4 downto 0) <= errors_1(4 downto 3) & '0' & errors_1(1 downto 0); -- ignore loop error
				err(2)(4 downto 0) <= errors_2(4 downto 3) & '0' & errors_2(1 downto 0);
				err(3)(4 downto 0) <= errors_3(4 downto 3) & '0' & errors_3(1 downto 0);
				err(4)(4 downto 0) <= errors_4(4 downto 3) & '0' & errors_4(1 downto 0);
				err(5)(4 downto 0) <= errors_5(4 downto 3) & '0' & errors_5(1 downto 0);
				err(6)(4 downto 0) <= errors_6(4 downto 3) & '0' & errors_6(1 downto 0);
				if home = '1' then
					for i in 0 to 7 loop
						if scroll(i) = '0' then
							leds(i) <= glow;
						end if;
					end loop;
					for j in 1 to 6 loop
						err(j)(0) <= '0'; -- ignore position low error during home_enable
					end loop;
				end if;
				if sync_20ms = '1' then
					speedlimit <= speedlimit + 1;
				end if;
				if speedlimit = 1000 then
					sim <= run;
				end if;
				if home = '1' then      -- home position detected during rampup / home 
					for j in 1 to 6 loop
						if homesensors(j) = '1' and cnttt_20ms(j)(4) = '0' and sync_20ms = '1' then
							cnttt_20ms(j) <= cnttt_20ms(j) + 1;
						end if;
					end loop;
					if (cnttt_20ms(1)(4) = '1' and homesensors(1) = '0') or (cnttt_20ms(2)(4) = '1' and homesensors(2) = '0') or (cnttt_20ms(3)(4) = '1' and homesensors(3) = '0') or (cnttt_20ms(4)(4) = '1' and homesensors(4) = '0') or (cnttt_20ms(5)(4) = '1' and homesensors(5
						) = '0') or (cnttt_20ms(6)(4) = '1' and homesensors(6) = '0') then -- home position detected during rampup 
						power_off <= '1';
						sim       <= error;
						err(1)(6) <= not homesensors(1);
						err(2)(6) <= not homesensors(2);
						err(3)(6) <= not homesensors(3);
						err(4)(6) <= not homesensors(4);
						err(5)(6) <= not homesensors(5);
						err(6)(6) <= not homesensors(6);
					end if;
				else
					if homesensors /= "111111" then -- home position detected during rampup 
						power_off <= '1';
						sim       <= error;
						err(1)(6) <= not homesensors(1);
						err(2)(6) <= not homesensors(2);
						err(3)(6) <= not homesensors(3);
						err(4)(6) <= not homesensors(4);
						err(5)(6) <= not homesensors(5);
						err(6)(6) <= not homesensors(6);
					end if;
				end if;
				if errors > 0 or (mde = 10 and com_error = '1') or (singul_error = '1') then --any error
					sim <= error;
				end if;
				if run_switch = '0' then
					sim  <= stop;
					home <= '0';
				end if;
			when run =>
				home               <= '0';
				err(1)(4 downto 0) <= errors_1;
				err(2)(4 downto 0) <= errors_2;
				err(3)(4 downto 0) <= errors_3;
				err(4)(4 downto 0) <= errors_4;
				err(5)(4 downto 0) <= errors_5;
				err(6)(4 downto 0) <= errors_6;
				if homesensors /= "111111" then -- home position detected during run 
					power_off <= '1';
					sim       <= error;
					for j in 1 to 6 loop
						err(j)(7) <= not homesensors(j);
					end loop;
				end if;
				if (errors > 0) or (mde = 10 and com_error = '1') or (singul_error = '1') then --any error
					sim <= error;
				end if;
				leds <= "11111111";
				if run_switch = '0' then
					sim <= rampdown;
				end if;
			when rampdown =>
				home               <= '0';
				err(1)(4 downto 0) <= errors_1;
				err(2)(4 downto 0) <= errors_2;
				err(3)(4 downto 0) <= errors_3;
				err(4)(4 downto 0) <= errors_4;
				err(5)(4 downto 0) <= errors_5;
				err(6)(4 downto 0) <= errors_6;
				if homesensors /= "111111" then -- home position detected during rampdown 
					power_off <= '1';
					sim       <= error;
					for j in 1 to 6 loop
						err(j)(7) <= not homesensors(j);
					end loop;
				end if;
				if (errors > 0) or (mde = 10 and com_error = '1') or (singul_error = '1') then --any error
					sim <= error;
				end if;
				leds <= "00011000";
				if sync_2ms = '1' then
					speedlimit <= speedlimit - 1;
				end if;
				if speedlimit = 0 then
					sim <= stop;
				end if;
			when error =>
				motor_enable <= '0';
				if cntttt_20ms(6) = '0' and sync_20ms = '1' then -- stop logging after 1.28 sec 
					cntttt_20ms <= cntttt_20ms + 1;
				end if;
				if cntttt_20ms(6) = '1' then
					log_enable <= '0';
				end if;
				home           <= '0';
			when others => sim <= stop;
		end case;

		if reset_button = '1' then
			sim         <= stop;
			cntttt_20ms <= (others => '0');
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

		if (btn_west = '1') and (btn_east = '1') then
			send_log <= '1';
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

		if cnt_20ms(5) = '1' then
			blank <= blanks;
		else
			blank <= 0;
		end if;

		if home = '1' then
			home_enable <= '1';
		end if;

		if gohome = '1' then
			leds(7) <= cnt_20ms(3);
			leds(6) <= not cnt_20ms(3);
			leds(5) <= cnt_20ms(3);
			leds(4) <= not cnt_20ms(3);
			leds(3) <= cnt_20ms(3);
			leds(2) <= not cnt_20ms(3);
			leds(1) <= cnt_20ms(3);
			leds(0) <= not cnt_20ms(3);
		end if;

		if sync_2ms = '1' then
			start <= '1';
			for j in 1 to 6 loop
				drvman(j) := "00000000000";
			end loop;
			if run_switch = '1' or sim = rampdown then
				drv_mode <= '1';        -- position mode
				gohome   <= '0';
			else
				drv_mode <= '0';        -- speed mode
				if btn_north = '1' then
					gohome    <= '0';
					drvman(i) := "00000011001"; --  +25 (24V)
				end if;
				if btn_south = '1' then
					gohome    <= '0';
					drvman(i) := "11111100111"; -- -25  (24V)
				end if;
				if gohome = '1' then    -- bring platform down to lowest position
					for j in 1 to 6 loop
						if homesensors(j) = '1' then
							drvman(j) := "11111100111"; -- -25 (24V)
						end if;
					end loop;
				end if;
			end if;
		end if;

		if sw3 = '1' then               --set mode 10..15 / A..F  
			mde <= i + 9;
		end if;

		case mde is
			when 10 =>                  --A
				setpos_1 := ext_setpos_1;
				setpos_2 := ext_setpos_2;
				setpos_3 := ext_setpos_3;
				setpos_4 := ext_setpos_4;
				setpos_5 := ext_setpos_5;
				setpos_6 := ext_setpos_6;
			when 11 =>                  --B 
				setpos_1 := setpos(1) & "000000";
				setpos_2 := setpos(2) & "000000";
				setpos_3 := setpos(3) & "000000";
				setpos_4 := setpos(4) & "000000";
				setpos_5 := setpos(5) & "000000";
				setpos_6 := setpos(6) & "000000";
			when 12 =>                  --C
				setpos_1 := X"30" & "000000";
				setpos_2 := X"30" & "000000";
				setpos_3 := X"30" & "000000";
				setpos_4 := X"30" & "000000";
				setpos_5 := X"30" & "000000";
				setpos_6 := X"30" & "000000";
			when 13 =>                  --D
				setpos_1 := X"80" & "000000";
				setpos_2 := X"80" & "000000";
				setpos_3 := X"80" & "000000";
				setpos_4 := X"80" & "000000";
				setpos_5 := X"80" & "000000";
				setpos_6 := X"80" & "000000";
			when 14 =>                  --E
				setpos_1 := X"D0" & "000000";
				setpos_2 := X"D0" & "000000";
				setpos_3 := X"D0" & "000000";
				setpos_4 := X"D0" & "000000";
				setpos_5 := X"D0" & "000000";
				setpos_6 := X"D0" & "000000";
			when 15 =>                  --F
				setpos_1 := demo_setpos_1 & "000000";
				setpos_2 := demo_setpos_2 & "000000";
				setpos_3 := demo_setpos_3 & "000000";
				setpos_4 := demo_setpos_4 & "000000";
				setpos_5 := demo_setpos_5 & "000000";
				setpos_6 := demo_setpos_6 & "000000";
			when others => null;
		end case;

		drv_man_1 <= drvman(1);
		drv_man_2 <= drvman(2);
		drv_man_3 <= drvman(3);
		drv_man_4 <= drvman(4);
		drv_man_5 <= drvman(5);
		drv_man_6 <= drvman(6);

		set_pos_1 <= setpos_1;
		set_pos_2 <= setpos_2;
		set_pos_3 <= setpos_3;
		set_pos_4 <= setpos_4;
		set_pos_5 <= setpos_5;
		set_pos_6 <= setpos_6;

		kp  <= '0' & '0' & sw1 & sw0;
		avg <= sw2;

		if cnt_20ms(5) = '1' then
			if avg = '1' then
				lcd_char0 <= X"B";
			else
				lcd_char0 <= X"A";
			end if;
		else
			lcd_char0 <= kp;
		end if;

		case mde is
			when 11 =>
				val_1 <= conv_std_logic_vector(i, 4) & "0000" & cnt(1) & cnt(2) & "0000" & cnt(3) & cnt(4) & "0000" & cnt(5) & cnt(6); --LCD line 2  1.6mm
			when others =>
				val_1 <= conv_std_logic_vector(i, 4) & "0000" & setpos_1(13 downto 6) & setpos_2(13 downto 6) & "0000" & setpos_3(13 downto 6) & setpos_4(13 downto 6) & "0000" & setpos_5(13 downto 6) & setpos_6(13 downto 6); --LCD line 2  1.6mm
				blank <= 0;
		end case;
		if sw3 = '1' then
			val_1(63 downto 60) <= conv_std_logic_vector(mde, 4);
		end if;

		if sim = error then
			val_1 <= conv_std_logic_vector(i, 4) & "0000" & err(1) & err(2) & "0000" & err(3) & err(4) & "0000" & err(5) & err(6); --LCD line 2  1.6mm --LCD line 2  1.6mm
			blank <= 0;
			for i in 0 to 7 loop
				leds(i) <= cnt_20ms(3);
			end loop;
		end if;

		if mde = 10 and com_error = '1' then
			leds(0)          <= cnt_20ms(3);
			leds(7 downto 1) <= (others => '0');
		end if;

		if (cnttttt_20ms(7) = '1') and (onetime = '0') then
			onetime <= '1';
			if (homesensors > 0) then
				not_homed_alarm <= '1';
			end if;
		end if;

		if not_homed_alarm = '1' and cnttttt_20ms > 254 then -- buzzer short beep
			buzzer <= '1';
		end if;

		if singul_error = '1' then
			buzzer           <= '1';
			leds(7)          <= cnt_20ms(3);
			leds(6 downto 0) <= (others => '0');
		end if;

		if tx_datalog = '1' then
			leds <= "00011000";
		end if;

		speed_limit <= speedlimit;
		led         <= leds;

		if reset = '1' then
			sim             <= stop;
			i               <= 1;
			mde             <= 10;
			blanks          <= 0;
			power_off       <= '0';
			gohome_start    <= '0';
			gohome_start_d  <= '0';
			gohome          <= '0';
			cntttt_20ms     <= (others => '0');
			cnttttt_20ms    <= (others => '0');
			not_homed_alarm <= '0';
			onetime         <= '0';
			for j in 1 to 6 loop
				setpos(j) := (others => '0');
				drvman(j) := (others => '0');
				err(j)    <= (others => '0');
				cnt(j)    <= (others => '0');
			end loop;
		end if;

	end process;

end;