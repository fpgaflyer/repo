library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity  digital_filter  is
port (  clk : in std_logic ;
      reset : in std_logic ;
          i : in std_logic ;
          o : out std_logic 
      );
end;



architecture  behaviour  of  digital_filter  is
signal D0   : std_logic;
signal D1   : std_logic;
signal D2   : std_logic;
signal D3   : std_logic;
signal D4   : std_logic;
signal D5   : std_logic;
signal D6   : std_logic;
signal D7   : std_logic;
signal D8   : std_logic;
signal D9   : std_logic;


begin
 process (clk, reset) 
 
     begin
 
      if (reset = '1') then
 	D0 <= '0';      
	D1 <= '0'; 
	D2 <= '0'; 
	D3 <= '0'; 
	D4 <= '0'; 
	D5 <= '0'; 
	D6 <= '0'; 
	D7 <= '0'; 
	D8 <= '0'; 
	D9 <= '0'; 
         o <= '0'; 
            
      elsif (clk'event and clk = '1') then

        D0  <= i;
        D1  <= D0;
        D2  <= D1;
        D3  <= D2;        
        D4  <= D3;
        D5  <= D4;
        D6  <= D5;        
        D7  <= D6;        
        D8  <= D7;
        D9  <= D8;        
   
        if 
          (D0 = '1') and 
          (D1 = '1') and          
          (D2 = '1') and 
          (D3 = '1') and 
          (D4 = '1') and 
          (D5 = '1') and 
          (D6 = '1') and 
          (D7 = '1') and 
          (D8 = '1') and 
          (D9 = '1') 
        then
          o <= '1';
        else
          o <= '0';
        end if;
      
      end if;
 
  end process;
end;








