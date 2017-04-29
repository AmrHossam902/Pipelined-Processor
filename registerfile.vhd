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

COMPONENT nregisters IS
	PORT( Clk,rst,wr_enable : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT mux8x1 is
     port(
         x0,x1,x2,x3,x4,x5,x6,x7 : in STD_LOGIC_VECTOR(15 downto 0);
         sel : in STD_LOGIC_VECTOR(2 downto 0);
         y : out STD_LOGIC_VECTOR(15 downto 0)
         );
end COMPONENT;



COMPONENT demux1x8 is
port(data_in: in std_logic_vector(15 downto 0);
dst:in std_logic_vector(2 downto 0);
y0,y1,y2,y3,y4,y5,y6,y7:out std_logic_vector(15 downto 0));
end component;



COMPONENT mux2x1 is
    Port ( SEL : in  STD_LOGIC;
           A,B   : in  STD_LOGIC_VECTOR (15 downto 0);
           Y   : out STD_LOGIC_VECTOR (15 downto 0));
end COMPONENT;

COMPONENT sp_reg IS
	PORT( Clk,rst,wr_enable,sp_enable : IN std_logic;
		  d1 : IN  std_logic_vector(15 DOWNTO 0);
                  d2 : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT pc_reg IS
	PORT( Clk,rst,wr_enable : IN std_logic;
		  d1 : IN  std_logic_vector(15 DOWNTO 0);
                  d2 : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;



signal datatoreg0,datatoreg1,datatoreg2,datatoreg3,datatoreg4,datatoreg5,datatoreg6,datatoreg7: std_logic_vector(15 downto 0);
signal regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7: std_logic_vector(15 downto 0);
signal muxtosp,spout,sptoadd,sptosub: std_logic_vector(15 downto 0);

begin


uu: demux1x8 port map (data_in,dst,datatoreg0,datatoreg1,datatoreg2,datatoreg3,datatoreg4,datatoreg5,datatoreg6,datatoreg7);
u0: nregisters port map (Clk,rst,reg_wr,datatoreg0,regtomux0);
u1: nregisters port map (Clk,rst,reg_wr,datatoreg1,regtomux1);
u2: nregisters port map (Clk,rst,reg_wr,datatoreg2,regtomux2);
u3: nregisters port map (Clk,rst,reg_wr,datatoreg3,regtomux3);
u4: nregisters port map (Clk,rst,reg_wr,datatoreg4,regtomux4);
u5: nregisters port map (Clk,rst,reg_wr,datatoreg5,regtomux5);
u6: sp_reg port map (Clk,rst,reg_wr,sp_enable,muxtosp,datatoreg6,spout);

sptoadd <=spout + "1";
sptosub <=spout - "1";

um: mux2x1 port map (sp_selector,sptoadd,sptosub,muxtosp);
um2: mux2x1 port map (sp_selector,sptoadd,spout,regtomux6);

u7: pc_reg port map (Clk,rst,reg_wr,datatoreg7,pc,regtomux7);

u8: mux8x1 port map(regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7,srcin1,srcout1);
u9: mux8x1 port map(regtomux0,regtomux1,regtomux2,regtomux3,regtomux4,regtomux5,regtomux6,regtomux7,srcin2,srcout2);



end behavioral;
