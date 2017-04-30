LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY nregisters IS
	PORT( Clk,rst, enable : IN std_logic;
		  d, rst_value: IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END nregisters;

Architecture nbit_Register_ARC of nregisters is
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
