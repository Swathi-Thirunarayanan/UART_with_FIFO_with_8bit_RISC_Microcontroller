----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2018 12:14:56 AM
-- Design Name: 
-- Module Name: Fifo_Controller - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Fifo_Controller_Rx is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
     clk,rst,rd,wr  : in std_logic;
     full,empty     : out std_logic;
     w_addr,r_addr : out std_logic_vector((FIFO_DEPTH - 1) downto 0)
     );     
end Fifo_Controller_Rx;

architecture Behavioral of Fifo_Controller_Rx is
--signals
signal r_addr_reg, r_addr_next : unsigned (FIFO_DEPTH downto 0); -- 0 to 32 (5 downto 0)
signal w_addr_reg, w_addr_next : unsigned (FIFO_DEPTH downto 0); -- 0 to 32 (5 downto 0)
signal full_flag, empty_flag : std_logic;

begin
--process register block
    process(clk, rst)
    begin
        if(rst = '1') then
            w_addr_reg <= (others =>'0');
            r_addr_reg <= (others =>'0');
        elsif(rising_edge(clk)) then 
            w_addr_reg <= w_addr_next;
            r_addr_reg <= r_addr_next;
        end if;
    end process;
    -- write address next state logic 
    w_addr_next <= w_addr_reg + 1 when (wr = '1' and full_flag = '0') else
                   w_addr_reg;
   -- full flag logic
   full_flag <= '1' when (r_addr_reg(FIFO_DEPTH) /= w_addr_reg(FIFO_DEPTH)) and (r_addr_reg(FIFO_DEPTH-1 downto 0) = w_addr_reg(FIFO_DEPTH-1 downto 0)) else
                '0';
   -- write output logic
   w_addr    <= std_logic_vector(w_addr_reg(FIFO_DEPTH - 1 downto 0));
   -- full flag output
   full <= full_flag;
   -- read address next state logic
   r_addr_next <= r_addr_reg + 1 when (rd = '1' and empty_flag = '0') else
                  r_addr_reg;
   -- empty flag logic 
   empty_flag <= '1' when (r_addr_reg = w_addr_reg) else
                 '0';
   -- read port output
   r_addr     <= std_logic_vector(r_addr_reg(FIFO_DEPTH - 1 downto 0));
   -- empty flag output
   empty      <= empty_flag;
end Behavioral;
