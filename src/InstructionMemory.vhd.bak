LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY Ins_Memory IS
 PORT (clk : IN std_logic;
	   address : IN std_logic_vector(9 DOWNTO 0);
	 dataout : OUT std_logic_vector(15 DOWNTO 0) );
END ENTITY Ins_Memory;



ARCHITECTURE Ins_Memory_ARC OF Ins_Memory IS  
TYPE ram_type IS ARRAY(0 TO 1023) of std_logic_vector(15 DOWNTO 0);
     SIGNAL ram : ram_type ;
BEGIN
    dataout <= ram(to_integer(unsigned((address))));
END Ins_Memory_ARC;
