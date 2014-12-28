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
		dout     : out std_logic_vector(13 downto 0)
	);
end entity interpol;

architecture RTL of interpol is
	--	signal n     : unsigned(3 downto 0);
	signal delta : unsigned(13 downto 0);
	signal do    : unsigned(13 downto 0);

begin
	process
		variable di  : unsigned(13 downto 0);
		variable up  : boolean;
		variable dpd : unsigned(14 downto 0);
	begin
		wait until clk = '1';

		di  := unsigned(din & "000000"); -- din x 64  (1.6mm -> 25um)
		dpd := ('0' & do) + ('0' & delta);

		if reset = '1' then
			--		n     <= (others => '0');
			delta <= (others => '0');
			do    <= (others => '0');
			up    := false;

		else
			--		if dvalid = '1' and n /= 15 then
			if dvalid = '1' then
				up := (di >= do);
				if up = true then
					--				delta <= ((di - do) / (n + 1)); XST div must have power of 2
					delta <= ((di - do) / 8);
				else
					--				delta <= ((do - di) / (n + 1)); XST div must have power of 2
					delta <= ((do - di) / 8);
				end if;

			end if;

			if sync_2ms = '1' then
				--			n <= n + 1;
				if up = true then
					if (do < di) and (dpd(14) = '0') then
						do <= dpd(13 downto 0);
					end if;
				else
					if (do > di) and (do > delta) then
						do <= do - delta;
					end if;
				end if;

			end if;

		end if;

	--	if dvalid = '1' then
	--		n <= (others => '0');
	--	end if;

	end process;

	dout <= std_logic_vector(do);

end architecture RTL;
