library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity serial_rx_dec_n is
	port(
		clk           : in  std_logic;
		reset         : in  std_logic;
		rx_data       : in  std_logic_vector(7 downto 0);
		rx_data_valid : in  std_logic;

		rx_1          : out std_logic_vector(7 downto 0); -- reserved
		rx_2          : out std_logic_vector(15 downto 0); -- act1
		rx_3          : out std_logic_vector(15 downto 0); -- act2
		rx_4          : out std_logic_vector(15 downto 0); -- act3
		rx_5          : out std_logic_vector(15 downto 0); -- act4
		rx_6          : out std_logic_vector(15 downto 0); -- act5
		rx_7          : out std_logic_vector(15 downto 0); -- act6
		com_error     : out std_logic
	);
end;

architecture behav of serial_rx_dec_n is
	type t_sm is (wait4b, wait4c, byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8, byte9, byte10, byte11, byte12, byte13, wait4cr);
	signal sm                                                     : t_sm;
	signal b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13 : std_logic_vector(7 downto 0);

begin
	process
	begin
		wait until clk = '1';

		if reset = '1' then
			sm        <= wait4b;
			rx_1      <= (others => '0');
			rx_2      <= (others => '0');
			rx_3      <= (others => '0');
			rx_4      <= (others => '0');
			rx_5      <= (others => '0');
			rx_6      <= (others => '0');
			rx_7      <= (others => '0');
			b1        <= (others => '0');
			b2        <= (others => '0');
			b3        <= (others => '0');
			b4        <= (others => '0');
			b5        <= (others => '0');
			b6        <= (others => '0');
			b7        <= (others => '0');
			b8        <= (others => '0');
			b9        <= (others => '0');
			b10       <= (others => '0');
			b11       <= (others => '0');
			b12       <= (others => '0');
			b13       <= (others => '0');
			com_error <= '0';
		else
			com_error <= '0';

			if rx_data_valid = '1' then
				case sm is
					when wait4b =>
						if rx_data = x"42" then
							sm <= wait4c;
						end if;

					when wait4c =>
						if rx_data = x"43" then
							sm <= byte1;
						else
							com_error <= '1';
							sm        <= wait4b;
						end if;

					when byte1 =>
						b1 <= rx_data;
						sm <= byte2;

					when byte2 =>
						b2 <= rx_data;
						sm <= byte3;

					when byte3 =>
						b3 <= rx_data;
						sm <= byte4;

					when byte4 =>
						b4 <= rx_data;
						sm <= byte5;

					when byte5 =>
						b5 <= rx_data;
						sm <= byte6;

					when byte6 =>
						b6 <= rx_data;
						sm <= byte7;

					when byte7 =>
						b7 <= rx_data;
						sm <= byte8;

					when byte8 =>
						b8 <= rx_data;
						sm <= byte9;

					when byte9 =>
						b9 <= rx_data;
						sm <= byte10;

					when byte10 =>
						b10 <= rx_data;
						sm  <= byte11;

					when byte11 =>
						b11 <= rx_data;
						sm  <= byte12;

					when byte12 =>
						b12 <= rx_data;
						sm  <= byte13;

					when byte13 =>
						b13 <= rx_data;
						sm  <= wait4cr;

					when wait4cr =>
						if rx_data = x"0d" then --CR 
							rx_1 <= b1;
							rx_2 <= b2 & b8;
							rx_3 <= b3 & b9;
							rx_4 <= b4 & b10;
							rx_5 <= b5 & b11;
							rx_6 <= b6 & b12;
							rx_7 <= b7 & b13;
						else
							com_error <= '1';
						end if;
						sm <= wait4b;

					when others => sm <= wait4b;
				end case;
			end if;
		end if;
	end process;
end;
