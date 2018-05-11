----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2018 12:53:21 PM
-- Design Name: 
-- Module Name: Fifo_Controller_Sim - Behavioral
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

entity Fifo_Controller_Sim is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
end Fifo_Controller_Sim;

architecture Behavioral of Fifo_Controller_Sim is
-- signal
signal clk,rst,rd,wr,full,empty  : std_logic;
signal w_addr,r_addr : std_logic_vector((FIFO_DEPTH - 1) downto 0);
--constant
constant T : time := 200 ns;

begin

UUT: entity work.Fifo_Controller(behavioral) port map (clk => clk, rst => rst, rd => rd, wr => wr, full => full, empty => empty,
                               w_addr => w_addr, r_addr => r_addr);

--clock
clock : process
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
-- wr_en
        w : process
            begin
                wait for T;
                wr  <= '1';
                wait for 33 * T;
                wr <= '0';
                wait;
            end process;
     -- rd_en
        r : process
            begin
                wait for 34 * T;
                rd <= '1';
                wait for 33 * T;
                rd <= '0';
                wait;
            end process;

end Behavioral;
