----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2018 01:18:19 AM
-- Design Name: 
-- Module Name: Memory - RAM
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

entity Memory is
--  Port ( );
    port( 
        address: in std_logic_vector(7 downto 0); 
        dataout: in std_logic_vector(7 downto 0); 
        readwrite,mem_wr_en: in std_logic; 
        clk: in std_logic; 
        rst: in std_logic;
        datain: out std_logic_vector(7 downto 0));
end Memory;

architecture RAM of Memory is
   type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);  
   signal ramArray : ram_type;

begin

process(clk,rst,readwrite,mem_wr_en) is
	begin
	   if Rst = '1' then
                -- Clear Memory on Reset
        ramArray <= (others => (others => '0'));
	   else
	   ramArray(128) <= x"02";
	   ramArray(129) <= x"01";
	   ramArray(130) <= x"00";  
	   ramArray(64)  <= x"11";
	  	   if rising_edge(Clk) then 
	           if (readwrite = '1' or mem_wr_en = '1')then		
	               ramArray(to_integer(unsigned(Address))) <= Dataout;
	           end if; 
	      end if;
	   end if;
    end process;
   Datain <= ramArray(to_integer(unsigned(Address)));
end RAM;
