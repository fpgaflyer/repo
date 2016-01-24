library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity singularity_detector is
	port(
		clk          : in  std_logic;
		position_1   : in  std_logic_vector(7 downto 0);
		position_2   : in  std_logic_vector(7 downto 0);
		position_3   : in  std_logic_vector(7 downto 0);
		position_4   : in  std_logic_vector(7 downto 0);
		position_5   : in  std_logic_vector(7 downto 0);
		position_6   : in  std_logic_vector(7 downto 0);
		singul_error : out std_logic    -- singularity error 
	);
end;

architecture behav of singularity_detector is 
begin
	process
	begin
		wait until clk = '1';

		if 	(position_1 < x"30" and position_2 < x"30" and position_3 > x"D0" and position_6 > x"D0") or
		 	(position_3 < x"30" and position_4 < x"30" and position_2 > x"D0" and position_5 > x"D0") or
		 	(position_5 < x"30" and position_6 < x"30" and position_1 > x"D0" and position_4 > x"D0") then
			singul_error <= '1';
		else
			singul_error <= '0';
		end if;

	end process;

end;
