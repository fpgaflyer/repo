-- runtime 200us
entity tb_conv is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library gen;
use gen.std.all;

architecture rtl of tb_conv is
	component conv
		port(clk    : in  bool;
			 rst    : in  bool;
			 di     : in  int(10 downto 0);
			 start  : in  bool;
			 rtc    : in  int(1 downto 0);
			 do     : out int(7 downto 0);
			 dvalid : out bool);
	end component conv;

	signal CLK    : bool := '1';
	signal RESET  : bool;
	signal START  : bool;
	signal DI     : int(10 downto 0);
	signal DO     : int(7 downto 0);
	signal DVALID : bool;
	signal RTC    : int(1 downto 0);

begin
	CLK   <= NOT CLK after 10 ns;
	RESET <= '1', '0' after 100 ns;
	START <= '0', '1' after 100000 ns, '0' after 100020 ns;
	DI    <= "00010000000";
	RTC   <= "11";

	A1 : conv port map(
			clk    => CLK,
			rst    => RESET,
			di     => DI,
			start  => START,
			rtc    => RTC,
			do     => DO,
			dvalid => DVALID
		);

end;
