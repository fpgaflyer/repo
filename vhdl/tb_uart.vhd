entity tb_uart is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture rtl of tb_uart is
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
	end component;

	component uart_tx
		port(data_in          : in  std_logic_vector(7 downto 0);
			 write_buffer     : in  std_logic;
			 reset_buffer     : in  std_logic;
			 en_16_x_baud     : in  std_logic;
			 serial_out       : out std_logic;
			 buffer_full      : out std_logic;
			 buffer_half_full : out std_logic;
			 clk              : in  std_logic);
	end component;

	signal CLK      : std_logic := '1';
	signal RESET    : std_logic;
	signal serial   : std_logic;
	signal data_out : std_logic_vector(7 downto 0);
	signal data_in  : std_logic_vector(7 downto 0);

begin
	CLK     <= NOT CLK after 10 ns;
	RESET   <= '1', '0' after 100 ns;
	DATA_IN <= "10011001";

	A1 : uart_rx port map(
			serial_in           => serial,
			data_out            => data_out,
			read_buffer         => '1',
			reset_buffer        => reset,
			en_16_x_baud        => '1',
			buffer_data_present => open,
			buffer_full         => open,
			buffer_half_full    => open,
			clk                 => clk
		);

	A2 : uart_tx port map(
			data_in          => data_in,
			write_buffer     => '1',
			reset_buffer     => reset,
			en_16_x_baud     => '1',
			serial_out       => serial,
			buffer_full      => open,
			buffer_half_full => open,
			clk              => clk
		);

end;
