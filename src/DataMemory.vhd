LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY DataMemory IS
 PORT (clk : IN std_logic;
       write_en, Read_en , rst: IN std_logic;
	   address : IN std_logic_vector(9 DOWNTO 0);
	 datain   : IN std_logic_vector(15 DOWNTO 0);
	 dataout : OUT std_logic_vector(15 DOWNTO 0);
	 mem_of_0, mem_of_1: out std_logic_vector(15 downto 0));
END DataMemory;



ARCHITECTURE DataMemory_ARC OF DataMemory IS  
TYPE ram_type IS ARRAY(0 TO 1023) of std_logic_vector(15 DOWNTO 0);
     SIGNAL ram : ram_type ;
BEGIN
PROCESS(clk) IS  
BEGIN
	IF rst = '1' then
			ram <= ((others=> (others=>'0')));
    elsif rising_edge(clk) THEN   
          IF write_en = '1' THEN        	
			ram(to_integer(unsigned((address)))) <= datain;  
          END IF;
   END IF;
END PROCESS;
        dataout <= ram(to_integer(unsigned((address)))) when Read_en = '1'
		else x"0000";
		
		mem_of_0 <= ram(0);
		mem_of_1 <= ram(1);
		
END DataMemory_ARC;
