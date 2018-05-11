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
signal clk,rst,rx,ready,rxdone : std_logic;
signal rxout            : std_logic_vector(7 downto 0);
--constant
constant T : time := 200 ns;
begin
--port map
UUT: entity work.UART_Rx(behavioral) port map(clk => clk, rst => rst, rx => rx, ready => ready, rxout => rxout, rxdone => rxdone);
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
--data bits
data  : process
    begin
        rx <= '0';
        wait for (163 * 16 * T);
        rx <= '1';
        wait for (163 * 16 * T);
        rx <= '0';
        wait for (163 * 16 * T);
        rx <= '0';
        wait for (163 * 16 * T);
        rx <= '0';
        wait for (163 * 16 * T);
        rx <= '1';
        wait for (163 * 16 * T);
        rx <= '0';
        wait for (163 * 16 * T);
        rx <= '1';
        wait for (163 * 16 * T);
        rx <= '1';
        wait for (163 * 16 * T);
        wait for (163 * 8 * T);
    end process;
end Behavioral;
