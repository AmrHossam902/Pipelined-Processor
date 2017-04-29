library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity demux1x8 is
port(data_in: in std_logic_vector(15 downto 0);
dst:in std_logic_vector(2 downto 0);
y0,y1,y2,y3,y4,y5,y6,y7:out std_logic_vector(15 downto 0));
end demux1x8;

architecture behavioral of demux1x8 is
begin
y0<=data_in when dst="000" else (others => '0');
y1<=data_in when dst="001" else (others => '0');
y2<=data_in when dst="010" else (others => '0');
y3<=data_in when dst="011" else (others => '0');
y4<=data_in when dst="100" else (others => '0');
y5<=data_in when dst="101" else (others => '0');
y6<=data_in when dst="110" else (others => '0');
y7<=data_in when dst="111" else (others => '0');

end behavioral;
