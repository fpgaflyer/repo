-- runtime =  200us

entity tb_interpol is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture rtl of tb_interpol is
	component clk_divider_n
		port(clk        : in  std_logic;
			 sync_2ms   : out std_logic;
			 sync_20ms  : out std_logic;
			 en_16xbaud : out std_logic);
	end component clk_divider_n;

	component interpol
		port(clk      : in  std_logic;
			 reset    : in  std_logic;
			 sync_2ms : in  std_logic;
			 din      : in  std_logic_vector(7 downto 0);
			 dvalid   : in  std_logic;
			 dout     : out std_logic_vector(7 downto 0));
	end component interpol;

	signal CLK      : std_logic := '1';
	signal RESET    : std_logic;
	signal DIN      : std_logic_vector(7 downto 0);
	signal DVALID   : std_logic;
	signal sync_2ms : std_logic;
	signal dout     : std_logic_vector(7 downto 0);

begin
	CLK   <= NOT CLK after 10 ns;
	RESET <= '1', '0' after 100 ns;
	DIN   <= 		X"00",
					X"14" after 10 us,
					X"28" after 30 us,
					X"3c" after 50 us,	
					X"50" after 70 us,
					X"64" after 90 us,
					X"64" after 110 us,
					X"50" after 130 us,
					X"3c" after 150 us,	
					X"28" after 170 us,
					X"14" after 190 us;					
		
	
	DVALID <= '0', 	'1' after 5000 ns, '0' after 5020 ns,
					'1' after 10000 ns, '0' after 10020 ns,
					'1' after 30000 ns, '0' after 30020 ns,
					'1' after 50000 ns, '0' after 50020 ns,
					'1' after 70000 ns, '0' after 70020 ns,
					'1' after 90000 ns, '0' after 90020 ns,
					'1' after 110000 ns, '0' after 110020 ns,
					'1' after 130000 ns, '0' after 130020 ns,
					'1' after 150000 ns, '0' after 150020 ns,
					'1' after 170000 ns, '0' after 170020 ns,
					'1' after 190000 ns, '0' after 190020 ns;					
					
	A1 : component clk_divider_n
		port map(clk        => clk,
			     sync_2ms   => sync_2ms,
			     sync_20ms  => open,
			     en_16xbaud => open
		);

	A2 : component interpol
		port map(clk      => clk,
			     reset    => reset,
			     sync_2ms => sync_2ms,
			     din      => DIN,
			     dvalid   => DVALID,
			     dout     => dout);

end;
