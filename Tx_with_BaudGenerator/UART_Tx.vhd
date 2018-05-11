----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2018 12:02:15 PM
-- Design Name: 
-- Module Name: UART_Tx - Behavioral
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

entity UART_Tx is
--  Port ( );
port(
     clk,rst,tx_start        : in std_logic;
     tx                      : in std_logic_vector(7 downto 0);
     txdone,txout            : out std_logic);    
end UART_Tx;

architecture Behavioral of UART_Tx is
--signal
type state_type is (idle, start, data, stop);   -- states
signal state_reg, state_next : state_type;      
signal s_reg, s_next  : integer range 0 to 15;   -- ticks = 16
signal n_reg, n_next  : integer range 0 to 7;    -- data bits count = 8
signal b_reg, b_next  : std_logic_vector( 7 downto 0);    -- data byte buffer containing 8 bits of data (input)
signal tx_reg, tx_next: std_logic;    -- bit-wise UART output 
signal s_tick         : std_logic;    -- s_tick from output of baud generator passed as signal into UART_Rx
signal txdonesig      : std_logic;
--component Baud Generator
component Baudgen is
--  Port ( );
port(
     clk,rst: in std_logic;
     s_tick: out std_logic);
end component;
begin
--mod 163 Baud Generator [Calculated from System Clock 50MHz, Baud rate 19200 and number of ticks 16 (50M/(16*19200) = 163)] 
B: Baudgen port map (clk => clk, rst => rst, s_tick => s_tick);
--process FSMD state and data registers
    process(clk,rst)
    begin
        if(rst = '1') then
            state_reg <= idle;
            s_reg     <= 0;
            n_reg     <= 0;
            b_reg     <= (others => '0');
           
        elsif(rising_edge(clk)) then
            state_reg <= state_next;
            s_reg     <= s_next;
            n_reg     <= n_next;
            b_reg     <= b_next;
            tx_reg    <= tx_next;
            
        end if;
    end process;
    --next state logic
    process(state_reg, s_reg, n_reg, b_reg, s_tick, tx_reg, tx_start,tx)
    begin
    state_next <= state_reg;
    s_next <= s_reg;
    n_next <= n_reg;
    b_next <= b_reg;
    tx_next<= tx_reg;      
    txdonesig <= '0';
   
    case state_reg is
       -- idle state
        when idle =>
            tx_next   <= '1';
            
            if(tx_start = '1') then
                state_next <= start;
                s_next     <= 0;
                b_next     <= tx;
            else
                state_next <= idle;
            end if;
        --start state
        when start =>
            tx_next   <= '0';
            
            if(s_tick = '0') then
                state_next <= start;
            else
                if(s_reg = 15) then
                    state_next <= data;
                    s_next     <= 0;
                    n_next     <= 0;
                else
                    state_next <= start;
                    s_next     <= s_reg + 1;
                end if;
            end if;
        -- data state
        when data =>
            tx_next <= b_reg(0);
            
            if(s_tick = '0') then
                state_next <= data;
            else
                if(s_reg = 15) then
                    s_next <= 0;
                    b_next <= '0' & b_reg(7 downto 1);
                    if(n_reg = 7) then 
                        state_next <= stop;
                        n_next     <= 0;
                    else
                        state_next <= data;
                        n_next     <= n_reg + 1;
                    end if;
                else
                    s_next <= s_reg + 1;
                end if;
            end if;
        -- stop state
        when stop =>
            tx_next      <= '1';
            
            if(s_tick = '0') then
                state_next <= stop;
            else
                if(s_reg = 15) then 
                    state_next <= idle;
                    s_next     <= 0;
                    txdonesig     <= '1';   -- Tx done bit
                    
                else
                    state_next <= stop;
                    s_next     <= s_reg + 1;
                    end if;
                end if;
        end case;
    end process;
    
    -- output logic
    txout <= tx_reg; 
    txdone <= txdonesig;                                                       
end Behavioral;
