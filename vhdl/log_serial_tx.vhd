library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity log_serial_tx is
port(
     clk    	    : in std_logic;
     reset    	    : in std_logic;
     tx_data        : in std_logic_vector(7 downto 0);
     start_send     : in std_logic;
     
     tx             : out std_logic;
     nxt_data       : out std_logic
     );
end;


architecture behav of log_serial_tx is

constant  clkdiv  : std_logic_vector(10 downto 0) := "10100010110"; --1302 38400BAUD @ 50MHZ
--  constant  clkdiv  : std_logic_vector(10 downto 0) := "00000001010"; --10 = 200ns for debugging

signal tx_brdcount		: std_logic_vector(10 downto 0);
signal tx_datacount		: std_logic_vector(2 downto 0);

type    tx_state_type is (init,latch_data,start,data,stop);
signal  tx_state		: tx_state_type;
signal  tx_data_latched         : std_logic_vector(7 downto 0);
 
begin

process 
begin
  wait until clk = '1'; 
    
  if reset = '1' then

  tx_brdcount	          <= clkdiv;
  tx_datacount	          <= "000";
  tx_state	          <= init;
  tx		          <= '0'; 
  tx_data_latched         <= (others => '0');
  nxt_data                <= '0';
  
  else
    nxt_data <= '0';
  
    case tx_state is

    when init 	=>
      nxt_data <= '1';
      if start_send = '1' then tx_state <= latch_data; end if;
      tx_brdcount   <= clkdiv;
      tx_datacount  <= "000";
      tx 	    <= '1';

    when latch_data =>
      tx_data_latched  <= tx_data;
      tx_state <= start;
      
    when start	 =>
      if tx_brdcount = 0 then
        tx_state      <= data;
        tx_brdcount   <= clkdiv;
      else
         tx_brdcount  <= tx_brdcount - '1';
      end if;
      tx 	      <= '0';
 
    when data	=>
      if (tx_datacount = 7) and (tx_brdcount = 0) then
        tx_state      <= stop;
      end if;
      if tx_brdcount = 0 then
       tx_datacount   <= tx_datacount + 1; -- lsb first
       tx_brdcount    <= clkdiv;
      else
        tx_brdcount   <= tx_brdcount - 1;
      end if;        
      tx 	      <= tx_data_latched(conv_integer(tx_datacount));
 
    when stop 	=>
      if tx_brdcount = 0 then
        tx_state      <= init;
        tx_brdcount   <= clkdiv;
      else
        tx_brdcount   <= tx_brdcount - '1';
      end if;
      tx 	      <= '1';
      
    when others =>      tx_state <= init;  
  
  end case;
 end if;


end process;
end;

