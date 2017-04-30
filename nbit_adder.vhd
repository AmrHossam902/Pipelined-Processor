LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- n-bit adder
ENTITY nbit_adder IS
       GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            add_out : OUT std_logic_vector(n-1 DOWNTO 0);    
              cout,overflow : OUT std_logic);
END nbit_adder;



ARCHITECTURE nbit_adder_ARC OF nbit_adder IS
      COMPONENT bit_adder IS
        PORT( a,b,cin : IN std_logic; 
                        s,cout : OUT std_logic);
        END COMPONENT;
SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);

BEGIN
  f0: bit_adder PORT MAP(a(0),b(0),cin,add_out(0),temp(0));
  loop1: FOR i IN 1 TO n-1 GENERATE
          fx: bit_adder PORT MAP  (a(i),b(i),
           temp(i-1),add_out(i),temp(i));
    END GENERATE;
    cout <= temp(n-1);
    overflow <= temp(n-2) xor temp(n-1);
END nbit_adder_ARC;

