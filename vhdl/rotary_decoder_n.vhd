library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rotary_decoder_n is
	port(rotary_a     : in  std_logic;
		 rotary_b     : in  std_logic;
		 clk          : in  std_logic;
		 rotary_event : out std_logic;
		 rotary_left  : out std_logic
	);
end;

architecture behav of rotary_decoder_n is
	signal rotary_a_in     : std_logic;
	signal rotary_b_in     : std_logic;
	signal rotary_in       : std_logic_vector(1 downto 0);
	signal rotary_q1       : std_logic;
	signal rotary_q2       : std_logic;
	signal delay_rotary_q1 : std_logic;

begin
	process(clk)
	begin
		if clk'event and clk = '1' then

			--Synchronise inputs to clock domain using flip-flops in input/output blocks.
			rotary_a_in <= rotary_a;
			rotary_b_in <= rotary_b;

			--concatinate rotary input signals to form vector for case construct.
			rotary_in <= rotary_b_in & rotary_a_in;

			case rotary_in is
				when "00" => rotary_q1 <= '0';
					rotary_q2 <= rotary_q2;

				when "01" => rotary_q1 <= rotary_q1;
					rotary_q2 <= '0';

				when "10" => rotary_q1 <= rotary_q1;
					rotary_q2 <= '1';

				when "11" => rotary_q1 <= '1';
					rotary_q2 <= rotary_q2;

				when others => rotary_q1 <= rotary_q1;
					rotary_q2 <= rotary_q2;
			end case;

		end if;
	end process;

	-- The rising edges of 'rotary_q1' indicate that a rotation has occurred and the 
	-- state of 'rotary_q2' at that time will indicate the direction. 

	process(clk)
	begin
		if clk'event and clk = '1' then
			delay_rotary_q1 <= rotary_q1;
			if rotary_q1 = '1' and delay_rotary_q1 = '0' then
				rotary_event <= '1';
				rotary_left  <= rotary_q2;
			else
				rotary_event <= '0';
				rotary_left  <= '0';
			end if;

		end if;
	end process;

end;
