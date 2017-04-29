LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY sp_reg IS
	PORT( Clk,rst,wr_enable,sp_enable : IN std_logic;
		  d1 : IN  std_logic_vector(15 DOWNTO 0);
                  d2 : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END sp_reg;

ARCHITECTURE a_my_reg OF sp_reg IS
	BEGIN
		PROCESS (Clk,rst)
			BEGIN
				IF rst = '1' THEN
					q <= (OTHERS=>'0');
				ELSIF sp_enable = '1' AND rising_edge(Clk) THEN
					q <= d1;
                                ELSIF wr_enable = '1' AND rising_edge(Clk) THEN
                                        q <= d2;
				END IF;
		END PROCESS;
END a_my_reg;

