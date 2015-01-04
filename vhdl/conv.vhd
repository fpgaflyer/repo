library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library gen;
use gen.std.all;

entity conv is
	port(
		clk    : in  bool;
		rst    : in  bool;
		di     : in  int(10 downto 0);
		start  : in  bool;
		rtc    : in  int(1 downto 0);   -- 00=!G 01=!EX 10=!H 1 11=!MG  

		do     : out int(7 downto 0);
		dvalid : out bool
	);
end entity conv;

architecture RTL of conv is
	-- shift increment
	procedure bcd_si(signal dig : inout int(3 downto 0); cin : bool; cout : out bool) is
		variable t : int(3 downto 0);
	begin
		t := dig;
		if t > 4 then
			t := t + 3;
		end if;
		dig  <= t(2 downto 0) & cin;
		cout := t(3);
	end;
	type digit_v is array (integer range <>) of int(3 downto 0);
	signal digits       : digit_v(0 to 3);
	signal bin          : int(10 downto 0);
	signal sign, nozero : bool;
	signal pc           : integer range 0 to 16;

begin
	process
		procedure ascii_out(a : int(7 downto 0)) is
		begin
			dvalid <= '1';
			do     <= a;
		end;
		procedure ascii_out(c : character) is
		begin
			ascii_out(to_int(character'pos(c), 8));
		end;

		procedure digit_out(d : int(3 downto 0); signal xnozero : inout bool) is
			variable nz : bool;
		begin
			nz := xnozero;
			if nz = '0' OR d /= 0 then
				nz := '0';
				ascii_out(X"3" & d);
			end if;
			xnozero <= nz;
		end;
		procedure bcd_shift is
			variable carry : int(3 downto 0);
		begin
			bin <= bin(9 downto 0) & '0';
			bcd_si(digits(0), bin(10), carry(0));
			bcd_si(digits(1), carry(0), carry(1));
			bcd_si(digits(2), carry(1), carry(2));
			bcd_si(digits(3), carry(2), carry(3));
		end;
		procedure bcd_zero is
		begin
			for i in 0 to 3 loop
				digits(i) <= (others => '0');
			end loop;
		end;
	begin
		wait until clk = '1';
		dvalid <= '0';
		if pc < 16 then
			pc <= pc + 1;
		else
			pc <= 0;
		end if;
		case pc is
			when 0 =>
				if start = '1' then
					sign <= di(10);
					if di(10) = '1' then
						bin <= "00000000000" - di;
					else
						bin <= di;
					end if;
					bcd_zero;
					nozero <= '1';
				else
					pc <= pc;
				end if;
				case rtc is
					when "00"   => null;
					when "10"   => bin <= "00000000001";
					when others => bin <= (others => '0');
				end case;
			when 1 =>
				ascii_out('!');
				bcd_shift;
			when 2 =>
				case rtc is
					when "01"   => ascii_out('E');
					when "10"   => ascii_out('H');
					when "11"   => ascii_out('M');
					when others => ascii_out('G');
				end case;
				bcd_shift;
			when 3 =>
				case rtc is
					when "01"   => ascii_out('X');
					when "11"   => ascii_out('G');
					when others => ascii_out(' ');
				end case;
				bcd_shift;
			when 4 =>
				if sign = '1' and rtc = "00" then
					ascii_out('-');
				end if;
				bcd_shift;
			when 5 | 6 | 7 | 8 | 9 | 10 | 11 =>
				bcd_shift;
			when 12 =>
				digit_out(digits(3), nozero);
			when 13 =>
				digit_out(digits(2), nozero);
			when 14 =>
				digit_out(digits(1), nozero);
				case rtc is
					when "00"   => nozero <= '0';
					when others => null;
				end case;
			when 15 =>
				digit_out(digits(0), nozero);
			when 16 =>
				ascii_out(cr);

			when others => pc <= 0;
		end case;
		if rst = '1' then
			pc <= 0;
		end if;
	end process;
end architecture RTL;

