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
	signal d  : std_logic_vector(12 downto 0) := (others => '0');
	signal do : std_logic_vector(7 downto 0);

begin
	process
	begin
		wait until clk = '1';

		if sync_20ms = '1' then
			d <= d + 1;
		--	d <= d + 8;  --TEST
		end if;

		if d(12 downto 10) = "000" then  -- 0
			do <= (others => '0');
		end if;
		if d(12 downto 10) = "001" then  -- rampup
			do <= d(9 downto 2);
		end if;
		if d(12 downto 10) = "010" then  -- 255
			do <= (others => '1');
		end if;
		if d(12 downto 10) = "011" then  -- rampdown
			do <= not d(9 downto 2);
		end if;
		if d(12 downto 10) = "100" then  -- 0
			do <= (others => '0');
		end if;
		if d(12 downto 10) = "101" then  -- 255
			do <= (others => '1');
		end if;
		if d(12 downto 10) = "110" then  -- 0
			do <= (others => '0');
		end if;
		if d(12 downto 10) = "111" then  -- 0
			do <= (others => '0');
		end if;

		if start = '1' then
			d <= (others => '0');
		end if;

		if do > 245 then
			dout <= X"F5";
		elsif do < 10 then
			dout <= X"0A";
		else
			dout <= do;
		end if;

	end process;

end architecture RTL;
