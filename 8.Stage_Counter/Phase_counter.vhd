----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2018 08:46:43 PM
-- Design Name: 
-- Module Name: phase_counter - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity phase_counter is
--  Port ();
port ( 
      clk: in std_logic; 
      rst: in std_logic; 
      stage_db : in std_logic;
      stage: out std_logic_vector(1 downto 0)); 
end phase_counter;

architecture Behavioral of phase_counter is
signal cnt_reg, cnt_next, tmp : std_logic_vector(1 downto 0);
signal resetsig : std_logic;
begin
  process(clk,rst)
	begin
	    if(rst ='1')then
		    cnt_reg <= "11";
		else if(rising_edge(clk)) then
		    cnt_reg <= cnt_next;
		end if;
	end if;
	end process;
     tmp <= "00" when (cnt_reg = "11" or stage_db = '1') else
            cnt_reg;
     cnt_next <= cnt_reg + 1 when (cnt_reg < "10" and stage_db = '0') else
                 "00";
	 stage <= tmp;
end Behavioral;
