-- runtime =  20ms with sync_2/20ms set to 2/20us in clk_divider_n.vhd (TEST)
--			  and ramp_gen.vhd stepsize set to 8 (TEST)	

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

	component reset_gen_n
		port(clk   : in  std_logic;
			 reset : out std_logic);
	end component reset_gen_n;

	component interpol
		port(clk      : in  std_logic;
			 reset    : in  std_logic;
			 sync_2ms : in  std_logic;
			 din      : in  std_logic_vector(7 downto 0);
			 dvalid   : in  std_logic;
			 dout     : out std_logic_vector(13 downto 0));
	end component interpol;

	component ramp_gen
		port(clk       : in  std_logic;
			 start     : in  std_logic;
			 sync_20ms : in  std_logic;
			 dout      : out std_logic_vector(7 downto 0));
	end component ramp_gen;

	signal CLK       : std_logic := '1';
	signal reset     : std_logic;
	signal sync_2ms  : std_logic;
	signal sync_20ms : std_logic;
	signal din       : std_logic_vector(7 downto 0);
	signal dout      : std_logic_vector(13 downto 0);

begin
	CLK <= NOT CLK after 10 ns;

	A1 : component clk_divider_n
		port map(clk        => clk,
			     sync_2ms   => sync_2ms,
			     sync_20ms  => sync_20ms,
			     en_16xbaud => open
		);

	A4 : entity work.reset_gen_n
		port map(clk   => clk,
			     reset => reset
		);

	A2 : component interpol
		port map(clk      => clk,
			     reset    => reset,
			     sync_2ms => sync_2ms,
			     din      => din,
			     dvalid   => sync_20ms,
			     dout     => dout
		);

	A3 : component ramp_gen
		port map(clk       => clk,
			     start     => '0',
			     sync_20ms => sync_20ms,
			     dout      => din
		);

end;
