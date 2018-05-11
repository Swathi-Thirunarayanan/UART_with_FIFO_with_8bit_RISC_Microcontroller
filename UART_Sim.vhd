----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2018 12:31:55 AM
-- Design Name: 
-- Module Name: UART_Sim - Behavioral
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

entity UART_Sim is
--  Port ( );
end UART_Sim;

architecture Behavioral of UART_Sim is
signal clk,rst,data_in : std_logic;
signal M1,M2,M3,M4 : std_logic:= '0';
signal     data_out,txdone               :  std_logic;
--constant
constant T : time := 200 ns;
begin
UUT: entity work.UART(Behavioral) port map (clk => clk, rst => rst, data_in => data_in, M1 => M1, M2 => M2, M3 => M3, M4 => M4, data_out => data_out,txdone => txdone); 

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
 
 --mode
 mode: process
 begin
 wait for T;
 wait for (19 * 163 * 16 * T);
 M1 <= '1';
 M2 <= '0';
 M3 <= '0';
 M4 <= '0';
 wait for (19 * 163 * 16 * T);
 M2 <= '1';
 M1 <= '0';
 M3 <= '0';
 M4 <= '0';
 wait for (55*T);
 M3 <= '1';
 M2 <= '0';
 M1 <= '0';
 M4 <= '0';
 wait for (834505 * T);
 M1 <= '0';
  M2 <= '0';
  M3 <= '0';
  M4 <= '1';
  wait for (26080 * T);
  end process;
--data bits
data  : process
  begin
        wait for T;
        wait until falling_edge(clk);
    for i in 0 to 32 loop  --d1
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        wait for (163 * 8 * T);
                                 --e3
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '1';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        data_in <= '0';
        wait for (163 * 16 * T);
        wait for (163 * 8 * T);
        wait;
   end loop;
  end process;
end Behavioral;
