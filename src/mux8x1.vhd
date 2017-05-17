library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux8x1 is
     port(
         x0,x1,x2,x3,x4,x5,x6,x7 : in STD_LOGIC_VECTOR(15 downto 0);
         sel : in STD_LOGIC_VECTOR(2 downto 0);
         y : out STD_LOGIC_VECTOR(15 downto 0)
         );
end mux8x1;

architecture multiplexer8_1_arc of mux8x1 is
begin
   
    y <= x0 when (sel="000") else
            x1 when (sel="001") else
            x2 when (sel="010") else
            x3 when (sel="011") else
            x4 when (sel="100") else
            x5 when (sel="101") else
            x6 when (sel="110") else
            x7;

end multiplexer8_1_arc;
