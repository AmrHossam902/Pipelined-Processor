LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY nregisters IS
	PORT( Clk,rst,wr_enable : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END nregisters;

ARCHITECTURE a_my_reg OF nregisters IS
	BEGIN
		PROCESS (Clk,rst)
			BEGIN
				IF rst = '1' THEN
					q <= (OTHERS=>'0');
				ELSIF wr_enable = '1' AND falling_edge(Clk) THEN
					q <= d;
				END IF;
		END PROCESS;
END a_my_reg;

