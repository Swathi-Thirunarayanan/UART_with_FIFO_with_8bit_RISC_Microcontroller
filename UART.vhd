----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2018 06:39:33 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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

entity UART is
--  Port ( );
port(
     clk,rst,data_in,M1,M2,M3,M4   : in std_logic;
     data_out,txdone,rxdone        : out std_logic);
end UART;

architecture Behavioral of UART is
--component
-- Transmitter component along with baud generator and Transmitter FIFO
component UART_Transmitter is
--  Port ( );
port( 
      clk,rst,w_uart,r_uart       : in std_logic;
      tx_in                       : in std_logic_vector(7 downto 0);
      tx_out,txdone,full_tx,empty_tx    : out std_logic);
end component;

-- Receiver component along with baud generator and Receiver FIFO
component UART_Receiver is
--  Port ( );
port(
     clk,rst,rxin,rd_uart      : in std_logic;
     empty,rxdone                  : out std_logic;
     rxout                     : out std_logic_vector(7 downto 0));
end component;

-- Microcontroller
component Microcontroller is
--  Port ( );
port(
      main_clock : in std_logic;
      main_reset,start_prog_tx : in std_logic;
      data       : in std_logic_vector(7 downto 0);
      empty,full      : in std_logic;
      stage_db,mem_en,r_en,mem_wr_en,rd_uart_rx,wr_uart_tx   : in std_logic;    
      pc_sel,pc_load,ir_load,im_load,read_write,d_write,zer,neg,txdone,rxdone,result_done,program_done :out std_logic;
      addr_sel,reg_sel,dreg_sel,sreg_sel,stages : out std_logic_vector(1 downto 0);
      alu_op : out std_logic_vector(1 downto 0);
      alu_out,regi0,regi1,regi2,regi3,pc_out,data_in,s_bus,d_bus,ir_out,im_out    : out std_logic_vector(7 downto 0));
end component;

-- UART Controller
component UART_Controller is
--  Port ( );
port(
     clk                                                        : in std_logic;
     M1,M2,M3,M4,rxdone,txdone,empty_tx,empty_rx,full_tx,result_done,program_done    : in std_logic;
     fifo_data_in,mem_data_in                                   : in std_logic_vector(7 downto 0);
     fifo_data_out,mem_data_out                                 : out std_logic_vector(7 downto 0);
     stage_db,mem_en,r_en,rd_uart_rx,wr_uart_tx,rd_uart_tx,mem_wr_en,start_prog_tx      : out std_logic);
end component;

--signals
signal done_sig, stage_db,mem_en,r_en,rd_uart_rx,wr_uart_tx,rd_uart_tx,mem_wr_en,rxdone_sig,tx_donesig,full_tx,empty_tx,txdonesig : std_logic;
signal rxout_sig, fifo_in   : std_logic_vector(7 downto 0);
signal pc_sel,pc_load,ir_load,im_load,read_write,d_write,zer,neg,empty_rx,start_prog_tx,result_done,program_done : std_logic;
signal addr_sel,reg_sel,dreg_sel,sreg_sel,stages,alu_op :  std_logic_vector(1 downto 0);
signal alu_out,regi0,regi1,regi2,regi3,pc_out,data_in_sig,s_bus,d_bus,ir_out,im_out,fifo_out,data : std_logic_vector(7 downto 0);
begin

R   : UART_Receiver port map(clk => clk, rst => rst, rxin => data_in, rd_uart => rd_uart_rx,empty => empty_rx, rxout => rxout_sig,rxdone => rxdone_sig);
Con : UART_Controller port map(clk=>clk, M1 => M1, M2 => M2, M3 => M3, M4 => M4, result_done => result_done,program_done => program_done, rxdone => rxdone_sig,txdone => txdonesig,empty_tx => empty_tx, empty_rx => empty_rx,full_tx => full_tx,
                               fifo_data_in => rxout_sig, mem_data_in => data_in_sig,start_prog_tx => start_prog_tx, 
                               fifo_data_out => fifo_in, mem_data_out => data, stage_db => stage_db, mem_en => mem_en, r_en => r_en,
                               rd_uart_rx => rd_uart_rx, wr_uart_tx => wr_uart_tx, rd_uart_tx => rd_uart_tx,mem_wr_en => mem_wr_en);
T   : UART_Transmitter port map (clk => clk, rst => rst, w_uart => wr_uart_tx, r_uart => rd_uart_tx,
                                 tx_in => fifo_in, tx_out => data_out, txdone => txdone,full_tx => full_tx, empty_tx => empty_tx);  
M   : Microcontroller port map (main_clock => clk, main_reset => rst, empty => empty_rx, full => full_tx, wr_uart_tx => wr_uart_tx, pc_sel => pc_sel,pc_load => pc_load, data => data,rd_uart_rx => rd_uart_rx,
                                stage_db => stage_db, mem_en => mem_en, r_en => r_en, mem_wr_en => mem_wr_en, 
                                ir_load => ir_load, im_load => im_load, read_write => read_write,rxdone => rxdone_sig,txdone => tx_donesig, 
                                d_write => d_write, zer => zer, neg => neg, addr_sel => addr_sel, start_prog_tx => start_prog_tx,
                                reg_sel => reg_sel, dreg_sel => dreg_sel, sreg_sel => sreg_sel, stages => stages,
                                alu_op => alu_op, alu_out => alu_out, regi0 => regi0, regi1 => regi1, 
                                regi2 => regi2, regi3 => regi3, pc_out => pc_out, data_in => data_in_sig,
                                s_bus => s_bus, d_bus => d_bus, ir_out => ir_out, im_out => im_out,result_done => result_done,program_done => program_done);

txdone <= txdonesig;                                 

end Behavioral;
