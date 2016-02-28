library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity data_logger_n is
	port(
		clk             : in  std_logic;
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
		web             : out std_logic
	);
end;

architecture behav of data_logger_n is
	type t_sm is (rst, wdata, rdata1, rdata2, rdata3, rdata4);
	signal sm         : t_sm;
	signal cnt_rst    : std_logic_vector(11 downto 0);
	signal cnt_event  : std_logic_vector(10 downto 0);
	signal cnt_send   : std_logic_vector(14 downto 0);
	signal cnt_tx     : std_logic_vector(15 downto 0);
	signal send_log_d : std_logic;

begin
	process
	begin
		wait until clk = '1';

		if reset = '1' then
			sm         <= rst;
			cnt_rst    <= (others => '0');
			cnt_event  <= (others => '0');
			cnt_send   <= (others => '0');
			cnt_tx     <= (others => '0');
			send_log_d <= '0';

			addra <= (others => '0');
			addrb <= (others => '0');
			dinb  <= (others => '0');
			web   <= '0';

			log_data   <= (others => '0');
			data_rdy   <= '0';
			tx_datalog <= '0';

		else
			web        <= '0';
			data_rdy   <= '0';
			send_log_d <= send_log;

			if (send_log = '1') and (send_log_d = '0') then --rising edge 
				cnt_send   <= cnt_event & "0000";
				cnt_tx     <= (others => '0');
				tx_datalog <= '1';
				sm         <= rdata1;
			end if;

			case sm is
				when rst =>
					web <= '1';
					if cnt_rst(11) = '0' then
						cnt_rst <= cnt_rst + 1;
						addrb   <= cnt_rst(10 downto 0);
						dinb    <= (others => '0');
					else
						cnt_event <= (others => '0');
						sm        <= wdata;
					end if;

				when wdata =>
					web <= '1';
					if (sync_2ms = '1') and (log_enable = '1') then
						cnt_event <= cnt_event + 1;
						addrb     <= cnt_event;
						dinb      <= motor_enable & drv_mode & home_sensor_6_f & home_sensor_5_f & home_sensor_4_f & home_sensor_3_f & home_sensor_2_f & home_sensor_1_f &
						 			 drv_log_6 & drv_log_5 & drv_log_4 & drv_log_3 & drv_log_2 & drv_log_1 &
						 			 set_pos_6 & set_pos_5 & set_pos_4 & set_pos_3 & set_pos_2 & set_pos_1 &
						 			 position_6 & position_5 & position_4 & position_3 & position_2 & position_1;
					end if;

				when rdata1 =>
					if nxt_data = '1' then
						cnt_send <= cnt_send + 1;
						cnt_tx   <= cnt_tx + 1;
						addra    <= cnt_send;
						sm       <= rdata2;
					end if;
					if cnt_tx(15) = '1' then
						tx_datalog <= '0';
						sm         <= wdata;
					end if;

				when rdata2 =>
					sm <= rdata3;

				when rdata3 =>
					log_data <= douta;
					data_rdy <= '1';
					sm       <= rdata4;

				when rdata4 =>
					if nxt_data = '0' then
						sm <= rdata1;
					end if;

				when others =>
			end case;
		end if;
	end process;
end;
