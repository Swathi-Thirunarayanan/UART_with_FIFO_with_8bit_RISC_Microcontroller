----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2018 11:00:03 AM
-- Design Name: 
-- Module Name: FIFO_buffer - Behavioral
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

entity FIFO_buffer is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
      clk,rst                : in std_logic;
      w_datain               : in std_logic_vector(7 downto 0);
      w_addr,r_addr          : in std_logic_vector((FIFO_DEPTH - 1) downto 0);
      w_en,r_en              : in std_logic;
      r_dataout              : out std_logic_vector(7 downto 0));
end FIFO_buffer;

architecture Behavioral of FIFO_buffer is
-- signals
type buffer_type is array ( 0 to (2 ** FIFO_DEPTH)-1) of std_logic_vector (7 downto 0); -- fifo buffer contains 32 bytes of data
signal Fifo_buffer   : buffer_type; 

begin
-- process register
    process(clk,rst)
    begin
        if(rst = '1') then
            Fifo_buffer <= (others => (others => '0'));
        elsif(rising_edge(clk))then
            if (w_en = '1') then 
            Fifo_buffer(to_integer(unsigned(w_addr))) <= w_datain; 
            end if; 
        end if;
    end process;  
        r_dataout <= Fifo_buffer(to_integer(unsigned(r_addr))) when r_en = '1';       
end Behavioral;
