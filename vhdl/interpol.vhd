library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity interpol is
	port(
		clk      : in  std_logic;
		reset    : in  std_logic;
		sync_2ms : in  std_logic;
		din      : in  std_logic_vector(7 downto 0);
		dvalid   : in  std_logic;
		dout     : out std_logic_vector(7 downto 0)
	);
end entity interpol;

architecture RTL of interpol is
	signal n     : unsigned(3 downto 0);
	signal d     : unsigned(7 downto 0);
	signal delta : unsigned(7 downto 0);
	signal do    : unsigned(7 downto 0);
--	signal dil : unsigned(7 downto 0);
--	signal up    : boolean;

begin
	process
		variable di : unsigned(7 downto 0);
	--	variable up : boolean;
	begin
		wait until clk = '1';

		di := unsigned(din);

		if reset = '1' then
			n     <= (others => '0');
			d     <= (others => '0');
			delta <= (others => '0');
			do    <= (others => '0');
	--		dil  <= (others => '0');
	--		up    := false;

		else
			if dvalid = '1' and n /= 0 then
--				up := (di <= d);
--				if up then
					delta <= ((di - d) / n);
--				else
--					delta <= ((d - di) / n);
--				end if;
	--			dil <= di;

				d  <= di;
				do <= di;
				n  <= (others => '0');
			end if;

			if sync_2ms = '1' then
				n <= n + 1;
--				if up then
--					if do /= 255 then
						do <= do + delta;
--					end if;
--				else
--					if do /= 0 then
--						do <= do - delta;
--					end if;
--				end if;

			end if;

		end if;

	end process;

	dout <= std_logic_vector(do);

end architecture RTL;
