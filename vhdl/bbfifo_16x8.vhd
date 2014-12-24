-- 'Bucket Brigade' FIFO  
-- 16 deep
-- 8-bit data
-- Version : 1.10 
-- Version Date : 3rd December 2003
-- Reason : '--translate' directives changed to '--synthesis translate' directives
-- Version : 1.00
-- Version Date : 14th October 2002
--
-- Start of design entry : 14th October 2002
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2002.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;

entity bbfifo_16x8 is
	Port(data_in      : in  std_logic_vector(7 downto 0);
		 data_out     : out std_logic_vector(7 downto 0);
		 reset        : in  std_logic;
		 write        : in  std_logic;
		 read         : in  std_logic;
		 full         : out std_logic;
		 half_full    : out std_logic;
		 data_present : out std_logic;
		 clk          : in  std_logic);
end bbfifo_16x8;

architecture low_level_definition of bbfifo_16x8 is
	signal pointer     : std_logic_vector(3 downto 0);
	signal next_count  : std_logic_vector(3 downto 0);
	signal half_count  : std_logic_vector(3 downto 0);
	signal count_carry : std_logic_vector(2 downto 0);

	signal pointer_zero        : std_logic;
	signal pointer_full        : std_logic;
	signal decode_data_present : std_logic;
	signal data_present_int    : std_logic;
	signal valid_write         : std_logic;

	attribute INIT : string;
	attribute INIT of zero_lut : label is "0001";
	attribute INIT of full_lut : label is "8000";
	attribute INIT of dp_lut : label is "BFA0";
	attribute INIT of valid_lut : label is "C4";

begin
	data_width_loop : for i in 0 to 7 generate
		attribute INIT : string;
		attribute INIT of data_srl : label is "0000";

	begin
		data_srl : SRL16E
			--synthesis translate_off
			generic map(INIT => X"0000")
			--synthesis translate_on
			port map(D   => data_in(i),
				     CE  => valid_write,
				     CLK => clk,
				     A0  => pointer(0),
				     A1  => pointer(1),
				     A2  => pointer(2),
				     A3  => pointer(3),
				     Q   => data_out(i));

	end generate data_width_loop;

	count_width_loop : for i in 0 to 3 generate
		attribute INIT : string;
		attribute INIT of count_lut : label is "6606";
	begin
		register_bit : FDRE
			port map(D  => next_count(i),
				     Q  => pointer(i),
				     CE => data_present_int,
				     R  => reset,
				     C  => clk);

		count_lut : LUT4
			--synthesis translate_off
			generic map(INIT => X"6606")
			--synthesis translate_on
			port map(I0 => pointer(i),
				     I1 => read,
				     I2 => pointer_zero,
				     I3 => write,
				     O  => half_count(i));

		lsb_count : if i = 0 generate
		begin
			count_muxcy : MUXCY
				port map(DI => pointer(i),
					     CI => valid_write,
					     S  => half_count(i),
					     O  => count_carry(i));

			count_xor : XORCY
				port map(LI => half_count(i),
					     CI => valid_write,
					     O  => next_count(i));

		end generate lsb_count;

		mid_count : if i > 0 and i < 3 generate
		begin
			count_muxcy : MUXCY
				port map(DI => pointer(i),
					     CI => count_carry(i - 1),
					     S  => half_count(i),
					     O  => count_carry(i));

			count_xor : XORCY
				port map(LI => half_count(i),
					     CI => count_carry(i - 1),
					     O  => next_count(i));

		end generate mid_count;

		upper_count : if i = 3 generate
		begin
			count_xor : XORCY
				port map(LI => half_count(i),
					     CI => count_carry(i - 1),
					     O  => next_count(i));

		end generate upper_count;

	end generate count_width_loop;

	zero_lut : LUT4
		--synthesis translate_off
		generic map(INIT => X"0001")
		--synthesis translate_on
		port map(I0 => pointer(0),
			     I1 => pointer(1),
			     I2 => pointer(2),
			     I3 => pointer(3),
			     O  => pointer_zero);

	full_lut : LUT4
		--synthesis translate_off
		generic map(INIT => X"8000")
		--synthesis translate_on
		port map(I0 => pointer(0),
			     I1 => pointer(1),
			     I2 => pointer(2),
			     I3 => pointer(3),
			     O  => pointer_full);

	dp_lut : LUT4
		--synthesis translate_off
		generic map(INIT => X"BFA0")
		--synthesis translate_on
		port map(I0 => write,
			     I1 => read,
			     I2 => pointer_zero,
			     I3 => data_present_int,
			     O  => decode_data_present);

	dp_flop : FDR
		port map(D => decode_data_present,
			     Q => data_present_int,
			     R => reset,
			     C => clk);

	valid_lut : LUT3
		--synthesis translate_off
		generic map(INIT => X"C4")
		--synthesis translate_on
		port map(I0 => pointer_full,
			     I1 => write,
			     I2 => read,
			     O  => valid_write);

	full         <= pointer_full;
	half_full    <= pointer(3);
	data_present <= data_present_int;

end low_level_definition;
