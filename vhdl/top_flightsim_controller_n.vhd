library IEEE;                --
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
		 btn_west       : in  std_logic;
		 btn_east       : in  std_logic;
--		 sw0            : in  std_logic;
		 serial_out     : out std_logic;
		 serial_in      : in  std_logic
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
			 val_0   : in  std_logic_vector(31 downto 0);
			 val_1   : in  std_logic_vector(31 downto 0);
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

	component counter
		port(clk   : in  std_logic;
			 reset : in  std_logic;
			 step  : in  std_logic;
			 dir   : in  std_logic;
			 val   : out std_logic_vector(7 downto 0));
	end component counter;

	component conv
		port(clk    : in  bool;
			 rst    : in  bool;
			 di     : in  int(10 downto 0);
			 start  : in  bool;
			 do     : out int(7 downto 0);
			 dvalid : out bool);
	end component conv;

	component uart_tx
		port(data_in          : in  std_logic_vector(7 downto 0);
			 write_buffer     : in  std_logic;
			 reset_buffer     : in  std_logic;
			 en_16_x_baud     : in  std_logic;
			 serial_out       : out std_logic;
			 buffer_full      : out std_logic;
			 buffer_half_full : out std_logic;
			 clk              : in  std_logic);
	end component uart_tx;

	component uart_rx
		port(serial_in           : in  std_logic;
			 data_out            : out std_logic_vector(7 downto 0);
			 read_buffer         : in  std_logic;
			 reset_buffer        : in  std_logic;
			 en_16_x_baud        : in  std_logic;
			 buffer_data_present : out std_logic;
			 buffer_full         : out std_logic;
			 buffer_half_full    : out std_logic;
			 clk                 : in  std_logic);
	end component uart_rx;

	component readpos
		port(clk                 : in  std_logic;
			 reset               : in  std_logic;
			 din                 : in  std_logic_vector(7 downto 0);
			 read_buffer         : out std_logic;
			 buffer_data_present : in  std_logic;
			 pos                 : out std_logic_vector(31 downto 0));
	end component readpos;

	component control
		port(clk       : in  std_logic;
			 press     : in  std_logic;
			 btn_west  : in  std_logic;
			 btn_east  : in  std_logic;
	--		 sw0       : in  std_logic;
			 kp        : out std_logic_vector(3 downto 0);
			 val_in    : in  std_logic_vector(7 downto 0);
			 val_out   : out std_logic_vector(7 downto 0);
			 sync_20ms : in  std_logic);
--			 rom_addr  : out std_logic_vector(10 downto 0);
--			 rom_data  : in  std_logic_vector(7 downto 0));
	end component control;

	component digital_filter
		port(clk   : in  std_logic;
			 reset : in  std_logic;
			 i     : in  std_logic;
			 o     : out std_logic);
	end component digital_filter;

	component p_controller_n
		port(clk    : in  std_logic;
			 reset  : in  std_logic;
			 kp     : in  std_logic_vector(3 downto 0);
			 setpos : in  std_logic_vector(7 downto 0);
			 pos    : in  std_logic_vector(13 downto 0);
			 drive  : out std_logic_vector(10 downto 0));
	end component p_controller_n;

--	component rom_2048x8
--		port(
--			clka  : in  std_logic;
--			addra : in  std_logic_vector(10 downto 0);
--			douta : out std_logic_vector(7 downto 0)
--		);
--	end component rom_2048x8;

	-- declaration of signals used to interconnect 

	signal reset               : std_logic;
	signal data                : std_logic_vector(7 downto 0);
	signal addr                : std_logic_vector(6 downto 0);
	signal data_en             : std_logic;
	signal rdy                 : std_logic;
	signal rotary_event        : std_logic;
	signal rotary_left         : std_logic;
	signal en_16xbaud          : std_logic;
	signal do                  : int(7 downto 0);
	signal dvalid              : bool;
	signal value               : std_logic_vector(31 downto 0);
	signal data_out            : std_logic_vector(7 downto 0);
	signal read_buffer         : std_logic;
	signal buffer_data_present : std_logic;
	signal pos                 : std_logic_vector(31 downto 0);
	signal sync_2ms            : std_logic;
	signal btn_west_f          : std_logic;
	signal btn_east_f          : std_logic;
	signal press               : std_logic;
	signal kp                  : std_logic_vector(3 downto 0);
	signal setpos              : std_logic_vector(7 downto 0);
	signal setpositie          : std_logic_vector(7 downto 0);
	signal drive               : std_logic_vector(10 downto 0);
	signal positie             : std_logic_vector(31 downto 0);
	signal sync_20ms           : std_logic;
--	signal sw0_f               : std_logic;
	signal rom_addr            : std_logic_vector(10 downto 0);
	signal rom_data            : std_logic_vector(7 downto 0);

begin

	-- component instantiations statements

	A0 : reset_gen_n
		port map(
			clk   => clk,
			reset => reset
		);

	A1 : component clk_divider_n
		port map(
			clk        => clk,
			sync_2ms   => sync_2ms,
			sync_20ms  => sync_20ms,
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
			val_0   => value,
			val_1   => positie,
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

	A5 : counter
		port map(clk   => clk,
			     reset => reset,
			     step  => rotary_event,
			     dir   => rotary_left,
			     val   => setpos
		);

	A6 : component conv
		port map(clk    => clk,
			     rst    => reset,
			     di     => drive,
			     start  => sync_2ms,
			     do     => do,
			     dvalid => dvalid
		);

	A7 : component uart_tx
		port map(data_in          => do,
			     write_buffer     => dvalid,
			     reset_buffer     => reset,
			     en_16_x_baud     => en_16xbaud,
			     serial_out       => serial_out,
			     buffer_full      => open,
			     buffer_half_full => open,
			     clk              => clk
		);

	A8 : component uart_rx
		port map(serial_in           => serial_in,
			     data_out            => data_out,
			     read_buffer         => read_buffer,
			     reset_buffer        => reset,
			     en_16_x_baud        => en_16xbaud,
			     buffer_data_present => buffer_data_present,
			     buffer_full         => open,
			     buffer_half_full    => open,
			     clk                 => clk
		);

	A9 : component readpos
		port map(clk                 => clk,
			     reset               => reset,
			     din                 => data_out,
			     read_buffer         => read_buffer,
			     buffer_data_present => buffer_data_present,
			     pos                 => pos
		);

	A10 : component digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => rotary_press,
			     o     => press
		);

	A11 : component digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => btn_west,
			     o     => btn_west_f
		);

	A12 : component digital_filter
		port map(clk   => sync_2ms,
			     reset => reset,
			     i     => btn_east,
			     o     => btn_east_f
		);

--	A13 : component digital_filter
--		port map(clk   => sync_2ms,
--			     reset => reset,
--			     i     => sw0,
--			     o     => sw0_f
--		);

	A14 : component control
		port map(clk       => clk,
			     press     => press,
			     btn_west  => btn_west_f,
			     btn_east  => btn_east_f,
	--		     sw0       => sw0_f,
			     kp        => kp,
			     val_in    => setpos,
			     val_out   => setpositie,
			     sync_20ms => sync_20ms
--			     rom_addr  => rom_addr,
--			     rom_data  => rom_data
		);

	A15 : component p_controller_n
		port map(clk    => clk,
			     reset  => reset,
			     kp     => kp,
			     setpos => setpositie,
			     pos    => pos(13 downto 0),
			     drive  => drive
		);

--	A16 : component rom_2048x8
--		port map(clka  => clk,
--			     addra => rom_addr,
--			     douta => rom_data
--		);

	-- additional statements  

	value   <= kp & "00000" & drive & "0000" & setpos;
	positie <= "000000000000000000000000" & pos(13 downto 6);

	--StrataFLASH must be disabled to prevent it conflicting with the LCD display 
	strataflash_oe <= '1';
	strataflash_ce <= '1';
	strataflash_we <= '1';

end;
