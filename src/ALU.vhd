LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


Entity ALU is
	port( OPCODE: in std_logic_vector(4 downto 0);
	A,B : IN std_logic_vector(15 downto 0);
	ALU_flags_out: out std_logic_vector(3 downto 0);    -- V: overflow,  N: negative,  Z: zero C: carry,  
	ALU_flags_in: in std_logic_vector(3 downto 0);
	ALU_OUT: out std_logic_vector(15 downto 0));
end ALU;


--Entity ALU is
--	port(ADD_SIG, ADC_SIG, SUB_SIG, SBC_SIG: in std_logic;
--	 INC_SIG, DEC_SIG, AND_SIG, OR_SIG, XOR_SIG: in std_logic;
--	 CLR_SIG, INV_SIG, LSR_SIG, ROR_SIG ,RRC_SIG, ASR_SIG: in std_logic;
--	LSL_SIG, ROL_SIG, RLC_SIG, JSR_SIG, carry_in: in std_logic;
--	A,B: in std_logic_vector(15 downto 0);
--	carry_out_flag, zero_flag, overflow_flag, sign_flag: out std_logic;
--	ALU_OUT: out std_logic_vector(15 downto 0));
--end ALU;
--JSR_SIG is used for anding 0x07ff with B

Architecture ALU_ARC of ALU is

CONSTANT ADD_CODE :std_logic_vector(4 downto 0)  := "00001";
CONSTANT SUB_CODE :std_logic_vector(4 downto 0)  := "00010";
CONSTANT AND_CODE :std_logic_vector(4 downto 0)  := "00011";
CONSTANT OR_CODE :std_logic_vector(4 downto 0)  := "00100";
CONSTANT RLC_CODE :std_logic_vector(4 downto 0)  := "00101";
CONSTANT RRC_CODE :std_logic_vector(4 downto 0)  := "00110";
CONSTANT SHL_CODE :std_logic_vector(4 downto 0)  := "00111";
CONSTANT SHR_CODE :std_logic_vector(4 downto 0)  := "01010";
CONSTANT SETC_CODE :std_logic_vector(4 downto 0)  := "01011";
CONSTANT CLRC_CODE :std_logic_vector(4 downto 0)  := "01100";
CONSTANT NOT_CODE :std_logic_vector(4 downto 0)  := "01101";
CONSTANT NEG_CODE :std_logic_vector(4 downto 0)  := "01110";
CONSTANT INC_CODE :std_logic_vector(4 downto 0)  := "01111";
CONSTANT DEC_CODE :std_logic_vector(4 downto 0)  := "10000";
CONSTANT CALL_CODE :std_logic_vector(4 downto 0)  := "10001";
CONSTANT JZ_CODE :std_logic_vector(4 downto 0)  := "10010";
CONSTANT JC_CODE :std_logic_vector(4 downto 0)  := "10011";
CONSTANT JN_CODE :std_logic_vector(4 downto 0)  := "10100";
------------------------------------------------------------------------
-- true till here

component nbit_adder IS
GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            add_out : OUT std_logic_vector(n-1 DOWNTO 0);    
              cout, overflow : OUT std_logic);
end component;



signal adder_cin: std_logic;     --selects value of carry to be used in Adder
signal ALU_in1: std_logic_vector(15 downto 0);
signal ALU_in2: std_logic_vector(15 downto 0);
signal adder_out : std_logic_vector(15 downto 0);  -- data comming out of the adder module
signal A_bar : std_logic_vector(15 downto 0);
signal adder_cout: std_logic;
signal adder_overflow: std_logic;
signal alu_out_local: std_logic_vector(15 downto 0);
-- true till here



begin

A_bar <= not A;

adder_cin <= '1'  when OPCODE = CALL_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE = INC_CODE OR OPCODE = DEC_CODE
	else '0';

ALU_in1 <= A  when OPCODE = ADD_CODE OR OPCODE = INC_CODE OR OPCODE = DEC_CODE
	else A_bar when OPCODE = SUB_CODE OR OPCODE = NEG_CODE
	else (others => '0');

ALU_in2 <= B when OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = CALL_CODE
	else (others => '0');


--------------------------------------------------------------------------------------------------------------------------	
-----------------------------------------------calculating ALU_OUT--------------------------------------------------------
alu_out_local<= adder_out when OPCODE = ADD_CODE OR OPCODE = CALL_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE = INC_CODE OR OPCODE = DEC_CODE
	else 	A and B            				 when OPCODE = AND_CODE
	else    A OR B             				 when OPCODE = OR_CODE
	else	ALU_flags_in(1)&A(15 downto 1)   when OPCODE = RRC_CODE
	else	A(14 downto 0)& ALU_flags_in(1)  when OPCODE = RLC_CODE
	
	--shift left 
	else	A(14 downto 0)&'0'				 when OPCODE = SHL_CODE and B(3 downto 0) = "0001"
	else	A(13 downto 0)&"00"				 when OPCODE = SHL_CODE and B(3 downto 0) = "0010"
	else	A(12 downto 0)&"000"			 when OPCODE = SHL_CODE and B(3 downto 0) = "0011"
	else	A(11 downto 0)&"0000"		     when OPCODE = SHL_CODE and B(3 downto 0) = "0100"
	else	A(10 downto 0)&"00000"			 when OPCODE = SHL_CODE and B(3 downto 0) = "0101"
	else	A(9 downto 0)&"000000"			 when OPCODE = SHL_CODE and B(3 downto 0) = "0110"
	else	A(8 downto 0)&"0000000"			 when OPCODE = SHL_CODE and B(3 downto 0) = "0111"
	else	A(7 downto 0)&"00000000"		 when OPCODE = SHL_CODE and B(3 downto 0) = "1000"
	else	A(6 downto 0)&"000000000"		 when OPCODE = SHL_CODE and B(3 downto 0) = "1001"
	else	A(5 downto 0)&"0000000000"		 when OPCODE = SHL_CODE and B(3 downto 0) = "1010"
	else	A(4 downto 0)&"00000000000"		 when OPCODE = SHL_CODE and B(3 downto 0) = "1011"
	else	A(3 downto 0)&"000000000000"	 when OPCODE = SHL_CODE and B(3 downto 0) = "1100"
	else	A(2 downto 0)&"0000000000000"	 when OPCODE = SHL_CODE and B(3 downto 0) = "1101"
	else	A(1 downto 0)&"00000000000000"	 when OPCODE = SHL_CODE and B(3 downto 0) = "1110"
	else	A                    			 when (OPCODE = SHR_CODE OR OPCODE = SHL_CODE ) and B(3 downto 0) = "0000" 
	
	--shift right
	else	'0'&A(15 downto 1)				 when OPCODE = SHR_CODE and B(3 downto 0) = "0001"
	else	"00"&A(15 downto 2)				 when OPCODE = SHR_CODE and B(3 downto 0) = "0010"
	else	"000"&A(15 downto 3)		     when OPCODE = SHR_CODE and B(3 downto 0) = "0011"
	else	"0000"&A(15 downto 4)			 when OPCODE = SHR_CODE and B(3 downto 0) = "0100"
	else	"00000"&A(15 downto 5)			 when OPCODE = SHR_CODE and B(3 downto 0) = "0101"
	else	"000000"&A(15 downto 6)			 when OPCODE = SHR_CODE and B(3 downto 0) = "0110"
	else	"0000000"&A(15 downto 7)		 when OPCODE = SHR_CODE and B(3 downto 0) = "0111"
	else	"00000000"&A(15 downto 8)		 when OPCODE = SHR_CODE and B(3 downto 0) = "1000"
	else	"000000000"&A(15 downto 9)		 when OPCODE = SHR_CODE and B(3 downto 0) = "1001"
	else	"0000000000"&A(15 downto 10)	 when OPCODE = SHR_CODE and B(3 downto 0) = "1010"
	else	"00000000000"&A(15 downto 11)	 when OPCODE = SHR_CODE and B(3 downto 0) = "1011"
	else	"000000000000"&A(15 downto 12)	 when OPCODE = SHR_CODE and B(3 downto 0) = "1100"
	else	"0000000000000"&A(15 downto 13)	 when OPCODE = SHR_CODE and B(3 downto 0) = "1101"
	else	"00000000000000"&A(15 downto 14) when OPCODE = SHR_CODE and B(3 downto 0) = "1110"
	

	else	A_bar							 when OPCODE = NOT_CODE
	else	(others => '0');
--------------------------------------------------------------------------------------------------------------	


adder_module : nbit_adder port map(ALU_in1, ALU_in2, adder_cin, adder_out, adder_cout, adder_overflow);

--calculating flags

--carry
ALU_flags_out(0) <= adder_cout   when OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE = INC_CODE OR OPCODE = DEC_CODE
	else    A(0)    when OPCODE = RRC_CODE
	else    A(15)   when OPCODE = RLC_CODE
	else	'1'	    when OPCODE = SETC_CODE
	else	'0'	    when OPCODE = CLRC_CODE OR OPCODE = JC_CODE OR ( (OPCODE = SHL_CODE  OR OPCODE = SHR_CODE) and B(3 downto 0) = "0000")
	
	else	A(15)	when  OPCODE = SHL_CODE and B(3 downto 0) = "0001"
	else	A(14)	when (OPCODE = SHL_CODE and B(3 downto 0) = "0010")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1111")
	else	A(13)	when (OPCODE = SHL_CODE and B(3 downto 0) = "0011")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1110")
	else	A(12)	when (OPCODE = SHL_CODE and B(3 downto 0) = "0100")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1101")
	else	A(11)	when (OPCODE = SHL_CODE and B(3 downto 0) = "0101")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1100")
	else	A(10)	when (OPCODE = SHL_CODE and B(3 downto 0) = "0110")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1011")
	else	A(9)	when (OPCODE = SHL_CODE and B(3 downto 0) = "0111")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1010")
	else	A(8)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1000")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1001")
	else	A(7)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1001")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "1000")
	else	A(6)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1010")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "0111")
	else	A(5)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1011")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "0110")
	else	A(4)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1100")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "0101")
	else	A(3)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1101")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "0100")
	else	A(2)	when (OPCODE = SHL_CODE and B(3 downto 0) = "1110")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "0011")
	else	A(1)    when (OPCODE = SHL_CODE and B(3 downto 0) = "1111")  OR ( OPCODE = SHR_CODE and B(3 downto 0) = "0010")
	else	A(0)    when  OPCODE = SHR_CODE and B(3 downto 0) = "0001"
	
	else 	ALU_flags_in(0);

--zero 
process(alu_out_local, OPCODE, alu_flags_in(1))
  begin
    if(OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE =INC_CODE OR OPCODE = DEC_CODE OR OPCODE = AND_CODE OR OPCODE = OR_CODE OR OPCODE = RLC_CODE OR OPCODE = RRC_CODE OR OPCODE = SHL_CODE OR OPCODE = SHR_CODE OR OPCODE = NOT_CODE)then
		  if(alu_out_local = x"0000") then
			 ALU_flags_out(1) <= '1';
		  else
			 ALU_flags_out(1) <= '0';
		  end if;
    elsif(OPCODE = JZ_CODE) then
		ALU_flags_out(1) <= '0';
	else
      ALU_flags_out(1) <= ALU_flags_in(1);
    end if;
  end process;
--ALU_flags_out(1) <= '1'  when alu_out_local = x"0000" and (OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE =INC_CODE OR OPCODE = DEC_CODE OR OPCODE = AND_CODE OR OPCODE = OR_CODE OR OPCODE = RLC_CODE OR OPCODE = RRC_CODE OR OPCODE = SHL_CODE OR OPCODE = SHR_CODE OR OPCODE = NOT_CODE)and (OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE =INC_CODE OR OPCODE = DEC_CODE OR OPCODE = AND_CODE OR OPCODE = OR_CODE OR OPCODE = RLC_CODE OR OPCODE = RRC_CODE OR OPCODE = SHL_CODE OR OPCODE = SHR_CODE OR OPCODE = NOT_CODE) 
--else '0' when alu_out_local /= x"0000" 
--else  ALU_flags_in(1); 

--Negative
ALU_flags_out(2) <= alu_out_local(15) when OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE =INC_CODE OR OPCODE = DEC_CODE OR OPCODE = AND_CODE OR OPCODE = OR_CODE OR OPCODE = RLC_CODE OR OPCODE = RRC_CODE OR OPCODE = SHL_CODE OR OPCODE = SHR_CODE OR OPCODE = NOT_CODE
else '0' when OPCODE = JN_CODE
else ALU_flags_in(2);

--overflow
ALU_flags_out(3) <= adder_overflow;  --when OPCODE = ADD_CODE OR OPCODE = SUB_CODE OR OPCODE = NEG_CODE OR OPCODE = INC_CODE OR OPCODE = DEC_CODE;

ALU_out <= alu_out_local;
end ALU_ARC;
