----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2018 06:24:53 PM
-- Design Name: 
-- Module Name: UART_Rx - Behavioral
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

entity UART_Rx is
--  Port ( );
port(
     clk,rst,rx : in std_logic; 
     ready      : out std_logic;
     rxdone     : out std_logic;
     rxout      : out std_logic_vector(7 downto 0));
end UART_Rx;

architecture Behavioral of UART_Rx is
--signal
type state_type is (idle, start, data, stop);   -- states
signal state_reg, state_next : state_type;      
signal s_reg, s_next : integer range 0 to 15;   -- ticks = 16
signal n_reg, n_next : integer range 0 to 7;    -- data bits count = 8
signal b_reg, b_next : std_logic_vector( 7 downto 0);    -- data byte buffer containing 8 bits of data
signal s_tick        : std_logic;    -- s_tick from output of baud generator passed as signal into UART_Rx
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
        end if;
    end process;
--next state logic
    process(state_reg, s_reg, n_reg, b_reg, s_tick, rx)
    begin
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        ready  <= '0';
        rxdone <= '0';
        case state_reg is
            -- idle state
            when idle =>
                if(rx = '0') then
                    state_next <= start;
                    s_next     <= 0;
                else
                    state_next <= idle;
                end if;
                ready <= '1';
            -- start state
            when start =>
                if(s_tick = '0') then
                    state_next <= start;
                else
                    if(s_reg = 7) then
                        state_next <= data;
                        s_next     <= 0;
                    else
                        state_next <= start;
                        s_next     <= s_reg + 1;
                    end if;
                end if;
            -- data state 
            when data =>
                if(s_tick = '0') then
                    state_next <= data;
                else
                    if(s_reg = 15) then
                        s_next <= 0;
                        b_next <= rx & b_reg(7 downto 1);
                        if(n_reg = 7) then 
                            state_next <= stop;
                            n_next     <= 0;
                        else
                            state_next <= data;
                            n_next     <= n_reg + 1;
                        end if;
                    else
                        state_next <= data;
                        s_next <= s_reg + 1;
                    end if;
                end if;
            when stop =>
                if(s_tick = '0') then
                    state_next <= stop;
                else
                    if(s_reg = 15) then 
                        state_next <= idle;
                        s_next     <= 0;
                        rxdone     <= '1';   -- Rx done bit
                    else
                        state_next <= stop;
                        s_next     <= s_reg + 1;
                    end if;
                end if;
        end case;
    end process;
    rxout <= b_reg;
end Behavioral;
