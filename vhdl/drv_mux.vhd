library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity drv_mux is
	port(
		drv_in   : in  std_logic_vector(10 downto 0);
		drv_man  : in  std_logic_vector(10 downto 0);
		drv_mode : in  std_logic_vector(1 downto 0);
		drv_out  : out std_logic_vector(10 downto 0)
	);
end;

architecture behav of drv_mux is
begin
	process(drv_in, drv_man, drv_mode)
	begin
		case drv_mode is
			when "01"   => drv_out <= drv_man; -- spd_mode
			when "10"   => drv_out <= drv_in;  -- pos_mode
			when others => drv_out <= "00000000000";
		end case;

	end process;
end;
