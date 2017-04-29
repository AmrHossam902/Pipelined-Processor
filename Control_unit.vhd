library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity CU IS
	PORT(
	clk   : in std_logic;
	reset : in std_logic;
	OPCODE_INPUT : in std_logic_vector(4 downto 0);
	Signals: out std_logic_vector(18 downto 0));
END CU;

Architecture CU_ARC of CU is
constant OPCODE_NOP:    std_logic_vector(4 downto 0) :=  "00000";	-- NOP
constant OPCODE_MOV:    std_logic_vector(4 downto 0) :=  "00001";	-- MOV
constant OPCODE_RLC:    std_logic_vector(4 downto 0) :=  "00010";	-- RLC 
constant OPCODE_RRC:    std_logic_vector(4 downto 0) :=  "00011"; 	-- RRC
constant OPCODE_ADD:    std_logic_vector(4 downto 0) :=  "00100";	-- ADD
constant OPCODE_SUB:    std_logic_vector(4 downto 0) :=  "00101";	-- SUB 
constant OPCODE_AND:    std_logic_vector(4 downto 0) :=  "00110";	-- AND
constant OPCODE_OR:     std_logic_vector(4 downto 0) :=  "00111";	-- OR 
constant OPCODE_SHL:    std_logic_vector(4 downto 0) :=  "01000";	-- SHL
constant OPCODE_SHR:    std_logic_vector(4 downto 0) :=  "01001";	-- SHR
constant OPCODE_SETC:   std_logic_vector(4 downto 0) :=  "01010";	-- SETC 
constant OPCODE_CLRC: 	std_logic_vector(4 downto 0) :=  "01011";	-- CLRC 
constant OPCODE_PUSH:   std_logic_vector(4 downto 0) :=  "01100";	-- PUSH
constant OPCODE_POP:    std_logic_vector(4 downto 0) :=  "01101";  	-- POP 
constant OPCODE_OUT:    std_logic_vector(4 downto 0) :=  "01110";	-- OUT 
constant OPCODE_IN: 	std_logic_vector(4 downto 0) :=  "01111";	-- IN 
constant OPCODE_NOT:    std_logic_vector(4 downto 0) :=  "10000";	-- NOT 
constant OPCODE_NEG:    std_logic_vector(4 downto 0) :=  "10001";	-- NEG
constant OPCODE_INC:    std_logic_vector(4 downto 0) :=  "10010";   -- INC 
constant OPCODE_DEC:    std_logic_vector(4 downto 0) :=  "10011";   -- DEC
constant OPCODE_JZ:     std_logic_vector(4 downto 0) :=  "10100";	-- JZ 
constant OPCODE_JN:     std_logic_vector(4 downto 0) :=  "10101";	-- JN
constant OPCODE_JC:     std_logic_vector(4 downto 0) :=  "10110";   -- JC 
constant OPCODE_JMP:    std_logic_vector(4 downto 0) :=  "10111";	-- JMP 
constant OPCODE_CALL:   std_logic_vector(4 downto 0) :=  "11000";	-- CALL 
constant OPCODE_RET:    std_logic_vector(4 downto 0) :=  "11001";	-- RET 
constant OPCODE_RTI:    std_logic_vector(4 downto 0) :=  "11010";	-- RTI
constant OPCODE_LDM:    std_logic_vector(4 downto 0) :=  "11011";   -- LDM 
constant OPCODE_LDD:    std_logic_vector(4 downto 0) :=  "11100";	-- LDD 
constant OPCODE_STD:    std_logic_vector(4 downto 0) :=  "11101";	-- STD 
--constant OPCODE_:     std_logic_vector(4 downto 0) :=  "11110";	--  
constant OPCODE_INT:    std_logic_vector(4 downto 0) :=  "11111";	-- INT 

begin
process(clk,reset)
begin
	if(reset='1') then
		Signals<= (others=>'0');
	elsif rising_edge(clk) then
		if OPCODE_INPUT=OPCODE_NOP then
			Signals<= "0000001000000000000";
		elsif OPCODE_INPUT=OPCODE_MOV then 
			Signals<= "1000001000000000010";
		elsif OPCODE_INPUT=OPCODE_ADD then
			Signals<= "1000001100000100011";
		elsif OPCODE_INPUT=OPCODE_SUB then
			Signals<= "1000001100000100011";
		elsif OPCODE_INPUT=OPCODE_AND then
			Signals<= "1000001100000100011";
		elsif OPCODE_INPUT=OPCODE_OR then 
			Signals<= "1000001100000100011";
		elsif OPCODE_INPUT=OPCODE_RLC then 
			Signals<= "1000001100000100010";
		elsif OPCODE_INPUT=OPCODE_RRC then 
			Signals<= "1000001100000100010";
		elsif OPCODE_INPUT=OPCODE_SHL then 
			Signals<= "1000001101100100010";
		elsif OPCODE_INPUT=OPCODE_SHR then 
			Signals<= "1000001101100100010";
		elsif OPCODE_INPUT=OPCODE_SETC then 
			Signals<= "0000001100000000000";
		elsif OPCODE_INPUT=OPCODE_CLRC then 
			Signals<= "0000001100000000000";
		elsif OPCODE_INPUT=OPCODE_PUSH then 
			Signals<= "0010101000000001010";
		elsif OPCODE_INPUT=OPCODE_POP then 
			Signals<= "1101111000000001100";
		elsif OPCODE_INPUT=OPCODE_OUT then 
			Signals<= "0000001000000000010";
		elsif OPCODE_INPUT=OPCODE_IN then 
			Signals<= "1000001000000110000";
		elsif OPCODE_INPUT=OPCODE_NOT then 
			Signals<= "1000001100000100010";
		elsif OPCODE_INPUT=OPCODE_NEG then 
			Signals<= "1000001100000100010";
		elsif OPCODE_INPUT=OPCODE_INC then 
			Signals<= "1000001100000100010";
		elsif OPCODE_INPUT=OPCODE_DEC then 
			Signals<= "1000001100000100010";
		elsif OPCODE_INPUT=OPCODE_JZ then 
			Signals<= "0000001100000000010";
		elsif OPCODE_INPUT=OPCODE_JN then 
			Signals<= "0000001100000000010";
		elsif OPCODE_INPUT=OPCODE_JC then 
			Signals<= "0000001100000000010";
		elsif OPCODE_INPUT=OPCODE_JMP then 
			Signals<= "0000001000000000010";
		elsif OPCODE_INPUT=OPCODE_CALL then 
			Signals<= "0010101000110001010";
		elsif OPCODE_INPUT=OPCODE_RET then 
			Signals<= "0000111000000001000";
		elsif OPCODE_INPUT=OPCODE_RTI then 
			Signals<= "0000111000000001000";
		elsif OPCODE_INPUT=OPCODE_LDM then 
			Signals<= "1000001010000010000";
		elsif OPCODE_INPUT=OPCODE_LDD then 
			Signals<= "1100001010000000100";
		elsif OPCODE_INPUT=OPCODE_STD then 
			Signals<= "0010001010000000010";
		elsif OPCODE_INPUT=OPCODE_INT then 
			Signals<= "0010101000001001000";
	 end if;
	   end if;	
end process;
end CU_ARC;
































