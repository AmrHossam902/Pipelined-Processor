LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- single bit adder
ENTITY bit_adder IS
           PORT( a,b,cin : IN std_logic;
                    s,cout : OUT std_logic); 
END bit_adder;

ARCHITECTURE bit_adder_ARC OF bit_adder IS
BEGIN
     PROCESS (a,b,cin)     
	BEGIN              s <= a XOR b XOR cin;
              cout <= (a AND b) or (cin AND (a XOR b));
     END PROCESS;
END bit_adder_ARC;

