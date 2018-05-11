----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2018 07:34:12 PM
-- Design Name: 
-- Module Name: UART_Rx_Sim - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_Rx_Sim is
--  Port ( );
end UART_Rx_Sim;

architecture Behavioral of UART_Rx_Sim is
--signal
signal clk,rst,rxin,rd_uart     : std_logic;
signal rxout                    : std_logic_vector(7 downto 0);
--constant
constant T : time := 200 ns;
begin
--port map
UUT: entity work.UART_Receiver(behavioral) port map(clk => clk, rst => rst, rxin => rxin, rd_uart => rd_uart,
                                                    rxout => rxout);
--clock
clock:process
  begin
    clk <= '1';
	wait for T/2;
	clk <= '0';
	wait for T/2;
  end process;
--reset
reset : process
  begin
    rst <= '1';
	wait for T;
	rst <= '0';
	wait;
  end process;
  
-- read_enable
 rd: process
    begin
        wait for (2 * 156 * 163 * 16 * T);
        rd_uart <= '1';
        wait;
    end process;
    
--data bits
data  : process
    begin
      for i in 0 to 32 loop
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        wait for (163 * 8 * T);
        
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '1';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        rxin <= '0';
        wait for (163 * 16 * T);
        wait for (163 * 8 * T);
     end loop;
    end process;
end Behavioral;
