library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ramp_gen is
	port(
		clk       : in  std_logic;
		start     : in  std_logic;
		sync_20ms : in  std_logic;
		dout      : out std_logic_vector(7 downto 0)
	);
end entity ramp_gen;

architecture RTL of ramp_gen is
	signal d : std_logic_vector(10 downto 0) := (others => '0');

begin
	process
	begin
		wait until clk = '1';

		if sync_20ms = '1' then
			d <= d + 8;
		end if;

		if d(10 downto 8) = "000" then  -- 0
			dout <= (others => '0');
		end if;
		if d(10 downto 8) = "001" then  -- rampup
			dout <= d(7 downto 0);
		end if;
		if d(10 downto 8) = "010" then  -- 255
			dout <= (others => '1');
		end if;
		if d(10 downto 8) = "011" then  -- rampdown
			dout <= not d(7 downto 0);
		end if;
		if d(10 downto 8) = "100" then  -- 0
			dout <= (others => '0');
		end if;
		if d(10 downto 8) = "101" then  -- 255
			dout <= (others => '1');
		end if;
		if d(10 downto 8) = "110" then  -- 0
			dout <= (others => '0');
		end if;
		if d(10 downto 8) = "111" then  -- 0
			dout <= (others => '0');
		end if;

		if start = '1' then
			d <= (others => '0');
		end if;

	end process;

end architecture RTL;
