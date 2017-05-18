LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY HDU IS
	PORT( 
		  OPCODE: IN std_logic_vector(4 downto 0);
		  SRC1_EXISTS,SRC2_EXISTS: in std_logic;
		  DEC_EXE_DST, FET_DEC_SRC1, FET_DEC_SRC2: IN std_logic_vector(2 downto 0);
		  DISABLE_PC: out std_logic);
END HDU;

Architecture HDU_ARC of HDU is
	
    constant OPCODE_POP:    std_logic_vector(4 downto 0) :=  "01101";  	-- POP 

     begin
     process (OPCODE, SRC1_EXISTS, SRC2_EXISTS, DEC_EXE_DST, FET_DEC_SRC1, FET_DEC_SRC2) 
     begin
     if  (OPCODE=OPCODE_POP AND 
	    ((DEC_EXE_DST= FET_DEC_SRC1 AND SRC1_EXISTS='1') OR 
         (DEC_EXE_DST= FET_DEC_SRC2 AND SRC2_EXISTS='1'))) then
           DISABLE_PC<='1';
	 else 
	 DISABLE_PC<='0'; 
	 
     end if;
	 end process;
	
end HDU_ARC;