library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library gen;
use gen.std.all;

entity top_flightsim_controller_n is
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
		 btn_north      : in  std_logic;
		 btn_west       : in  std_logic;
		 btn_east       : in  std_logic;
		 btn_south      : in  std_logic;
		 sw0            : in  std_logic;
		 sw1            : in  std_logic;
		 sw2            : in  std_logic;
		 sw3            : in  std_logic;
		 led            : out std_logic_vector(7 downto 0);
		 run_switch     : in  std_logic;
		 --		 reset_button   : in  std_logic;
		 motor_stop     : out std_logic;

		 home_sensor_1  : in  std_logic;
		 home_sensor_2  : in  std_logic;
		 home_sensor_3  : in  std_logic;
		 home_sensor_4  : in  std_logic;
		 home_sensor_5  : in  std_logic;
		 home_sensor_6  : in  std_logic;

		 serial_in_1    : in  std_logic;
		 serial_in_2    : in  std_logic;
		 serial_in_3    : in  std_logic;
		 serial_in_4    : in  std_logic;
		 serial_in_5    : in  std_logic;
		 serial_in_6    : in  std_logic;

		 serial_out_1   : out std_logic;
		 serial_out_2   : out std_logic;
		 serial_out_3   : out std_logic;
		 serial_out_4   : out std_logic;
		 serial_out_5   : out std_logic;
		 serial_out_6   : out std_logic;

		 rxd            : in  std_logic;
		 txd            : out std_logic
	);
end;

architecture structure of top_flightsim_controller_n is

	-- component declarations
	component reset_gen_n
		port(
			clk   : in  std_logic;
			reset : out std_logic
		);
	end component;

	component clk_divider_n
		port(clk        : in  std_logic;
			 sync_2ms   : out std_logic;
			 sync_20ms  : out std_logic;
			 en_16xbaud : out std_logic);
	end component clk_divider_n;

	component lcd_controller_n
		port(clk      : in  std_logic;
			 reset    : in  std_logic;
			 data     : in  std_logic_vector(7 downto 0);
			 addr     : in  std_logic_vector(6 downto 0);
			 data_en  : in  std_logic;
			 rdy      : out std_logic;
			 lcd_en   : out std_logic;
			 lcd_rs   : out std_logic;
			 lcd_rw   : out std_logic;
			 lcd_data : out std_logic_vector(7 downto 4));
	end component lcd_controller_n;

	component display_controller_n
		port(clk     : in  std_logic;
			 reset   : in  std_logic;
			 val_0   : in  std_logic_vector(63 downto 0);
			 val_1   : in  std_logic_vector(63 downto 0);
			 data    : out std_logic_vector(7 downto 0);
			 addr    : out std_logic_vector(6 downto 0);
			 data_en : out std_logic;
			 nxt     : in  std_logic);
	end component display_controller_n;

	component rotary_decoder_n
		port(rotary_a     : in  std_logic;
			 rotary_b     : in  std_logic;
			 clk          : in  std_logic;
			 rotary_event : out std_logic;
			 rotary_left  : out std_logic);
	end component rotary_decoder_n;

	component controller
		port(clk         : in  std_logic;
			 reset       : in  std_logic;
			 start       : in  std_logic;
			 en_16xbaud  : in  std_logic;
			 serial_in   : in  std_logic;
			 home_en     : in  std_logic;
			 kp          : in  std_logic_vector(3 downto 0);
			 home_sensor : in  std_logic;
			 set_pos     : in  std_logic_vector(7 downto 0);
			 drv_mode    : in  std_logic_vector(1 downto 0);
			 drv_man     : in  std_logic_vector(10 downto 0);
			 position    : out std_logic_vector(7 downto 0);
			 serial_out  : out std_logic);
	end component controller;

	component control
		port(clk          : in  std_logic;
			 reset        : in  std_logic;
			 sync_2ms     : in  std_logic;
			 rotary_event : in  std_logic;
			 rotary_left  : in  std_logic;
			 press        : in  std_logic;
			 btn_north    : in  std_logic;
			 btn_west     : in  std_logic;
			 btn_east     : in  std_logic;
			 btn_south    : in  std_logic;
			 sw0          : in  std_logic;
			 sw1          : in  std_logic;
			 sw2          : in  std_logic;
			 sw3          : in  std_logic;
			 start        : out std_logic;
			 home_enable  : out std_logic;
			 kp           : out std_logic_vector(3 downto 0);
			 set_pos_1    : out std_logic_vector(7 downto 0);
			 set_pos_2    : out std_logic_vector(7 downto 0);
			 set_pos_3    : out std_logic_vector(7 downto 0);
			 set_pos_4    : out std_logic_vector(7 downto 0);
			 set_pos_5    : out std_logic_vector(7 downto 0);
			 set_pos_6    : out std_logic_vector(7 downto 0);
			 drv_mode_1   : out std_logic_vector(1 downto 0);
			 drv_mode_2   : out std_logic_vector(1 downto 0);
			 drv_mode_3   : out std_logic_vector(1 downto 0);
			 drv_mode_4   : out std_logic_vector(1 downto 0);
			 drv_mode_5   : out std_logic_vector(1 downto 0);
			 drv_mode_6   : out std_logic_vector(1 downto 0);
			 drv_man_1    : out std_logic_vector(10 downto 0);
			 drv_man_2    : out std_logic_vector(10 downto 0);
			 drv_man_3    : out std_logic_vector(10 downto 0);
			 drv_man_4    : out std_logic_vector(10 downto 0);
			 drv_man_5    : out std_logic_vector(10 downto 0);
			 drv_man_6    : out std_logic_vector(10 downto 0);
			 led          : out std_logic_vector(7 downto 0);
			 val_1        : out std_logic_vector(63 downto 0);
			 ext_setpos_1 : in  std_logic_vector(7 downto 0);
			 ext_setpos_2 : in  std_logic_vector(7 downto 0);
			 ext_setpos_3 : in  std_logic_vector(7 downto 0);
			 ext_setpos_4 : in  std_logic_vector(7 downto 0);
			 ext_setpos_5 : in  std_logic_vector(7 downto 0);
			 ext_setpos_6 : in  std_logic_vector(7 downto 0));
	end component control;

	component digital_filter
		port(clk   : in  std_logic;
			 reset : in  std_logic;
			 i     : in  std_logic;
			 o     : out std_logic);
	end component digital_filter;

	component serial_rx
		port(clk           : in  std_logic;
			 reset         : in  std_logic;
			 rx            : in  std_logic;
			 rx_data       : out std_logic_vector(7 downto 0);
			 rx_data_valid : out std_logic);
	end component serial_rx;

	component serial_rx_dec_n
		port(clk           : in  std_logic;
			 reset         : in  std_logic;
			 rx_data       : in  std_logic_vector(7 downto 0);
			 rx_data_valid : in  std_logic;
			 byte_1        : out std_logic_vector(7 downto 0);
			 byte_2        : out std_logic_vector(7 downto 0);
			 byte_3        : out std_logic_vector(7 downto 0);
			 byte_4        : out std_logic_vector(7 downto 0);
			 byte_5        : out std_logic_vector(7 downto 0);
			 byte_6        : out std_logic_vector(7 downto 0);
			 byte_7        : out std_logic_vector(7 downto 0);
			 com_error     : out std_logic);
	end component serial_rx_dec_n;

	component filter
		port(clk   : in  std_logic;
			 reset : in  std_logic;
			 i     : in  std_logic;
			 o     : out std_logic);
	end component filter;

	-- declaration of signals used to interconnect 

	signal reset           : std_logic;
	signal sync_2ms        : std_logic;
	signal data            : std_logic_vector(7 downto 0);
	signal addr            : std_logic_vector(6 downto 0);
	signal data_en         : std_logic;
	signal rdy             : std_logic;
	signal rotary_event    : std_logic;
	signal rotary_left     : std_logic;
	signal en_16xbaud      : std_logic;
	signal val_0           : std_logic_vector(63 downto 0);
	signal val_1           : std_logic_vector(63 downto 0);
	signal btn_north_f     : std_logic;
	signal btn_west_f      : std_logic;
	signal btn_east_f      : std_logic;
	signal btn_south_f     : std_logic;
	signal sw0_f           : std_logic;
	signal sw1_f           : std_logic;
	signal sw2_f           : std_logic;
	signal sw3_f           : std_logic;
	signal press           : std_logic;
	signal kp              : std_logic_vector(3 downto 0);
	signal start           : std_logic;
	signal home_enable     : std_logic;
	signal set_pos_1       : std_logic_vector(7 downto 0);
	signal set_pos_2       : std_logic_vector(7 downto 0);
	signal set_pos_3       : std_logic_vector(7 downto 0);
	signal set_pos_4       : std_logic_vector(7 downto 0);
	signal set_pos_5       : std_logic_vector(7 downto 0);
	signal set_pos_6       : std_logic_vector(7 downto 0);
	signal drv_mode_1      : std_logic_vector(1 downto 0);
	signal drv_mode_2      : std_logic_vector(1 downto 0);
	signal drv_mode_3      : std_logic_vector(1 downto 0);
	signal drv_mode_4      : std_logic_vector(1 downto 0);
	signal drv_mode_5      : std_logic_vector(1 downto 0);
	signal drv_mode_6      : std_logic_vector(1 downto 0);
	signal drv_man_1       : std_logic_vector(10 downto 0);
	signal drv_man_2       : std_logic_vector(10 downto 0);
	signal drv_man_3       : std_logic_vector(10 downto 0);
	signal drv_man_4       : std_logic_vector(10 downto 0);
	signal drv_man_5       : std_logic_vector(10 downto 0);
	signal drv_man_6       : std_logic_vector(10 downto 0);
	signal position_1      : std_logic_vector(7 downto 0);
	signal position_2      : std_logic_vector(7 downto 0);
	signal position_3      : std_logic_vector(7 downto 0);
	signal position_4      : std_logic_vector(7 downto 0);
	signal position_5      : std_logic_vector(7 downto 0);
	signal position_6      : std_logic_vector(7 downto 0);
	signal home_sensor_1_f : std_logic;
	signal home_sensor_2_f : std_logic;
	signal home_sensor_3_f : std_logic;
	signal home_sensor_4_f : std_logic;
	signal home_sensor_5_f : std_logic;
	signal home_sensor_6_f : std_logic;
	signal rx_data         : std_logic_vector(7 downto 0);
	signal rx_data_valid   : std_logic;
	signal byte_2          : std_logic_vector(7 downto 0);
	signal byte_3          : std_logic_vector(7 downto 0);
	signal byte_4          : std_logic_vector(7 downto 0);
	signal byte_5          : std_logic_vector(7 downto 0);
	signal byte_6          : std_logic_vector(7 downto 0);
	signal byte_7          : std_logic_vector(7 downto 0);
	signal rxd_fil         : std_logic;

begin
	-- component instantiations statements

	A0 : reset_gen_n
		port map(
			clk   => clk,
			reset => reset
		);

	A1 : clk_divider_n
		port map(
			clk        => clk,
			sync_2ms   => sync_2ms,
			sync_20ms  => open,
			en_16xbaud => en_16xbaud
		);

	A2 : lcd_controller_n
		port map(
			clk      => clk,
			reset    => reset,
			data     => data,
			addr     => addr,
			data_en  => data_en,
			rdy      => rdy,
			lcd_en   => lcd_en,
			lcd_rs   => lcd_rs,
			lcd_rw   => lcd_rw,
			lcd_data => lcd_data
		);

	A3 : display_controller_n
		port map(
			clk     => clk,
			reset   => reset,
			val_0   => val_0,
			val_1   => val_1,
			data    => data,
			addr    => addr,
			data_en => data_en,
			nxt     => rdy
		);

	A4 : rotary_decoder_n
		port map(
			rotary_a     => rotary_a,
			rotary_b     => rotary_b,
			clk          => clk,
			rotary_event => rotary_event,
			rotary_left  => rotary_left
		);

	A5 : controller
		port map(
			clk         => clk,
			reset       => reset,
			start       => start,
			en_16xbaud  => en_16xbaud,
			serial_in   => serial_in_1,
			home_en     => home_enable,
			kp          => kp,
			home_sensor => home_sensor_1_f,
			set_pos     => set_pos_1,
			drv_mode    => drv_mode_1,
			drv_man     => drv_man_1,
			position    => position_1,
			serial_out  => serial_out_1
		);

	A6 : controller
		port map(
			clk         => clk,
			reset       => reset,
			start       => start,
			en_16xbaud  => en_16xbaud,
			serial_in   => serial_in_2,
			home_en     => home_enable,
			kp          => kp,
			home_sensor => home_sensor_2_f,
			set_pos     => set_pos_2,
			drv_mode    => drv_mode_2,
			drv_man     => drv_man_2,
			position    => position_2,
			serial_out  => serial_out_2
		);

	A7 : controller
		port map(
			clk         => clk,
			reset       => reset,
			start       => start,
			en_16xbaud  => en_16xbaud,
			serial_in   => serial_in_3,
			home_en     => home_enable,
			kp          => kp,
			home_sensor => home_sensor_3_f,
			set_pos     => set_pos_3,
			drv_mode    => drv_mode_3,
			drv_man     => drv_man_3,
			position    => position_3,
			serial_out  => serial_out_3
		);

	A8 : controller
		port map(
			clk         => clk,
			reset       => reset,
			start       => start,
			en_16xbaud  => en_16xbaud,
			serial_in   => serial_in_4,
			home_en     => home_enable,
			kp          => kp,
			home_sensor => home_sensor_4_f,
			set_pos     => set_pos_4,
			drv_mode    => drv_mode_4,
			drv_man     => drv_man_4,
			position    => position_4,
			serial_out  => serial_out_4
		);

	A9 : controller
		port map(
			clk         => clk,
			reset       => reset,
			start       => start,
			en_16xbaud  => en_16xbaud,
			serial_in   => serial_in_5,
			home_en     => home_enable,
			kp          => kp,
			home_sensor => home_sensor_5_f,
			set_pos     => set_pos_5,
			drv_mode    => drv_mode_5,
			drv_man     => drv_man_5,
			position    => position_5,
			serial_out  => serial_out_5
		);

	A10 : controller
		port map(
			clk         => clk,
			reset       => reset,
			start       => start,
			en_16xbaud  => en_16xbaud,
			serial_in   => serial_in_6,
			home_en     => home_enable,
			kp          => kp,
			home_sensor => home_sensor_6_f,
			set_pos     => set_pos_6,
			drv_mode    => drv_mode_6,
			drv_man     => drv_man_6,
			position    => position_6,
			serial_out  => serial_out_6
		);

	A11 : component control
		port map(
			clk          => clk,
			reset        => reset,
			sync_2ms     => sync_2ms,
			rotary_event => rotary_event,
			rotary_left  => rotary_left,
			press        => press,
			btn_north    => btn_north_f,
			btn_west     => btn_west_f,
			btn_east     => btn_east_f,
			btn_south    => btn_south_f,
			sw0          => sw0_f,
			sw1          => sw1_f,
			sw2          => sw2_f,
			sw3          => sw3_f,
			start        => start,
			home_enable  => home_enable,
			kp           => kp,
			set_pos_1    => set_pos_1,
			set_pos_2    => set_pos_2,
			set_pos_3    => set_pos_3,
			set_pos_4    => set_pos_4,
			set_pos_5    => set_pos_5,
			set_pos_6    => set_pos_6,
			drv_mode_1   => drv_mode_1,
			drv_mode_2   => drv_mode_2,
			drv_mode_3   => drv_mode_3,
			drv_mode_4   => drv_mode_4,
			drv_mode_5   => drv_mode_5,
			drv_mode_6   => drv_mode_6,
			drv_man_1    => drv_man_1,
			drv_man_2    => drv_man_2,
			drv_man_3    => drv_man_3,
			drv_man_4    => drv_man_4,
			drv_man_5    => drv_man_5,
			drv_man_6    => drv_man_6,
			led          => led,
			val_1        => val_1,
			ext_setpos_1 => byte_2,
			ext_setpos_2 => byte_3,
			ext_setpos_3 => byte_4,
			ext_setpos_4 => byte_5,
			ext_setpos_5 => byte_6,
			ext_setpos_6 => byte_7
		);

	A12 : digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => rotary_press,
			     o     => press
		);

	A13 : digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => btn_west,
			     o     => btn_west_f
		);

	A14 : digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => btn_east,
			     o     => btn_east_f
		);

	A15 : digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => btn_south,
			     o     => btn_south_f
		);

	A16 : digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => btn_north,
			     o     => btn_north_f
		);

	A17 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => sw0,
			     o     => sw0_f
		);

	A18 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => sw1,
			     o     => sw1_f
		);

	A19 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => sw2,
			     o     => sw2_f
		);

	A20 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => sw3,
			     o     => sw3_f
		);

	A21 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => home_sensor_1,
			     o     => home_sensor_1_f
		);

	A22 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => home_sensor_2,
			     o     => home_sensor_2_f
		);

	A23 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => home_sensor_3,
			     o     => home_sensor_3_f
		);

	A24 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => home_sensor_4,
			     o     => home_sensor_4_f
		);

	A25 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => home_sensor_5,
			     o     => home_sensor_5_f
		);

	A26 : digital_filter
		port map(clk   => clk,
			     reset => reset,
			     i     => home_sensor_6,
			     o     => home_sensor_6_f
		);

	A27 : component digital_filter
		port map(
			clk   => clk,
			reset => reset,
			i     => not run_switch,
			o     => motor_stop
		);

	A28 : component serial_rx
		port map(
			clk           => clk,
			reset         => reset,
			rx            => rxd_fil,
			rx_data       => rx_data,
			rx_data_valid => rx_data_valid
		);

	A29 : component serial_rx_dec_n
		port map(
			clk           => clk,
			reset         => reset,
			rx_data       => rx_data,
			rx_data_valid => rx_data_valid,
			byte_1        => open,
			byte_2        => byte_2,
			byte_3        => byte_3,
			byte_4        => byte_4,
			byte_5        => byte_5,
			byte_6        => byte_6,
			byte_7        => byte_7,
			com_error     => open
		);

	A30 : component filter
		port map(
			clk   => clk,
			reset => reset,
			i     => rxd,
			o     => rxd_fil
		);

	-- additional statements  
	val_0 <= kp & "0000" & position_1 & position_2 & "0000" & position_3 & position_4 & "0000" & position_5 & position_6; --LCD line1 1.6mm
	txd   <= '1';

	--StrataFLASH must be disabled to prevent it conflicting with the LCD display 
	strataflash_oe <= '1';
	strataflash_ce <= '1';
	strataflash_we <= '1';

end;
