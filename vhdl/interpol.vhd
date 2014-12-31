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
	signal delta : std_logic_vector(13 downto 0);
	signal do    : std_logic_vector(15 downto 0);
	type t_lut is array (0 to 15) of std_logic_vector(7 downto 0);
	constant lut : t_lut := (
		0  => "00000000",               --0
		1  => "11111111",               --255
		2  => "10000000",               --128
		3  => "01010101",               --85
		4  => "01000000",               --64	
		5  => "00110011",               --51
		6  => "00101011",               --43
		7  => "00100101",               --37
		8  => "00100000",               --32
		9  => "00011100",               --28
		10 => "00011010",               --26
		11 => "00010111",               --23
		12 => "00010101",               --21
		13 => "00010100",               --20
		14 => "00010010",               --18
		15 => "00010001");              --17

begin
	process
		variable di : std_logic_vector(13 downto 0);
		variable up : boolean;

	begin
		wait until clk = '1';

		di := din & "000000";           -- din x 64  (1.6mm -> 25um)

		if dvalid = '1' then            ------ denk aan beveiliging n = 0
			up := (di >= do);
			if up = true then
				delta <= ((di - do) * lut(n));
			else
				delta <= ((do - di) * lut(n));
			end if;

		end if;

		if sync_2ms = '1' then
			n <= n + 1;
			if up = true then
				if (do < di) then
					do <= do + delta;
				end if;
			else
				if (do >= di) then
					do <= do - delta;
				end if;
			end if;

		end if;

		if do(14) = '1' then            -- do > 16383   letop delta berekening
			dout <= "11111111111111";
		elsif do(15) = '1' then         -- do < 0
			dout <= "00000000000000";
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
