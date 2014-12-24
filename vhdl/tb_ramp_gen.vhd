entity tb_ramp_gen is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture rtl of tb_ramp_gen is
	component ramp_gen
		port(clk       : in  std_logic;
			 start     : in  std_logic;
			 sync_20ms : in  std_logic;
			 dout      : out std_logic_vector(7 downto 0));
	end component ramp_gen;

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

	signal CLK       : std_logic := '1';
	signal START     : std_logic;
	signal sync_20ms : std_logic;
	signal dout      : std_logic_vector(7 downto 0);
	signal RESET     : std_logic;
	signal sync_2ms  : std_logic;
	signal result    : std_logic_vector(7 downto 0);

begin
	CLK   <= NOT CLK after 10 ns;
	RESET <= '1', '0' after 100 ns;
	START <= '0', '1' after 100000 ns, '0' after 100020 ns;

	A1 : ramp_gen
		port map(clk       => CLK,
			     start     => START,
			     sync_20ms => sync_20ms,
			     dout      => dout
		);

	A2 : component clk_divider_n
		port map(clk        => CLK,
			     sync_2ms   => sync_2ms,
			     sync_20ms  => sync_20ms,
			     en_16xbaud => open
		);

	A3 : component interpol
		port map(clk      => clk,
			     reset    => reset,
			     sync_2ms => sync_2ms,
			     din      => dout,
			     dvalid   => sync_20ms,
			     dout     => result
		);

end;
