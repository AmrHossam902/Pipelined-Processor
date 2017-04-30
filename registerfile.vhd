library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity registerfile is
port(
                  Clk,rst,reg_wr,sp_selector,sp_enable : IN std_logic;
		  pc,data_in: IN  std_logic_vector(15 DOWNTO 0);
                  srcin1,srcin2,dst:IN  std_logic_vector(2 DOWNTO 0);
                  srcout1,srcout2:OUT  std_logic_vector(15 DOWNTO 0)             
);
end registerfile;

architecture behavioral of registerfile is


COMPONENT mux8x1 is
     port(
         x0,x1,x2,x3,x4,x5,x6,x7 : in STD_LOGIC_VECTOR(15 downto 0);
         sel : in STD_LOGIC_VECTOR(2 downto 0);
         y : out STD_LOGIC_VECTOR(15 downto 0)
         );
end COMPONENT;





COMPONENT mux2x1 is
    Port ( SEL : in  STD_LOGIC;
           A,B   : in  STD_LOGIC_VECTOR (15 downto 0);
           Y   : out STD_LOGIC_VECTOR (15 downto 0));
end COMPONENT;

component decoder3x8 is
Port ( sel : in STD_LOGIC_VECTOR (2 downto 0);
y : out STD_LOGIC_VECTOR (7 downto 0);
wr_enable :in STD_LOGIC
);
end component;


COMPONENT nregisters IS
	PORT( Clk,rst, enable : IN std_logic;
		  d, rst_value: IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

signal regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7: std_logic_vector(15 downto 0);
signal registersenables : STD_LOGIC_VECTOR (7 downto 0);
signal reset_value : std_logic_vector(15 downto 0);
signal inverse_clk : std_logic;
begin

uu: decoder3x8 port map (dst,registersenables,reg_wr);
reset_value<="0000000000000000";

inverse_Clk <= not Clk;

u0: nregisters port map (inverse_Clk,rst,registersenables(0),data_in,reset_value,regtomux0);
u1: nregisters port map (inverse_Clk,rst,registersenables(1),data_in,reset_value,regtomux1);
u2: nregisters port map (inverse_Clk,rst,registersenables(2),data_in,reset_value,regtomux2);
u3: nregisters port map (inverse_Clk,rst,registersenables(3),data_in,reset_value,regtomux3);
u4: nregisters port map (inverse_Clk,rst,registersenables(4),data_in,reset_value,regtomux4);
u5: nregisters port map (inverse_Clk,rst,registersenables(5),data_in,reset_value,regtomux5);
u6: nregisters port map (inverse_Clk,rst,registersenables(6),data_in,reset_value,regtomux6);

u8: mux8x1 port map(regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,pc,srcin1,srcout1);
u9: mux8x1 port map(regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,pc,srcin2,srcout2);



end behavioral;
