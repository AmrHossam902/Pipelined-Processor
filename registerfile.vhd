library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity registerfile is
port(
          Clk,rst,reg_wr,sp_selector,sp_enable : IN std_logic;
		  pc,data_in: IN  std_logic_vector(15 DOWNTO 0);
          srcin1,srcin2,dst:IN  std_logic_vector(2 DOWNTO 0);
          srcout1,srcout2:OUT  std_logic_vector(15 DOWNTO 0)             
);
end registerfile;

architecture registerfile_ARC of registerfile is


COMPONENT mux8x1 is
     port(
         x0,x1,x2,x3,x4,x5,x6,x7 : in STD_LOGIC_VECTOR(15 downto 0);
         sel : in STD_LOGIC_VECTOR(2 downto 0);
         y : out STD_LOGIC_VECTOR(15 downto 0)
         );
end COMPONENT;


component decoder3x8 is
Port ( sel : in STD_LOGIC_VECTOR (2 downto 0);
y : out STD_LOGIC_VECTOR (7 downto 0);
wr_enable :in STD_LOGIC
);
end component;


COMPONENT nbit_register IS
Generic(n: integer := 16);
	PORT( Clk,rst, enable : IN std_logic;
		  d, rst_value: IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

component nbit_adder IS
       GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            add_out : OUT std_logic_vector(n-1 DOWNTO 0);    
              cout,overflow : OUT std_logic);
END component;


signal regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7: std_logic_vector(15 downto 0);
signal registersenables : STD_LOGIC_VECTOR (7 downto 0);
signal reset_value : std_logic_vector(15 downto 0);
signal inverse_clk : std_logic;

signal sp_Q ,sp_plus_one, sp_minus_one,sp_data: std_logic_vector(15 downto 0);
signal carry1, ov_flow1, carry2, ov_flow2: std_logic;


begin

uu: decoder3x8 port map (dst,registersenables,reg_wr);
reset_value<="0000000000000000";

inverse_Clk <= not Clk;




R0: nbit_register port map (inverse_Clk,rst,registersenables(0),data_in,reset_value,regtomux0);
R1: nbit_register port map (inverse_Clk,rst,registersenables(1),data_in,reset_value,regtomux1);
R2: nbit_register port map (inverse_Clk,rst,registersenables(2),data_in,reset_value,regtomux2);
R3: nbit_register port map (inverse_Clk,rst,registersenables(3),data_in,reset_value,regtomux3);
R4: nbit_register port map (inverse_Clk,rst,registersenables(4),data_in,reset_value,regtomux4);
R5: nbit_register port map (inverse_Clk,rst,registersenables(5),data_in,reset_value,regtomux5);


--stack pointer
incrementer: nbit_adder port map(sp_Q , x"0000", '1' , sp_plus_one, carry1, ov_flow1);
decrementer: nbit_adder port map(sp_Q , x"FFFF", '1' , sp_minus_one, carry2, ov_flow2);
SP: nbit_register port map (inverse_Clk,rst,sp_enable, sp_data,x"FFFF",sp_Q);  --sp

sp_data <= sp_plus_one when sp_selector = '1'
else sp_minus_one;

regtomux6 <= sp_plus_one when sp_selector  = '1'
else sp_Q;

regtomux7 <= pc;

u8: mux8x1 port map(regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7,srcin1,srcout1);
u9: mux8x1 port map(regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7,srcin2,srcout2);



end registerfile_ARC;
