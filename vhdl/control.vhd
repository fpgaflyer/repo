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
		rtc       : out std_logic_vector(1 downto 0)
	);

end;

architecture behav of control is
	signal press_d : std_logic;
	signal btn_w_d : std_logic;
	signal btn_e_d : std_logic;
	signal cnt     : std_logic_vector(3 downto 0);
	type t_sm is (drive_cmd, ex_cmd, h1_cmd, mg_cmd);
	signal sm : t_sm;
begin
	process
	begin
		wait until clk = '1';

		press_d <= press;
		btn_w_d <= btn_west;
		btn_e_d <= btn_east;

		val_dis <= val_in0;

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
			case sm is
				when drive_cmd =>
					rtc <= "00";
					if btn_south = '1' then
						sm <= ex_cmd;
					end if;
				when ex_cmd =>
					rtc <= "01";
					sm  <= h1_cmd;
				when h1_cmd =>
					rtc <= "10";
					sm  <= mg_cmd;
				when mg_cmd =>
					rtc <= "11";
					if btn_south = '0' then
						sm <= ex_cmd;
					end if;
					sm <= drive_cmd;
				when others =>
					sm <= drive_cmd;
			end case;
		end if;

	end process;
	kp <= cnt;

end;
