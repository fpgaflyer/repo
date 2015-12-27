library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity p_controller_n is
	port(
		clk         : in  std_logic;
		reset       : in  std_logic;
		sync_20ms   : in  std_logic;
		kp          : in  std_logic_vector(3 downto 0);
		setpos      : in  std_logic_vector(7 downto 0); --1.6mm unit, range 0-41cm
		pos         : in  std_logic_vector(13 downto 0); --25um unit, range 0-41cm
		speed_limit : in  std_logic_vector(9 downto 0); --drive limit 0 - 1000
		drive       : out std_logic_vector(10 downto 0); -- -1000 / +1000
		loop_error  : out std_logic     -- error > 10cm during 1.28sec
	);

end;

architecture behav of p_controller_n is
	signal e       : std_logic_vector(14 downto 0);
	signal e_abs   : std_logic_vector(13 downto 0);
	signal drv_lim : std_logic_vector(15 downto 0);
	signal drv     : std_logic_vector(17 downto 0);
	signal drv_div : std_logic_vector(15 downto 0);
	signal sign_1d : std_logic;
	signal sign_2d : std_logic;
	signal sign_3d : std_logic;
	signal sign_4d : std_logic;
	signal err     : std_logic;

begin
	process
		variable cnt_20ms : std_logic_vector(6 downto 0);
	begin
		wait until clk = '1';

		if (reset = '1') then
			e       <= (others => '0');
			e_abs   <= (others => '0');
			drv_lim <= (others => '0');
			drv     <= (others => '0');
			drv_div <= (others => '0');
			sign_1d <= '0';
			sign_2d <= '0';
			sign_3d <= '0';
			sign_4d <= '0';
			drive   <= (others => '0'); -- stop

		else
			err <= '0';

			e <= ('0' & setpos & "000000") - ('0' & pos); -- setpos - pos

			if e(14) = '1' then         --neg
				e_abs <= (not e(13 downto 0)) + 1;
			else
				e_abs <= e(13 downto 0);
			end if;
			sign_1d <= e(14);

			if e_abs > "00111111111111" then -- loop error > 10.2375cm 
				err <= '1';
			end if;

			drv     <= kp * e_abs;
			sign_2d <= sign_1d;

			drv_div <= drv(17 downto 2); --/4
			sign_3d <= sign_2d;

			if drv_div > "000000" & speed_limit then
				drv_lim <= "000000" & speed_limit;
			else
				drv_lim <= drv_div;
			end if;
			sign_4d <= sign_3d;

			if sign_4d = '1' then       --neg
				drive <= '1' & (not drv_lim(9 downto 0)) + 1;
			else
				drive <= '0' & drv_lim(9 downto 0);
			end if;

			if sync_20ms = '1' and cnt_20ms(6) /= '1' then --loop error delay 1.28s
				cnt_20ms := cnt_20ms + 1;
			end if;
			if err = '0' then
				cnt_20ms := (others => '0');
			end if;
			loop_error <= cnt_20ms(6);

		end if;

	end process;

end;
