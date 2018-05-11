----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2018 08:34:09 PM
-- Design Name: 
-- Module Name: UART_Receiver - Behavioral
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

entity UART_Receiver is
--  Port ( );
port(
     clk,rst,rxin,rd_uart      : in std_logic;
     empty                     : out std_logic;
     rxout                     : out std_logic_vector(7 downto 0));
end UART_Receiver;

architecture Behavioral of UART_Receiver is
--signals 
signal ready_sig, rxdone_sig  : std_logic;
signal full                   : std_logic;
signal rxout_sig,txin_sig     : std_logic_vector(7 downto 0);
--components
--Receiver component
component UART_Rx
--  Port ( );
port(
     clk,rst,rx : in std_logic; 
     ready      : out std_logic;
     rxdone     : out std_logic;
     rxout      : out std_logic_vector(7 downto 0));
end component;

-- FIFO component
component Fifo_Rx is
--generic
generic (FIFO_DEPTH: integer := 5); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
     clk,rst      : in std_logic;
     fifo_datain  : in std_logic_vector(7 downto 0);
     wr,rd        : in std_logic;
     full,empty   : out std_logic;
     fifo_dataout : out std_logic_vector(7 downto 0));
end component;
begin

R       : UART_Rx port map(clk => clk, rst => rst, rx => rxin, ready => ready_sig, rxdone => rxdone_sig,
                           rxout => rxout_sig); 
Fifo_R : Fifo_Rx port map (clk => clk, rst => rst, fifo_datain => rxout_sig, wr => rxdone_sig, rd => rd_uart,
                         full => full, empty => empty, fifo_dataout => rxout);
end Behavioral;
