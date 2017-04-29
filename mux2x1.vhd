library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2x1 is
    Port ( SEL : in  STD_LOGIC;
           A,B   : in  STD_LOGIC_VECTOR (15 downto 0);
           Y   : out STD_LOGIC_VECTOR (15 downto 0));
end mux2x1;

architecture Behavioral of mux2x1 is
begin
   Y <= A when (SEL = '1') else B;
end Behavioral;
