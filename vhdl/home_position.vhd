library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity home_position is
	port(
		clk            : in  std_logic;
		reset          : in  std_logic;
		home_enable    : in  std_logic;
		home_sensor    : in  std_logic;
		pos_in         : in  std_logic_vector(14 downto 0); --25um 0-82cm
		pos_out        : out std_logic_vector(14 downto 0); --25um 0-82cm
		pos_high_error : out std_logic;
		pos_low_error  : out std_logic
	);
end entity home_position;

architecture RTL of home_position is
	signal home_sensor_d : std_logic;
	signal diff          : std_logic_vector(14 downto 0);

begin
	process
		variable posout : std_logic_vector(14 downto 0);
	begin
		wait until clk = '1';

		home_sensor_d  <= home_sensor;
		pos_high_error <= '0';
		pos_low_error  <= '0';

		if (home_enable = '1') and (home_sensor_d = '0') and (home_sensor = '1') then --rising edge
			diff <= pos_in;
		end if;

		posout := pos_in - diff;

		if posout(13 downto 6) > X"F0" then -->38.4cm
			pos_high_error <= '1';
		end if;
		if posout(13 downto 6) < X"06" then --<0.96cm
			pos_low_error <= '1';
		end if;

		pos_out <= posout;

		if reset = '1' then
			diff <= (others => '0');
		end if;

	end process;

end architecture RTL;
