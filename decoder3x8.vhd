library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder3x8 is
Port ( sel : in STD_LOGIC_VECTOR (2 downto 0);
y : out STD_LOGIC_VECTOR (7 downto 0);
wr_enable :in STD_LOGIC
);
end decoder3x8;

architecture Behavioral of decoder3x8 is
BEGIN
process (sel , wr_enable)
begin
if wr_enable = '1' then
if sel = "000" then y <="00000001";
elsif sel = "001" then y <="00000010";
elsif sel = "010" then y <="00000100";
elsif sel = "011" then y <="00001000";
elsif sel = "100" then y <="00010000";
elsif sel = "101" then y <="00100000";
elsif sel = "110" then y <="01000000";
elsif sel = "111" then y <="10000000";
end if;
elsif wr_enable='0' then y<="00000000";
end if;
end process; 
end Behavioral;
