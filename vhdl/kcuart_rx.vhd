-- Constant (K) Compact UART Receiver
-- Version : 1.10 
-- Version Date : 3rd December 2003
-- Reason : '--translate' directives changed to '--synthesis translate' directives
-- Version : 1.00
-- Version Date : 16th October 2002
--
-- Start of design entry : 16th October 2002
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

entity kcuart_rx is
	Port(serial_in    : in  std_logic;
		 data_out     : out std_logic_vector(7 downto 0);
		 data_strobe  : out std_logic;
		 en_16_x_baud : in  std_logic;
		 clk          : in  std_logic);
end kcuart_rx;

architecture low_level_definition of kcuart_rx is
	signal sync_serial        : std_logic;
	signal stop_bit           : std_logic;
	signal data_int           : std_logic_vector(7 downto 0);
	signal data_delay         : std_logic_vector(7 downto 0);
	signal start_delay        : std_logic;
	signal start_bit          : std_logic;
	signal edge_delay         : std_logic;
	signal start_edge         : std_logic;
	signal decode_valid_char  : std_logic;
	signal valid_char         : std_logic;
	signal decode_purge       : std_logic;
	signal purge              : std_logic;
	signal valid_srl_delay    : std_logic_vector(8 downto 0);
	signal valid_reg_delay    : std_logic_vector(8 downto 0);
	signal decode_data_strobe : std_logic;

	attribute INIT : string;
	attribute INIT of start_srl : label is "0000";
	attribute INIT of edge_srl : label is "0000";
	attribute INIT of valid_lut : label is "0040";
	attribute INIT of purge_lut : label is "54";
	attribute INIT of strobe_lut : label is "8";

begin
	sync_reg : FD
		port map(D => serial_in,
			     Q => sync_serial,
			     C => clk);

	stop_reg : FD
		port map(D => sync_serial,
			     Q => stop_bit,
			     C => clk);

	data_loop : for i in 0 to 7 generate
	begin
		lsbs : if i < 7 generate
			attribute INIT : string;
			attribute INIT of delay15_srl : label is "0000";
		begin
			delay15_srl : SRL16E
				--synthesis translate_off
				generic map(INIT => X"0000")
				--synthesis translate_on
				port map(D   => data_int(i + 1),
					     CE  => en_16_x_baud,
					     CLK => clk,
					     A0  => '0',
					     A1  => '1',
					     A2  => '1',
					     A3  => '1',
					     Q   => data_delay(i));

		end generate lsbs;

		msb : if i = 7 generate
			attribute INIT : string;
			attribute INIT of delay15_srl : label is "0000";
		begin
			delay15_srl : SRL16E
				--synthesis translate_off
				generic map(INIT => X"0000")
				--synthesis translate_on
				port map(D   => stop_bit,
					     CE  => en_16_x_baud,
					     CLK => clk,
					     A0  => '0',
					     A1  => '1',
					     A2  => '1',
					     A3  => '1',
					     Q   => data_delay(i));

		end generate msb;

		data_reg : FDE
			port map(D  => data_delay(i),
				     Q  => data_int(i),
				     CE => en_16_x_baud,
				     C  => clk);

	end generate data_loop;

	data_out <= data_int;

	start_srl : SRL16E
		--synthesis translate_off
		generic map(INIT => X"0000")
		--synthesis translate_on
		port map(D   => data_int(0),
			     CE  => en_16_x_baud,
			     CLK => clk,
			     A0  => '0',
			     A1  => '1',
			     A2  => '1',
			     A3  => '1',
			     Q   => start_delay);

	start_reg : FDE
		port map(D  => start_delay,
			     Q  => start_bit,
			     CE => en_16_x_baud,
			     C  => clk);

	edge_srl : SRL16E
		--synthesis translate_off
		generic map(INIT => X"0000")
		--synthesis translate_on
		port map(D   => start_bit,
			     CE  => en_16_x_baud,
			     CLK => clk,
			     A0  => '1',
			     A1  => '0',
			     A2  => '1',
			     A3  => '0',
			     Q   => edge_delay);

	edge_reg : FDE
		port map(D  => edge_delay,
			     Q  => start_edge,
			     CE => en_16_x_baud,
			     C  => clk);

	valid_lut : LUT4
		--synthesis translate_off
		generic map(INIT => X"0040")
		--synthesis translate_on
		port map(I0 => purge,
			     I1 => stop_bit,
			     I2 => start_edge,
			     I3 => edge_delay,
			     O  => decode_valid_char);

	valid_reg : FDE
		port map(D  => decode_valid_char,
			     Q  => valid_char,
			     CE => en_16_x_baud,
			     C  => clk);

	purge_lut : LUT3
		--synthesis translate_off
		generic map(INIT => X"54")
		--synthesis translate_on
		port map(I0 => valid_reg_delay(8),
			     I1 => valid_char,
			     I2 => purge,
			     O  => decode_purge);

	purge_reg : FDE
		port map(D  => decode_purge,
			     Q  => purge,
			     CE => en_16_x_baud,
			     C  => clk);

	valid_loop : for i in 0 to 8 generate
	begin
		lsb : if i = 0 generate
			attribute INIT : string;
			attribute INIT of delay15_srl : label is "0000";

		begin
			delay15_srl : SRL16E
				--synthesis translate_off
				generic map(INIT => X"0000")
				--synthesis translate_on
				port map(D   => valid_char,
					     CE  => en_16_x_baud,
					     CLK => clk,
					     A0  => '0',
					     A1  => '1',
					     A2  => '1',
					     A3  => '1',
					     Q   => valid_srl_delay(i));

		end generate lsb;

		msbs : if i > 0 generate
			attribute INIT : string;
			attribute INIT of delay16_srl : label is "0000";

		begin
			delay16_srl : SRL16E
				--synthesis translate_off
				generic map(INIT => X"0000")
				--synthesis translate_on
				port map(D   => valid_reg_delay(i - 1),
					     CE  => en_16_x_baud,
					     CLK => clk,
					     A0  => '1',
					     A1  => '1',
					     A2  => '1',
					     A3  => '1',
					     Q   => valid_srl_delay(i));

		end generate msbs;

		data_reg : FDE
			port map(D  => valid_srl_delay(i),
				     Q  => valid_reg_delay(i),
				     CE => en_16_x_baud,
				     C  => clk);

	end generate valid_loop;

	strobe_lut : LUT2
		--synthesis translate_off
		generic map(INIT => X"8")
		--synthesis translate_on
		port map(I0 => valid_char,
			     I1 => en_16_x_baud,
			     O  => decode_data_strobe);

	strobe_reg : FD
		port map(D => decode_data_strobe,
			     Q => data_strobe,
			     C => clk);

end low_level_definition;
