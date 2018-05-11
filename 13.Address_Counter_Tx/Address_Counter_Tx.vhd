----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2018 04:58:12 PM
-- Design Name: 
-- Module Name: Address_counter_Tx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Address_counter_Tx is
--  Port ( );
port(
     clk,rst : in std_logic;
     mem_en,r_en,full: in std_logic;
     wr_uart_tx: in std_logic;
     txdone,program_done,result_done    : out std_logic:= '0';
     address      : out std_logic_vector(7 downto 0));
end Address_counter_Tx;

architecture Behavioral of Address_counter_Tx is
signal tx_done_reg,tx_done_next,result_done_reg,result_done_next  : std_logic;
signal cnt_reg,cnt_next,temp,addresssig : std_logic_vector(7 downto 0);
begin
--processs
   process(clk,rst)
   begin
       if(rst = '1') then
           cnt_reg <= "00000000"; 
           tx_done_reg <= '0';
           result_done_reg <= '0';
       elsif(rising_edge(clk)) then
           tx_done_reg  <= tx_done_next;
           result_done_reg <= result_done_next;
           if(mem_en ='1' and wr_uart_tx ='1') then
               if(r_en = '0') then      
                      cnt_reg <= cnt_next;
               end if;
           end if;
       end if;
   end process;
   temp   <=    cnt_reg;
   cnt_next  <= cnt_reg+1 when (cnt_reg <"00011111") else   --decimal <31
                (others => '0');  
   addresssig <=  x"40" when (r_en = '1') else
               temp when (full = '0' and wr_uart_tx = '1')  else
               "00011111";       
  address <= addresssig;
   tx_done_next <= '1' when (cnt_reg = "00011111" or cnt_reg = "01000000") else
                   '0';
   program_done <= '1' when (full = '1' and r_en = '0');
   result_done_next  <= '1' when (r_en = '1' and addresssig = x"40"); 
   result_done <= result_done_reg;
   txdone  <= tx_done_reg;
end Behavioral;