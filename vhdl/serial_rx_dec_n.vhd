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

		byte_1        : out std_logic_vector(7 downto 0); -- reserved
		byte_2        : out std_logic_vector(7 downto 0); -- act1
		byte_3        : out std_logic_vector(7 downto 0); -- act2
		byte_4        : out std_logic_vector(7 downto 0); -- act3
		byte_5        : out std_logic_vector(7 downto 0); -- act4
		byte_6        : out std_logic_vector(7 downto 0); -- act5
		byte_7        : out std_logic_vector(7 downto 0); -- act6
		com_error     : out std_logic
	);
end;

architecture behav of serial_rx_dec_n is
	type t_sm is (wait4a, wait4b, byte1, byte2, byte3, byte4, byte5, byte6, byte7, wait4cr);
	signal sm                         : t_sm;
	signal b1, b2, b3, b4, b5, b6, b7 : std_logic_vector(7 downto 0);

begin
	process
	begin
		wait until clk = '1';

		if reset = '1' then
			sm        <= wait4a;
			byte_1    <= (others => '0');
			byte_2    <= (others => '0');
			byte_3    <= (others => '0');
			byte_4    <= (others => '0');
			byte_5    <= (others => '0');
			byte_6    <= (others => '0');
			byte_7    <= (others => '0');
			b1        <= (others => '0');
			b2        <= (others => '0');
			b3        <= (others => '0');
			b4        <= (others => '0');
			b5        <= (others => '0');
			b6        <= (others => '0');
			b7        <= (others => '0');
			com_error <= '0';
		else
			com_error <= '0';

			if rx_data_valid = '1' then
				case sm is
					when wait4a =>
						if rx_data = x"41" then
							sm <= wait4b;
						end if;

					when wait4b =>
						if rx_data = x"42" then
							sm <= byte1;
						else
							com_error <= '1';
							sm        <= wait4a;
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
						sm <= wait4cr;

					when wait4cr =>
						if rx_data = x"0d" then --CR 
							byte_1 <= b1;
							byte_2 <= b2;
							byte_3 <= b3;
							byte_4 <= b4;
							byte_5 <= b5;
							byte_6 <= b6;
							byte_7 <= b7;
						else
							com_error <= '1';
						end if;
						sm <= wait4a;

					when others => sm <= wait4a;
				end case;
			end if;
		end if;
	end process;
end;
