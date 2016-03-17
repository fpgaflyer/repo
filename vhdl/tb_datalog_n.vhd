entity tb_datalog_n is
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture rtl of tb_datalog_n is
	component data_logger_n
		port(clk             : in  std_logic;
			 reset           : in  std_logic;
			 position_1      : in  std_logic_vector(7 downto 0);
			 position_2      : in  std_logic_vector(7 downto 0);
			 position_3      : in  std_logic_vector(7 downto 0);
			 position_4      : in  std_logic_vector(7 downto 0);
			 position_5      : in  std_logic_vector(7 downto 0);
			 position_6      : in  std_logic_vector(7 downto 0);
			 set_pos_1       : in  std_logic_vector(7 downto 0);
			 set_pos_2       : in  std_logic_vector(7 downto 0);
			 set_pos_3       : in  std_logic_vector(7 downto 0);
			 set_pos_4       : in  std_logic_vector(7 downto 0);
			 set_pos_5       : in  std_logic_vector(7 downto 0);
			 set_pos_6       : in  std_logic_vector(7 downto 0);
			 drv_log_1       : in  std_logic_vector(3 downto 0);
			 drv_log_2       : in  std_logic_vector(3 downto 0);
			 drv_log_3       : in  std_logic_vector(3 downto 0);
			 drv_log_4       : in  std_logic_vector(3 downto 0);
			 drv_log_5       : in  std_logic_vector(3 downto 0);
			 drv_log_6       : in  std_logic_vector(3 downto 0);
			 home_sensor_1_f : in  std_logic;
			 home_sensor_2_f : in  std_logic;
			 home_sensor_3_f : in  std_logic;
			 home_sensor_4_f : in  std_logic;
			 home_sensor_5_f : in  std_logic;
			 home_sensor_6_f : in  std_logic;
			 drv_mode        : in  std_logic;
			 motor_enable    : in  std_logic;
			 sync_2ms        : in  std_logic;
			 log_enable      : in  std_logic;
			 send_log        : in  std_logic;
			 tx_datalog      : out std_logic;
			 nxt_data        : in  std_logic;
			 log_data        : out std_logic_vector(7 downto 0);
			 data_rdy        : out std_logic;
			 addra           : out std_logic_vector(14 downto 0);
			 addrb           : out std_logic_vector(10 downto 0);
			 dinb            : out std_logic_vector(127 downto 0);
			 douta           : in  std_logic_vector(7 downto 0);
			 web             : out std_logic);
	end component data_logger_n;

	component bram_2048x128
		port(
			addra : in  std_logic_VECTOR(14 downto 0);
			addrb : in  std_logic_VECTOR(10 downto 0);
			clka  : in  std_logic;
			clkb  : in  std_logic;
			dinb  : in  std_logic_VECTOR(127 downto 0);
			douta : out std_logic_VECTOR(7 downto 0);
			web   : in  std_logic
		);
	end component;

	component clk_divider_n
		port(clk        : in  std_logic;
			 sync_2ms   : out std_logic;
			 sync_20ms  : out std_logic;
			 en_16xbaud : out std_logic);
	end component clk_divider_n;

	signal CLK             : std_logic := '1';
	signal RESET           : std_logic;
	signal position_1      : std_logic_vector(7 downto 0);
	signal position_2      : std_logic_vector(7 downto 0);
	signal position_3      : std_logic_vector(7 downto 0);
	signal position_4      : std_logic_vector(7 downto 0);
	signal position_5      : std_logic_vector(7 downto 0);
	signal position_6      : std_logic_vector(7 downto 0);
	signal set_pos_1       : std_logic_vector(7 downto 0);
	signal set_pos_2       : std_logic_vector(7 downto 0);
	signal set_pos_3       : std_logic_vector(7 downto 0);
	signal set_pos_4       : std_logic_vector(7 downto 0);
	signal set_pos_5       : std_logic_vector(7 downto 0);
	signal set_pos_6       : std_logic_vector(7 downto 0);
	signal log_enable      : std_logic;
	signal send_log        : std_logic;
	signal tx_datalog      : std_logic;
	signal log_data        : std_logic_vector(7 downto 0);
	signal addra           : std_logic_vector(14 downto 0);
	signal addrb           : std_logic_vector(10 downto 0);
	signal dinb            : std_logic_vector(127 downto 0);
	signal douta           : std_logic_vector(7 downto 0);
	signal web             : std_logic;
	signal sync_2ms        : std_logic;
	signal data_rdy        : std_logic;
	signal drv_log_1       : std_logic_vector(3 downto 0);
	signal drv_log_2       : std_logic_vector(3 downto 0);
	signal drv_log_3       : std_logic_vector(3 downto 0);
	signal drv_log_4       : std_logic_vector(3 downto 0);
	signal drv_log_5       : std_logic_vector(3 downto 0);
	signal drv_log_6       : std_logic_vector(3 downto 0);
	signal home_sensor_1_f : std_logic;
	signal home_sensor_2_f : std_logic;
	signal home_sensor_3_f : std_logic;
	signal home_sensor_4_f : std_logic;
	signal home_sensor_5_f : std_logic;
	signal home_sensor_6_f : std_logic;
	signal home_sensor_7_f : std_logic;
	signal drv_mode        : std_logic;
	signal motor_enable    : std_logic;

begin
	CLK             <= not CLK after 10 ns;
	RESET           <= '1', '0' after 100 ns;
	position_1      <= "00000000";
	position_2      <= "00000001";
	position_3      <= "00000010";
	position_4      <= "00000011";
	position_5      <= "00000100";
	position_6      <= "00000101";
	set_pos_1       <= "00000110";
	set_pos_2       <= "00000111";
	set_pos_3       <= "00001000";
	set_pos_4       <= "00001001";
	set_pos_5       <= "00001010";
	set_pos_6       <= "00001011";
	drv_log_1       <= "0001";
	drv_log_2       <= "0010";
	drv_log_3       <= "0011";
	drv_log_4       <= "0100";
	drv_log_5       <= "0101";
	drv_log_6       <= "0110";
	home_sensor_1_f <= '1';
	home_sensor_2_f <= '1';
	home_sensor_3_f <= '1';
	home_sensor_4_f <= '1';
	home_sensor_5_f <= '1';
	home_sensor_6_f <= '1';
	drv_mode        <= '1';
	motor_enable    <= '1';
	log_enable      <= '0', '1' after 200 us, '0' after 400 us;
	send_log        <= '0', '1' after 500 us, '0' after 900 us;

	A1 : component data_logger_n
		port map(
			clk             => CLK,
			reset           => RESET,
			position_1      => position_1,
			position_2      => position_2,
			position_3      => position_3,
			position_4      => position_4,
			position_5      => position_5,
			position_6      => position_6,
			set_pos_1       => set_pos_1,
			set_pos_2       => set_pos_2,
			set_pos_3       => set_pos_3,
			set_pos_4       => set_pos_4,
			set_pos_5       => set_pos_5,
			set_pos_6       => set_pos_6,
			drv_log_1       => drv_log_1,
			drv_log_2       => drv_log_2,
			drv_log_3       => drv_log_3,
			drv_log_4       => drv_log_4,
			drv_log_5       => drv_log_5,
			drv_log_6       => drv_log_6,
			home_sensor_1_f => home_sensor_1_f,
			home_sensor_2_f => home_sensor_2_f,
			home_sensor_3_f => home_sensor_3_f,
			home_sensor_4_f => home_sensor_4_f,
			home_sensor_5_f => home_sensor_5_f,
			home_sensor_6_f => home_sensor_6_f,
			drv_mode        => drv_mode,
			motor_enable    => motor_enable,
			sync_2ms        => sync_2ms,
			log_enable      => log_enable,
			send_log        => send_log,
			tx_datalog      => tx_datalog,
			nxt_data        => '1',
			log_data        => log_data,
			data_rdy        => data_rdy,
			addra           => addra,
			addrb           => addrb,
			dinb            => dinb,
			douta           => douta,
			web             => web
		);

	A2 : component bram_2048x128
		port map(
			addra => addra,
			addrb => addrb,
			clka  => CLK,
			clkb  => CLK,
			dinb  => dinb,
			douta => douta,
			web   => web
		);

	A3 : component clk_divider_n
		port map(
			clk        => CLK,
			sync_2ms   => sync_2ms,
			sync_20ms  => open,
			en_16xbaud => open
		);

end;
