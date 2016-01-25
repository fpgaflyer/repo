library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library gen;
use gen.std.all;

entity conv is
	port(
		clk          : in  bool;
		rst          : in  bool;
		di           : in  int(10 downto 0);
		start        : in  bool;
		rst_mot_ctrl : in  bool;
		do           : out int(7 downto 0);
		dvalid       : out bool
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
	signal pc           : integer range 0 to 18;

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
			if nz = '0' or d /= 0 then
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
		variable n : integer range 0 to 18;
	begin
		wait until clk = '1';
		dvalid <= '0';
		if rst_mot_ctrl = '1' then
			n := 17;
		else
			n := 16;
		end if;
		if pc < n then
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

			when 1 => if rst_mot_ctrl = '1' then
					ascii_out('%');
				else
					ascii_out('!');
					bcd_shift;
				end if;
			when 2 => if rst_mot_ctrl = '1' then
					ascii_out('R');
				else
					ascii_out('G');
					bcd_shift;
				end if;
			when 3 => if rst_mot_ctrl = '1' then
					ascii_out('E');
				else
					ascii_out(' ');
					bcd_shift;
				end if;
			when 4 => if rst_mot_ctrl = '1' then
					ascii_out('S');
				else
					if sign = '1' then
						ascii_out('-');
					end if;
					bcd_shift;
				end if;
			when 5 => if rst_mot_ctrl = '1' then
					ascii_out('E');
				else
					bcd_shift;
				end if;
			when 6 =>
				if rst_mot_ctrl = '1' then
					ascii_out('T');
				else
					bcd_shift;
				end if;
			when 7 =>
				if rst_mot_ctrl = '1' then
					ascii_out(' ');
				else
					bcd_shift;
				end if;
			when 8 =>
				if rst_mot_ctrl = '1' then
					ascii_out('3');
				else
					bcd_shift;
				end if;
			when 9 =>
				if rst_mot_ctrl = '1' then
					ascii_out('2');
				else
					bcd_shift;
				end if;
			when 10 =>
				if rst_mot_ctrl = '1' then
					ascii_out('1');
				else
					bcd_shift;
				end if;
			when 11 =>
				if rst_mot_ctrl = '1' then
					ascii_out('6');
				else
					bcd_shift;
				end if;

			when 12 => if rst_mot_ctrl = '1' then
					ascii_out('5');
				else
					digit_out(digits(3), nozero);
				end if;

			when 13 => if rst_mot_ctrl = '1' then
					ascii_out('4');
				else
					digit_out(digits(2), nozero);
				end if;
			when 14 => if rst_mot_ctrl = '1' then
					ascii_out('9');
				else
					digit_out(digits(1), nozero);
					nozero <= '0';
				end if;
			when 15 => if rst_mot_ctrl = '1' then
					ascii_out('8');
				else
					digit_out(digits(0), nozero);
				end if;
			when 16 => if rst_mot_ctrl = '1' then
					ascii_out('7');
				else
					ascii_out(cr);
				end if;
			when 17     => ascii_out(cr);
			when others => pc <= 0;
		end case;
		if rst = '1' then
			pc <= 0;
		end if;
	end process;
end architecture RTL;

