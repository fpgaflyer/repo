library IEEE; --
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_divider_n is
	port(
		clk        : in  std_logic;     -- input clk 50 MHz = 20ns
		sync_2ms   : out std_logic;
		sync_20ms  : out std_logic;
		en_16xbaud : out std_logic      -- pulse for uart  

	);
end;

architecture behav of clk_divider_n is
	signal cnt_2ms  : std_logic_vector(16 downto 0) := (others => '0');
	signal cnt_20ms : std_logic_vector(19 downto 0) := (others => '0');
	signal baudcnt  : integer range 0 to 31         := 0;

begin
	process(clk)
	begin
		if rising_edge(clk) then        -- use work edge for good synthese, wait until does not work !!!!!

			if cnt_2ms = "11000011010011111" then --99999
				-- if cnt_2ms = "00000000001100011" then --99 TEST 2us
				sync_2ms <= '1';
				cnt_2ms  <= (others => '0');
			else
				sync_2ms <= '0';
				cnt_2ms  <= cnt_2ms + 1;
			end if;

			-- if cnt_20ms = "11110100001000111111" then --999999
			-- if cnt_20ms = "00000000001111100111" then --999 TEST 20us
			if cnt_20ms = "11000011010011111111" then --799999 for 16ms
				-- if cnt_20ms = "00000000001100011111" then --799 TEST 16us

				sync_20ms <= '1';
				cnt_20ms  <= (others => '0');
			else
				sync_20ms <= '0';
				cnt_20ms  <= cnt_20ms + 1;
			end if;

			if baudcnt = 26 then        -- clkfreq / (16 x baudrate)  50MHz/(16 x 115200) = 27- 1=26			
				baudcnt    <= 0;
				en_16xbaud <= '1';
			else
				baudcnt    <= baudcnt + 1;
				en_16xbaud <= '0';
			end if;

		end if;
	end process;
end;
