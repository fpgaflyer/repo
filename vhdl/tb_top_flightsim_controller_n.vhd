-- simulation runtime 5ms

entity tb_top_flightsim_controller_n is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture structure of tb_top_flightsim_controller_n is
	component top_flightsim_controller_n
		port(clk            : in  std_logic;
			 strataflash_oe : out std_logic;
			 strataflash_ce : out std_logic;
			 strataflash_we : out std_logic;
			 lcd_data       : out std_logic_vector(7 downto 4);
			 lcd_rs         : out std_logic;
			 lcd_rw         : out std_logic;
			 lcd_en         : out std_logic;
			 rotary_a       : in  std_logic;
			 rotary_b       : in  std_logic;
			 rotary_press   : in  std_logic;
			 btn_west       : in  std_logic;
			 btn_east       : in  std_logic;
			 serial_out     : out std_logic;
			 serial_in      : in  std_logic
		);
	end component top_flightsim_controller_n;

	signal CLK50          : std_logic := '1';
	signal strataflash_oe : std_logic;
	signal strataflash_ce : std_logic;
	signal strataflash_we : std_logic;
	signal lcd_data       : std_logic_vector(7 downto 4);
	signal lcd_rs         : std_logic;
	signal lcd_rw         : std_logic;
	signal lcd_en         : std_logic;
	signal ROT_A          : std_logic;
	signal ROT_B          : std_logic;
	signal ROT_P          : std_logic;
	signal BTN_WEST       : std_logic;
	signal BTN_EAST       : std_logic;
	signal serial_out     : std_logic;
	signal SERIAL_IN      : std_logic;

begin
	CLK50 <= NOT CLK50 after 10 ns;

	ROT_A <= '0', '0' after 350000 ns, '1' after 360000 ns, '1' after 370000 ns, '0' after 380000 ns, '0' after 390000 ns, '1' after 400000 ns, '1' after 410000 ns, '0' after 420000 ns, '0' after 650000 ns, '1' after 660000 ns, '1' after 670000 ns, '0' after 680000 ns, '0' after 690000 ns, '1' after
		700000 ns, '1' after 710000 ns, '0' after 720000 ns;

	ROT_B <= '1', '0' after 350000 ns, '0' after 360000 ns, '1' after 370000 ns, '1' after 380000 ns, '0' after 390000 ns, '0' after 400000 ns, '1' after 410000 ns, '1' after 420000 ns, '0' after 650000 ns, '0' after 660000 ns, '1' after 670000 ns, '1' after 680000 ns, '0' after 690000 ns, '0' after
		700000 ns, '1' after 710000 ns, '1' after 720000 ns;

	ROT_P <= '0';

	BTN_WEST <= '0';

	BTN_EAST <= '0';

	SERIAL_IN <= '0';

	A1 : component top_flightsim_controller_n
		port map(clk            => CLK50,
			     strataflash_oe => strataflash_oe,
			     strataflash_ce => strataflash_ce,
			     strataflash_we => strataflash_we,
			     lcd_data       => lcd_data,
			     lcd_rs         => lcd_rs,
			     lcd_rw         => lcd_rw,
			     lcd_en         => lcd_en,
			     rotary_a       => ROT_A,
			     rotary_b       => ROT_B,
			     rotary_press   => ROT_P,
			     btn_west       => btn_west,
			     btn_east       => btn_east,
			     serial_out     => serial_out,
			     serial_in      => serial_in
		);

end;

