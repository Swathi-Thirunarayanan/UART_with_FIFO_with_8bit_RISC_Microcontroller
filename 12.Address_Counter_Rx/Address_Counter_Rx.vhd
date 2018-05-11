----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2018 08:44:30 PM
-- Design Name: 
-- Module Name: Address_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Address_counter_Rx is
--  Port ( );
port(
     clk,rst : in std_logic;
     mem_en,empty: in std_logic;
     rd_uart_rx : in std_logic;
     rxdone        : out std_logic;
     address      : out std_logic_vector(7 downto 0));
end Address_counter_Rx;

architecture Behavioral of Address_counter_Rx is
--signal
 signal cnt_reg,cnt_next : std_logic_vector(7 downto 0);
 signal rx_done_reg,rx_done_next: std_logic;
begin
--processs
   process(clk,rst)
   begin
       if(rst = '1') then
           cnt_reg <= "00000000"; -- decimal 32
           rx_done_reg <= '0';
       elsif(rising_edge(clk)) then
           rx_done_reg  <= rx_done_next;
           if(mem_en ='1' and rd_uart_rx = '1') then         
               if(empty = '0') then
                  cnt_reg <= cnt_next;
               else
                  cnt_reg <= cnt_reg;
               end if;
           end if;
       end if;
   end process;
   address   <=    cnt_reg;
   cnt_next  <=    cnt_reg+1 when (cnt_reg <"00011111") else   --decimal <31
                  (others => '0');          
   rx_done_next <= '1' when (cnt_reg = "00011111" or empty ='1')else
                   '0';
   rxdone  <= rx_done_reg;
end Behavioral;
