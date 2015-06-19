-- runtime = 200us   

entity tb_readpos is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture rtl of tb_readpos is
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

	signal CLK                 : std_logic := '1';
	signal RESET               : std_logic;
	signal serial              : std_logic;
	signal DATA_IN             : std_logic_vector(7 downto 0);
	signal WRITE_BUFFER        : std_logic;
	signal data                : std_logic_vector(7 downto 0);
	signal read_buffer         : std_logic;
	signal buffer_data_present : std_logic;
	signal buffer_full         : std_logic;
	signal buffer_half_full    : std_logic;
	signal pos                 : std_logic_vector(31 downto 0);

begin
	CLK          <= NOT CLK after 10 ns;
	RESET        <= '1', '0' after 100 ns;
	DATA_IN      <= X"78",
					X"30" after 5000 ns,
					X"78" after 15000 ns,					
					X"32" after 25000 ns,
					X"2b" after 35000 ns,					
					X"34" after 45000 ns,
					X"35" after 55000 ns,					
					X"36" after 65000 ns,
					X"37" after 75000 ns,
											
					X"78" after 85000 ns,
					X"41" after 95000 ns,
					X"42" after 105000 ns,					
					X"43" after 115000 ns,
					X"44" after 125000 ns,					
					X"45" after 135000 ns,
					X"46" after 145000 ns,					
					X"38" after 155000 ns,
					X"39" after 165000 ns;
												
	WRITE_BUFFER <= '0', '1' after 2000 ns, '0' after 2020 ns,
						 '1' after 10000 ns, '0' after 10020 ns,
						 '1' after 20000 ns, '0' after 20020 ns,
						 '1' after 30000 ns, '0' after 30020 ns,
						 '1' after 40000 ns, '0' after 40020 ns,
					 	 '1' after 50000 ns, '0' after 50020 ns,
						 '1' after 60000 ns, '0' after 60020 ns,
						 '1' after 70000 ns, '0' after 70020 ns,
						 '1' after 80000 ns, '0' after 80020 ns,						 
					 	 '1' after 90000 ns, '0' after 90020 ns,
						 '1' after 100000 ns, '0' after 100020 ns,
						 '1' after 110000 ns, '0' after 110020 ns,
						 '1' after 120000 ns, '0' after 120020 ns,
					 	 '1' after 130000 ns, '0' after 130020 ns,
						 '1' after 140000 ns, '0' after 140020 ns,
						 '1' after 150000 ns, '0' after 150020 ns,
						 '1' after 160000 ns, '0' after 160020 ns,	
						 '1' after 170000 ns, '0' after 170020 ns;						 			 						 
	A1 : uart_tx port map(
			data_in          => DATA_IN,
			write_buffer     => WRITE_BUFFER,
			reset_buffer     => reset,
			en_16_x_baud     => '1',
			serial_out       => serial,
			buffer_full      => open,
			buffer_half_full => open,
			clk              => CLK
		);

	A2 : uart_rx port map(
			serial_in           => serial,
			data_out            => data,
			read_buffer         => read_buffer,
			reset_buffer        => reset,
			en_16_x_baud        => '1',
			buffer_data_present => buffer_data_present,
			buffer_full         => buffer_full,
			buffer_half_full    => buffer_half_full,
			clk                 => clk
		);
	
	A3 : readpos port map(
			clk                 => CLK,
			reset               => reset,
			din                 => data,
			read_buffer         => read_buffer,
			buffer_data_present => buffer_data_present,
			pos                 => pos
		);

end;
