library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity home_position is
	port(
		clk         : in  std_logic;
		reset       : in  std_logic;
		home_enable : in  std_logic;
		home_sensor : in  std_logic;
		pos_in      : in  std_logic_vector(14 downto 0); --25um 0-82cm
		pos_out     : out std_logic_vector(14 downto 0) --25um 0-82cm

	);
end entity home_position;

architecture RTL of home_position is
	signal home_sensor_d : std_logic;
	signal diff          : std_logic_vector(14 downto 0);

begin
	process
	begin
		wait until clk = '1';

		home_sensor_d <= home_sensor;

		if (home_enable = '1') and (home_sensor_d = '0') and (home_sensor = '1') then --rising edge
			diff <= pos_in;
		end if;

		pos_out <= pos_in - diff;

		if reset = '1' then
			diff <= (others => '0');
		end if;

	end process;

end architecture RTL;
