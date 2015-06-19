library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library gen;
use gen.std.all;

entity readpos is
	port(
		clk                 : in  std_logic;
		reset               : in  std_logic;
		din                 : in  std_logic_vector(7 downto 0);
		read_buffer         : out std_logic;
		buffer_data_present : in  std_logic;
		pos                 : out std_logic_vector(31 downto 0) --25um 
	);
end;

architecture behav of readpos is
	type t_sm is (wait4data, wait4start, wait4bytes, readbytes, writepos);
	signal sm : t_sm;
	signal n  : integer range 0 to 7;
	type t_d is array (integer range 0 to 7) of std_logic_vector(3 downto 0);
	signal d : t_d;

begin
	process
		variable di : std_logic_vector(4 downto 0);
	begin
		wait until clk = '1';

		if reset = '1' then
			sm          <= wait4data;
			n           <= 0;
			read_buffer <= '0';
			pos         <= (others => '0');

		else
			read_buffer <= '0';

			case sm is
				when wait4data =>
					if buffer_data_present = '1' then
						read_buffer <= '1';
						sm          <= wait4start;
					end if;

				when wait4start =>
					if din = X"78" then -- char "x"
						n     <= 0;
						di(4) := '0';   --reset error flag  
						sm    <= wait4bytes;
					else
						sm <= wait4data;
					end if;

				when wait4bytes =>
					if buffer_data_present = '1' then
						read_buffer <= '1';
						sm          <= readbytes;
					end if;

				when readbytes =>
					sm <= wait4bytes;
					if n = 7 then
						sm <= writepos;
					else
						n <= n + 1;
					end if;
					di   := ascii2hex(din);
					d(n) <= di(3 downto 0);
					if di(4) = '1' then
						sm <= wait4data; -- data error 
					end if;

				when writepos =>
					pos <= d(0) & d(1) & d(2) & d(3) & d(4) & d(5) & d(6) & d(7);
					sm  <= wait4data;

				when others => null;
			end case;
		end if;
	end process;
end;
