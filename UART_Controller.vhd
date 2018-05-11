----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2018 04:14:08 PM
-- Design Name: 
-- Module Name: UART_Top - Behavioral
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

entity UART_Controller is
--  Port ( );
port(
     clk                                                        : in std_logic;
     M1,M2,M3,M4,rxdone,txdone,empty_tx,empty_rx,full_tx,program_done        : in std_logic;
     result_done                                                : in std_logic;
     fifo_data_in,mem_data_in                                   : in std_logic_vector(7 downto 0);
     fifo_data_out,mem_data_out                                 : out std_logic_vector(7 downto 0);
     stage_db                                                   : out std_logic := '1';
     mem_en,r_en,rd_uart_rx,wr_uart_tx,rd_uart_tx,mem_wr_en,start_prog_tx      : out std_logic);
end UART_Controller;

architecture Behavioral of UART_Controller is

begin
    --process
    process(M1,M2,M3,M4,empty_rx,full_tx,empty_tx,fifo_data_in,mem_data_in,result_done)
    begin
            if(M1 = '1') then
                mem_en <= '1';

                if(empty_rx = '1') then
                   rd_uart_rx <= '0';
                else
                   rd_uart_rx <= '1';
                end if;
                stage_db <= '1';
                r_en     <= '0';
                wr_uart_tx <= '0';
                rd_uart_tx <= '0';
                mem_wr_en  <= '1';
                start_prog_tx <= '0';
                mem_data_out <= fifo_data_in;
            elsif(M2 = '1') then
                 mem_en <= '0';
                 rd_uart_rx <= '0';
                 stage_db <= '0';
                 r_en     <= '0';
                 wr_uart_tx <= '0';
                 rd_uart_tx <= '0';
                 mem_wr_en  <= '0';
                 start_prog_tx <= '0';
            elsif(M3 = '1') then
                start_prog_tx <= '1';    
                r_en       <= '0';
                mem_en     <= '1';               
                stage_db   <= '1';
                mem_wr_en  <= '0';
                if(program_done = '0') then           
                if(full_tx = '0' and empty_tx = '0') then
                    rd_uart_tx <= '1';
                    wr_uart_tx <= '1';  
                elsif(empty_tx = '1') then 
                    wr_uart_tx <= '1';
                    rd_uart_tx <= '0';
                end if; 
                elsif(full_tx = '1') then
                    rd_uart_tx <= '1';
                    wr_uart_tx <= '0';             
                end if;
                start_prog_tx <= '1';
                fifo_data_out   <= mem_data_in ;
            elsif(M4 = '1') then
                r_en       <= '1';
                mem_en     <= '1';  
                stage_db   <= '1';   
                mem_wr_en  <= '1';
                if(full_tx = '1' or result_done = '1') then
                rd_uart_tx <= '1';
                wr_uart_tx <= '0'; 
                r_en <= '0';
                elsif(empty_tx = '1' or result_done = '0') then 
                wr_uart_tx <= '1';
                rd_uart_tx <= '0';
                elsif(full_tx = '0' and empty_tx = '0' and txdone = '1') then
                rd_uart_tx <= '0';
                wr_uart_tx <= '0';
                end if;
                fifo_data_out   <= mem_data_in ;
            end if;
        --end if;
    end process;
   
    
end Behavioral;
