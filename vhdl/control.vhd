library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
	port(
		clk       : in  std_logic;
		press     : in  std_logic;
		btn_west  : in  std_logic;
		btn_east  : in  std_logic;
--		sw0       : in  std_logic;
		kp        : out std_logic_vector(3 downto 0);
		val_in    : in  std_logic_vector(7 downto 0);
		val_out   : out std_logic_vector(7 downto 0);

		sync_20ms : in  std_logic
	);

end;

architecture behav of control is
	signal press_d : std_logic;
	signal btn_w_d : std_logic;
	signal btn_e_d : std_logic;
	signal cnt     : std_logic_vector(3 downto 0);
	signal addr    : std_logic_vector(10 downto 0);

begin
	process
	begin
		wait until clk = '1';

		press_d <= press;
		btn_w_d <= btn_west;
		btn_e_d <= btn_east;

--		if sync_20ms = '1' then
--			addr <= addr + 1;
--		end if;

		if (press = '1') and (press_d = '0') then
			val_out <= val_in;
		end if;

		if (btn_west = '1') and (btn_w_d = '0') then
			cnt <= cnt - 1;
		end if;

		if (btn_east = '1') and (btn_e_d = '0') then
			cnt <= cnt + 1;
		end if;

--		if sw0 = '1' then
--			val_out <= rom_data;
--		else
--			addr <= (others => '0');
--		end if;

	end process;

--	rom_addr <= addr;
	kp       <= cnt;

end;
