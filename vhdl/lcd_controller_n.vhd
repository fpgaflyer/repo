library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lcd_controller_n is
	port(
		clk      : in  std_logic;
		reset    : in  std_logic;

		data     : in  std_logic_vector(7 downto 0); -- char
		addr     : in  std_logic_vector(6 downto 0); -- ddram addr
		data_en  : in  std_logic;
		rdy      : out std_logic;

		lcd_en   : out std_logic;
		lcd_rs   : out std_logic;
		lcd_rw   : out std_logic;
		lcd_data : out std_logic_vector(7 downto 4)
	);
end;

architecture behav of lcd_controller_n is
	signal cnt : std_logic_vector(20 downto 0);
	type t_sm is (init, hold, wr_data);
	signal sm         : t_sm;
	signal data_en_1d : std_logic;
	signal a          : std_logic_vector(6 downto 0); --address
	signal d          : std_logic_vector(7 downto 0); --data

begin
	process(clk, reset)
		variable lcd : std_logic_vector(6 downto 0);

	-- lcd  b6  b5  b4  b3  b2  b1  b0    
	--      en  rs  rw  d7  d6  d5  d4
	begin
		if (reset = '1') then
			cnt        <= (others => '0');
			lcd        := (others => '0');
			lcd_data   <= (others => '0');
			lcd_en     <= '0';
			lcd_rs     <= '0';
			lcd_rw     <= '0';
			sm         <= init;
			data_en_1d <= '0';
			rdy        <= '0';
			a          <= (others => '0');
			d          <= (others => '0');

		elsif (clk'event and clk = '1') then
			data_en_1d <= data_en;
			rdy        <= '0';

			case sm is
				WHEN init =>            -- initialization 
					cnt <= cnt + 1;
					case cnt is
						--                                                ESR7654 
						when "010110111000110110000" => lcd := "0000011"; --15.000.000ns 0x3
						when "010110111000110110101" => lcd := "1000011"; --15.000.100ns
						when "010110111000111001001" => lcd := "0000011"; --15.000.500ns

						when "011110100001001000000" => lcd := "0000011"; --20.000.000ns 0x3
						when "011110100001001000101" => lcd := "1000011"; --20.000.100ns
						when "011110100001001011001" => lcd := "0000011"; --20.000.500ns

						when "100000000010110010000" => lcd := "0000011"; --21.000.000ns 0x3
						when "100000000010110010101" => lcd := "1000011"; --21.000.100ns
						when "100000000010110101001" => lcd := "0000011"; --21.000.500ns

						when "100001100100011100000" => lcd := "0000010"; --22.000.000ns 0x2 
						when "100001100100011100101" => lcd := "1000010"; --22.000.100ns
						when "100001100100011111001" => lcd := "0000010"; --22.000.500ns

						when "100011000110000110000" => lcd := "0000010"; --23.000.000ns 0x2-  function set 4wire 
						when "100011000110000110101" => lcd := "1000010"; --23.000.100ns       2-line, 5x7 dots
						when "100011000110001001001" => lcd := "0000010"; --23.000.500ns

						when "100100100111110000000" => lcd := "0001000"; --24.000.000ns 0x-8 
						when "100100100111110000101" => lcd := "1001000"; --24.000.100ns
						when "100100100111110011001" => lcd := "0001000"; --24.000.500ns

						when "100110001001011010000" => lcd := "0000000"; --25.000.000ns 0x0-  entry mode set 
						when "100110001001011010101" => lcd := "1000000"; --25.000.100ns       incr-cursor, no shift 
						when "100110001001011101001" => lcd := "0000000"; --25.000.500ns

						when "100111101011000100000" => lcd := "0000110"; --26.000.000ns 0x-6 
						when "100111101011000100101" => lcd := "1000110"; --26.000.100ns
						when "100111101011000111001" => lcd := "0000110"; --26.000.500ns

						when "101001001100101110000" => lcd := "0000000"; --27.000.000ns 0x0-  display ctrl set
						when "101001001100101110101" => lcd := "1000000"; --27.000.100ns       display-on, cursor-off, blink-off
						when "101001001100110001001" => lcd := "0000000"; --27.000.500ns

						when "101010101110011000000" => lcd := "0001100"; --28.000.000ns 0x-c  
						when "101010101110011000101" => lcd := "1001100"; --28.000.100ns
						when "101010101110011011001" => lcd := "0001100"; --28.000.500ns

						when "101100010000000010000" => lcd := "0000000"; --29.000.000ns 0x0-  clear display
						when "101100010000000010101" => lcd := "1000000"; --29.000.100ns
						when "101100010000000101001" => lcd := "0000000"; --29.000.500ns

						when "101101110001101100000" => lcd := "0000001"; --30.000.000ns 0x-1 
						when "101101110001101100101" => lcd := "1000001"; --30.000.100ns
						when "101101110001101111001" => lcd := "0000001"; --30.000.500ns

						when "110000110101000000000" => sm <= hold; --32.000.000ns
							cnt <= (others => '0');

						when OTHERS => NULL;
					end case;

				WHEN hold =>
					lcd := "0000000";
					cnt <= (others => '0');
					rdy <= '1';
					if (data_en = '1' and data_en_1d = '0') then -- rising edge
						sm <= wr_data;
						a  <= addr;
						d  <= data;
					end if;

				WHEN wr_data =>
					cnt <= cnt + 1;
					case cnt is
						--                                      ESR7    
						when "000000000000000000000" => lcd := "0001" & a(6 downto 4); --000.000ns  addr upper nibble
						when "000000000000000000101" => lcd := "1001" & a(6 downto 4); --000.100ns
						when "000000000000000011001" => lcd := "0001" & a(6 downto 4); --000.500ns

						when "000000001001110001000" => lcd := "000" & a(3 downto 0); --100.000ns  addr lower nibble
						when "000000001001110001101" => lcd := "100" & a(3 downto 0); --100.100ns
						when "000000001001110100001" => lcd := "000" & a(3 downto 0); --100.500ns

						when "000000010011100010000" => lcd := "010" & d(7 downto 4); --200.000ns  data upper nibble
						when "000000010011100010101" => lcd := "110" & d(7 downto 4); --200.100ns
						when "000000010011100101001" => lcd := "010" & d(7 downto 4); --200.500ns

						when "000000011101010011000" => lcd := "010" & d(3 downto 0); --300.000ns  data lower nibble
						when "000000011101010011101" => lcd := "110" & d(3 downto 0); --300.100ns
						when "000000011101010110001" => lcd := "010" & d(3 downto 0); --300.500ns

						when "000000100111000100000" => sm <= hold; --400.000ns

						when OTHERS => NULL;
					end case;

				WHEN OTHERS => NULL;

			end case;

			lcd_data <= lcd(3 downto 0);
			lcd_rw   <= lcd(4);
			lcd_rs   <= lcd(5);
			lcd_en   <= lcd(6);

		end if;
	end process;

end; 
