----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2018 04:55:07 PM
-- Design Name: 
-- Module Name: UART_Transmitter - Behavioral
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

entity UART_Transmitter is
--  Port ( );
port( 
      clk,rst,w_uart,r_uart       : in std_logic;
      tx_in                       : in std_logic_vector(7 downto 0);
      tx_out,txdone,full_tx,empty_tx          : out std_logic);
end UART_Transmitter;

architecture Behavioral of UART_Transmitter is
--signals

signal tx_start                            : std_logic;
signal txin_sig                            : std_logic_vector(7 downto 0);
signal txdonesig                           : std_logic;
--components
--Transmitter component
component UART_Tx
--  Port ( );
port(
     clk,rst,tx_start   : in std_logic;
     tx                 : in std_logic_vector(7 downto 0);
     txdone,txout       : out std_logic);    
end component;
-- FIFO component
component Fifo_Tx is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
     clk,rst      : in std_logic;
     fifo_datain  : in std_logic_vector(7 downto 0);
     wr,rd,d_en   : in std_logic;
     full,empty   : out std_logic;
     fifo_dataout : out std_logic_vector(7 downto 0));
end component;

begin

     tx_start <= '1' when r_uart = '1' else
                  '0';

 Fifo_T : Fifo_Tx port map (clk => clk, rst => rst, fifo_datain => tx_in, wr => w_uart, rd => r_uart, full => full_tx, d_en => txdonesig,
                          empty => empty_tx, fifo_dataout => txin_sig); 
 T       : UART_Tx port map (clk => clk, rst => rst, tx_start => tx_start, tx => txin_sig, txdone => txdonesig, txout => tx_out);
  
--output logic
txdone <= txdonesig; 
end Behavioral;
