----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2018 05:47:05 PM
-- Design Name: 
-- Module Name: Baudgen - Behavioral
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Baudgen is
--  Port ( );
port(
     clk,rst: in std_logic;
     s_tick: out std_logic);
end Baudgen;

architecture Behavioral of Baudgen is 
--signal
signal baud_reg,baud_next : integer range 0 to 162;
begin
    --process block
    process(clk,rst)
    begin
        if(rst = '1') then
            baud_reg <= 0;
        elsif(rising_edge(clk)) then 
            baud_reg <= baud_next;
        end if;      
    end process;
--next state logic
    baud_next <= 0 when baud_reg = 162 else
                 baud_reg + 1;
--output logic
    s_tick <= '1' when baud_reg = 0 else
              '0';
end Behavioral;
