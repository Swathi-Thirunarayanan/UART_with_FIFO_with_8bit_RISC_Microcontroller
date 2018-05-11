----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2018 05:03:16 PM
-- Design Name: 
-- Module Name: Baudgen_Sim - Behavioral
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

entity Baudgen_Sim is
--  Port ( );
end Baudgen_Sim;

architecture Behavioral of Baudgen_Sim is
signal clk,rst,s_tick : std_logic;
begin
p0: entity work.Baudgen(Behavioral) port map(clk => clk, rst => rst, s_tick => s_tick); 
clock:process
  begin
    clk <= '1';
	wait for 100 ns;
	clk <= '0';
	wait for 100 ns;
 end process;
 
 stimulus : process
  begin
    rst <= '1';
	wait for 200 ns;
	rst <= '0';
	wait;
	end process;


end Behavioral;
