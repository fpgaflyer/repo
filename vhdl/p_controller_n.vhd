library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity p_controller_n is
	port(
		clk    : in  std_logic;
		reset  : in  std_logic;
		kp     : in  std_logic_vector(3 downto 0);
		setpos : in  std_logic_vector(7 downto 0); --1.6mm unit, range 0 - 409.6 mm
		pos    : in  std_logic_vector(13 downto 0); --25um unit,  range 0 - 409.6 mm
		drive  : out std_logic_vector(10 downto 0)
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

begin
	process
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
			e <= ('0' & setpos & "000000") - ('0' & pos); --(setpos x 64) - pos

			if e(14) = '1' then         --neg
				e_abs <= (not e(13 downto 0)) + 1;
			else
				e_abs <= e(13 downto 0);
			end if;
			sign_1d <= e(14);

			drv     <= kp * e_abs;
			sign_2d <= sign_1d;

			drv_div <= drv(17 downto 2); --/4
			sign_3d <= sign_2d;

			if drv_div > "0000001111101000" then --  >1000
				drv_lim <= "0000001111101000";
			else
				drv_lim <= drv_div;
			end if;
			sign_4d <= sign_3d;

			if sign_4d = '1' then       --neg
				drive <= '1' & (not drv_lim(9 downto 0)) + 1;
			else
				drive <= '0' & drv_lim(9 downto 0);
			end if;

		end if;

	end process;

end;
