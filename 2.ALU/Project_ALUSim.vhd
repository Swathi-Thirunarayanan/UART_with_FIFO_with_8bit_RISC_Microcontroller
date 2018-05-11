----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.02.2018 04:45:25
-- Design Name: 
-- Module Name: ALUSIm - Behavioral
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

entity ALUSIm is
--  Port ( );
end ALUSIm;

architecture Behavioral of ALUSIm is

component ALU 
--  Port ( );
port(
    A,B: in std_logic_vector(7 downto 0);
    aluop: in std_logic_vector(1 downto 0);
    result: out std_logic_vector(7 downto 0));
end component;

signal A,B,result : std_logic_vector(7 downto 0);
signal aluop: std_logic_vector(1 downto 0);

begin
UUT : ALU port map(A=>A,B=>B,aluop=>aluop,result=>result);

Sim_proc: process
begin
wait for 100ns;
aluop <= "00";
A <= x"0F";
B <= x"0F";
wait for 100ns;
aluop <= "00";
A <= x"03";
B <= x"02";
wait for 100ns;
aluop <= "01";
A <= x"0F";
B <= x"0F";

wait for 100ns;
aluop <= "01";
A <= x"03";
B <= x"02";

wait for 100ns;
aluop <= "10";
A <= x"83";
B <= x"82";

wait for 100ns;
aluop <= "10";
A <= x"03";
B <= x"02";

wait for 100ns;
aluop <= "11";
A <= x"83";
B <= x"82";

wait for 100ns;
aluop <= "11";
A <= x"82";
B <= x"83";


end process;
end Behavioral;
