library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package std is
	subtype bool is std_logic;
	subtype int is std_logic_vector;

	function to_bool(sel : boolean) return std_logic;
	function to_int(val : integer; size : integer) return std_logic_vector;
	function reverse(v : std_logic_vector) return std_logic_vector;
	function log2(input : integer) return integer;
	function needbits(input : integer) return integer;
	function min(a : integer; b : integer) return integer;
	function max(a : integer; b : integer) return integer;
	function ascii2hex(input : std_logic_vector) return std_logic_vector;
	function hex2ascii(input : std_logic_vector) return std_logic_vector;
end;

package body std is
	function to_int(val : integer; size : integer) return std_logic_vector is
	begin
		return conv_std_logic_vector(val, size);
	end;

	function to_bool(sel : boolean) return std_logic is
		variable res : std_logic;
	begin
		if sel then
			res := '1';
		else
			res := '0';
		end if;
		return res;
	end;

	function log2(input : integer) return integer is
		variable temp, log : integer;
	begin
		temp := input;
		log  := 0;
		while (temp > 1) loop
			temp := temp / 2;
			log  := log + 1;
		end loop;
		return log;
	end;

	function needbits(input : integer) return integer is
		variable temp, log : integer;
	begin
		temp := input;
		log  := 0;
		while (temp /= 0) loop
			temp := temp / 2;
			log  := log + 1;
		end loop;
		return log;
	end;

	function min(a : integer; b : integer) return integer is
		variable m : integer;
	begin
		if b < a then
			m := b;
		else
			m := a;
		end if;
		return m;
	end;

	function max(a : integer; b : integer) return integer is
		variable m : integer;
	begin
		if b < a then
			m := a;
		else
			m := b;
		end if;
		return m;
	end;

	function reverse(v : std_logic_vector) return std_logic_vector is
		variable r : std_logic_vector(v'range);
	begin
		for i in v'low to v'high loop
			r(i) := v(v'high - i);
		end loop;
		return r;
	end;

	function ascii2hex(input : std_logic_vector) return std_logic_vector is
		variable res : std_logic_vector(4 downto 0);
	begin
		if input(7 downto 4) = 3 and input(3 downto 0) < 10 then
			res := '0' & input(3 downto 0);
		elsif input(7 downto 4) = 4 and input(3 downto 0) > 0 and input(3 downto 0) < 7 then
			res := '0' & input(3 downto 0) + 9;
		else
			res(4) := '1';             -- error
		end if;
		return res;
	end;

	function hex2ascii(input : std_logic_vector) return std_logic_vector is
		variable res : std_logic_vector(7 downto 0);
	begin
		if input < 10 then
			res := "0011" & input;
		else
			res := "0100" & (input - 9);
		end if;
		return res;
	end;

end;