LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

Entity FSM is
	port(global_int, clk, rst: in std_logic;
		int, buffer_rst, dft_bar: out std_logic);
end FSM;


Architecture FSM_ARC of FSM is
	
type state is(dft, count, send_int);
signal current_state: state;

component nbit_Register IS
  Generic(n: integer := 2);
	PORT( Clk,rst, enable : IN std_logic;
		  d, rst_value: IN  std_logic_vector(n-1 DOWNTO 0);
		  q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component nbit_adder IS
       GENERIC (n : integer := 2);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            add_out : OUT std_logic_vector(n-1 DOWNTO 0);    
              cout,overflow : OUT std_logic);
END component;

signal counter_Q, counter_D: std_logic_vector(1 downto 0);
signal carry, oflw, c_enable: std_logic;
begin
	
	counter: nbit_Register port map(clk, rst, c_enable, counter_D, "00", counter_Q);
    count_inc: nbit_adder port map(counter_Q, "00", '1', counter_D ,carry, oflw);
	
	process (clk)
	begin
		if(rising_edge(clk) and rst = '1') then
			current_state <= dft;
		elsif(rising_edge(clk)) then
			if(current_state = dft and global_int ='1') then 
				current_state <= count;
			elsif(current_state = count and counter_Q = "10") then
				current_state <= send_int;
			elsif(current_state = send_int) then
				current_state <= dft;
			end if;
		end if;
	end process;
	
	
	process (current_state)
	begin
		if(current_state = dft) then
			int <= '0';
			buffer_rst <= '0';
			dft_bar <='0';
			c_enable <= '0';
		elsif(current_state = count) then
			int <= '0';
			buffer_rst <= '1';
			dft_bar <='1';
			c_enable <= '1';
		else
			int <= '1';
			buffer_rst <= '0';
			dft_bar <='1';
			c_enable <= '1';
		end if;
	end process;
end FSM_ARC;