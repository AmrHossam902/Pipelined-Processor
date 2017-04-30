LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY nbit_Register IS
  Generic(n: integer := 16);
	PORT( Clk,rst, enable : IN std_logic;
		  d, rst_value: IN  std_logic_vector(n-1 DOWNTO 0);
		  q : OUT std_logic_vector(n-1 DOWNTO 0));
END nbit_Register;

Architecture nbit_Register_ARC of nbit_Register is
begin
	process(clk)
	begin
		if(rising_edge(Clk))then
			if(rst = '1') then
				q <= rst_value;
			elsif(enable = '1') then
				q <= d;
			end if;
		end if;
	end process;
end nbit_Register_ARC;