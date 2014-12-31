library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
	signal n     : integer range 0 to 15;
	signal delta : std_logic_vector(21 downto 0);
	signal do    : std_logic_vector(15 downto 0);
	type t_lut is array (0 to 15) of std_logic_vector(7 downto 0);
	constant lut : t_lut := (
		0  => X"FF",                    --255
		1  => X"FF",                    --255
		2  => X"80",                    --128
		3  => X"55",                    --85
		4  => X"40",                    --64	
		5  => X"33",                    --51
		6  => X"2B",                    --43
		7  => X"25",                    --37
		8  => X"20",                    --32
		9  => X"1C",                    --28
		10 => X"1A",                    --26
		11 => X"17",                    --23
		12 => X"15",                    --21
		13 => X"14",                    --20
		14 => X"12",                    --18
		15 => X"11");                   --17

begin
	process
		variable di : std_logic_vector(13 downto 0);
		variable up : boolean;

	begin
		wait until clk = '1';

		di := din & "000000";           -- din x 64  (1.6mm -> 25um)

		if dvalid = '1' then
			up := (di >= do);
			if up = true then
				delta <= ((di - do(13 downto 0)) * lut(n));
			else
				delta <= ((do(13 downto 0) - di) * lut(n));
			end if;

		end if;

		if sync_2ms = '1' then
			n <= n + 1;
			if up = true then
				if (do(13 downto 0) < di) then
					do <= ("00" & do(13 downto 0)) + ("00" & delta(21 downto 8));
				end if;
			else
				if (do(13 downto 0) >= di) then
					do <= ("00" & do(13 downto 0)) - ("00" & delta(21 downto 8));
				end if;
			end if;

		end if;

		if do(15 downto 14) = "01" then -- do > 16383   
			do   <= "0011111111111111";
			dout <= (others => '1');
		elsif do(15 downto 14) = "11" then -- do < 0
			do   <= (others => '0');
			dout <= (others => '0');
		else
			dout <= do(13 downto 0);
		end if;

		if dvalid = '1' then
			n <= 0;
		end if;

		if reset = '1' then
			n     <= 0;
			delta <= (others => '0');
			do    <= (others => '0');
			up    := false;
		end if;

	end process;

end architecture RTL;
