library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library gen;
use gen.std.all;

entity controller is
	port(clk         : in  std_logic;
		 reset       : in  std_logic;
		 start       : in  std_logic;
		 en_16xbaud  : in  std_logic;
		 serial_in   : in  std_logic;
		 home_en     : in  std_logic;
		 kp          : in  std_logic_vector(3 downto 0);
		 home_sensor : in  std_logic;
		 set_pos     : in  std_logic_vector(7 downto 0); -- 1.6mm 0-41cm
		 drv_mode    : in  std_logic_vector(1 downto 0);
		 drv_man     : in  std_logic_vector(10 downto 0);
		 position    : out std_logic_vector(7 downto 0); -- 1.6mm 0-41cm
		 serial_out  : out std_logic
	);
end;

architecture structure of controller is

	-- component declarations
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
			 pos                 : out std_logic_vector(14 downto 0));
	end component readpos;

	component home_position
		port(clk         : in  std_logic;
			 reset       : in  std_logic;
			 home_enable : in  std_logic;
			 home_sensor : in  std_logic;
			 pos_in      : in  std_logic_vector(14 downto 0);
			 pos_out     : out std_logic_vector(14 downto 0));
	end component home_position;

	component p_controller_n
		port(clk    : in  std_logic;
			 reset  : in  std_logic;
			 kp     : in  std_logic_vector(3 downto 0);
			 setpos : in  std_logic_vector(7 downto 0);
			 pos    : in  std_logic_vector(13 downto 0);
			 limit  : in  std_logic_vector(9 downto 0);
			 drive  : out std_logic_vector(10 downto 0));
	end component p_controller_n;

	component drv_mux
		port(drv_in   : in  std_logic_vector(10 downto 0);
			 drv_man  : in  std_logic_vector(10 downto 0);
			 drv_mode : in  std_logic_vector(1 downto 0);
			 drv_out  : out std_logic_vector(10 downto 0));
	end component drv_mux;

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

	-- declaration of signals used to interconnect 
	signal data_out            : std_logic_vector(7 downto 0);
	signal read_buffer         : std_logic;
	signal buffer_data_present : std_logic;
	signal pos                 : std_logic_vector(14 downto 0);
	signal do                  : int(7 downto 0);
	signal dvalid              : bool;
	signal pos_out             : std_logic_vector(14 downto 0);
	signal drv_in              : std_logic_vector(10 downto 0);
	signal drv_out             : std_logic_vector(10 downto 0);
	signal limit               : std_logic_vector(9 downto 0);

begin

	-- component instantiations statements
	A0 : uart_rx
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

	A1 : readpos
		port map(clk                 => clk,
			     reset               => reset,
			     din                 => data_out,
			     read_buffer         => read_buffer,
			     buffer_data_present => buffer_data_present,
			     pos                 => pos
		);

	A2 : home_position
		port map(
			clk         => clk,
			reset       => reset,
			home_enable => home_en,
			home_sensor => home_sensor,
			pos_in      => pos,         --25um 0-82cm
			pos_out     => pos_out      --25um 0-82cm
		);

	A33 : p_controller_n
		port map(
			clk    => clk,
			reset  => reset,
			kp     => kp,
			setpos => set_pos,          --1.6mm 0-41cm  
			pos    => pos_out(13 downto 0), --25um 0-41cm
			limit  => limit,
			drive  => drv_in
		);

	A4 : drv_mux
		port map(
			drv_in   => drv_in,
			drv_man  => drv_man,
			drv_mode => drv_mode,
			drv_out  => drv_out
		);

	A5 : conv
		port map(clk    => clk,
			     rst    => reset,
			     di     => drv_out,
			     start  => start,
			     do     => do,
			     dvalid => dvalid
		);

	A6 : uart_tx
		port map(data_in          => do,
			     write_buffer     => dvalid,
			     reset_buffer     => reset,
			     en_16_x_baud     => en_16xbaud,
			     serial_out       => serial_out,
			     buffer_full      => open,
			     buffer_half_full => open,
			     clk              => clk
		);

	-- additional statements  
	position <= pos_out(13 downto 6);   --1.6mm 0-41cm <= 25um x 64
	limit    <= "1111101000"; --1000

end;
