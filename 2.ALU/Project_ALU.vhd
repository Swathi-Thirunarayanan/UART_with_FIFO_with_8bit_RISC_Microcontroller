--Library initialisation 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--entity ALU is declared 
entity AL is                                      
port( 
        A: in std_logic_vector(7 downto 0);        --16 bit operand 1 as in port
        B: in std_logic_vector(7 downto 0);        --16 bit operand 2 as in port 
        aluop: in std_logic_vector(1 downto 0);            -- 4 bit operator as in port
        result: out std_logic_vector(7 downto 0));            --16 bit result as out port         
end AL;

--begin architecture
architecture Behavioral of AL is

begin

--operand1,operand2,operator are in sensitive list of process
process(A,B,aluop)

--variable temp of integer type is declared
variable temp1:signed(A'length downto 0);
variable temp2:signed(B'length downto 0);
variable tempr:signed(result'length downto 0);
variable res: integer;
begin

--switch case starts with operator as selection parameter

case aluop is

when "00" =>    --addit
result <= A and B;

when "01" =>
result <= A or B;

when "10" =>
res := to_integer(signed(A)) + to_integer(signed(B));
result <= std_logic_vector(to_signed(res,8));

when "11" =>
temp1 := resize(signed(A),temp1'length);
temp2 := resize(signed(B),temp2'length);
tempr := temp1 - temp2;
result <= std_logic_vector(resize(signed(tempr),result'length));


when others =>
result <= A;

end case;
end process;
end Behavioral;
