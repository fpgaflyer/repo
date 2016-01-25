-- runtime 400us
entity tb_conv is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library gen;
use gen.std.all;

architecture rtl of tb_conv is
	component conv
		port(clk          : in  bool;
			 rst          : in  bool;
			 di           : in  int(10 downto 0);
			 start        : in  bool;
			 rst_mot_ctrl : in  bool;
			 do           : out int(7 downto 0);
			 dvalid       : out bool);
	end component conv;

	signal CLK          : bool := '1';
	signal RESET        : bool;
	signal START        : bool;
	signal RST_MOT_CTRL : bool;
	signal DI           : int(10 downto 0);
	signal DO           : int(7 downto 0);
	signal DVALID       : bool;

begin
	CLK          <= not CLK after 10 ns;
	RESET        <= '1', '0' after 100 ns;
	RST_MOT_CTRL <= '0', '1' after 150000 ns, '0' after 250000 ns;
	START        <= '0', '1' after 100000 ns, '0' after 100020 ns, '1' after 200000 ns, '0' after 200020 ns, '1' after 300000 ns, '0' after 300020 ns;
	DI           <= "00010000000";

	A1 : component conv
		port map(
			clk          => CLK,
			rst          => RESET,
			di           => DI,
			start        => START,
			rst_mot_ctrl => RST_MOT_CTRL,
			do           => DO,
			dvalid       => DVALID
		);
end;
