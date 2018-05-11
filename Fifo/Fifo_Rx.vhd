----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2018 11:41:29 AM
-- Design Name: 
-- Module Name: Fifo - Behavioral
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

entity Fifo_Rx is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
     clk,rst      : in std_logic;
     fifo_datain  : in std_logic_vector(7 downto 0);
     wr,rd        : in std_logic;
     full,empty   : out std_logic;
     fifo_dataout : out std_logic_vector(7 downto 0));
end Fifo_Rx;

architecture Behavioral of Fifo_Rx is
-- signals
signal w_addr_sig,r_addr_sig                                       : std_logic_vector((FIFO_DEPTH - 1) downto 0);
signal w_en_sig, r_en_sig, full_sig, empty_sig, rd_sig, wr_sig     : std_logic;
-- components
-- Fifo controller
component Fifo_Controller_Rx is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
     clk,rst,rd,wr  : in std_logic;
     full,empty          : out std_logic;
     w_addr,r_addr       : out std_logic_vector((FIFO_DEPTH - 1) downto 0)
     );     
end component;
-- fifo buffer
component FIFO_buffer is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
      clk,rst                : in std_logic;
      w_datain               : in std_logic_vector(7 downto 0);
      w_addr,r_addr          : in std_logic_vector((FIFO_DEPTH - 1) downto 0);
      w_en,r_en              : in std_logic;
      r_dataout              : out std_logic_vector(7 downto 0));
end component;

begin

    C : Fifo_Controller_Rx port map (clk => clk, rst => rst, rd => rd, wr => wr, full => full_sig, empty => empty_sig,
                                  w_addr => w_addr_sig, r_addr => r_addr_sig);
          
    B : FIFO_buffer port map (clk => clk, rst => rst, w_datain => fifo_datain, w_addr => w_addr_sig,
                              r_addr => r_addr_sig, w_en => w_en_sig, r_en => r_en_sig, r_dataout => fifo_dataout);
    -- r_en
    r_en_sig <= '1' when (rd_sig = '1' and empty_sig = '0') else
                '0'; 
    -- w_en
    w_en_sig <= '1' when (wr_sig = '1' and full_sig = '0') else
                '0';
    -- output logic
    full  <= full_sig;
    empty <= empty_sig;
    rd_sig    <= rd;
    wr_sig    <= wr; 
end Behavioral;
