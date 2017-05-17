LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity DataForwarding is
	port(src1_exist, src2_exist ,exe_reg_write,mem_reg_write:in  std_logic;
	exe_src1_num,exe_src2_num,exe_dst_num,mem_dst_num:in  std_logic_vector(2 downto 0);
	ALU1,ALU2:out std_logic_vector(1 downto 0));
end DataForwarding;

Architecture DataForwarding_ARC of DataForwarding is
begin
	process(src1_exist,src2_exist,exe_reg_write,mem_reg_write,
			exe_src1_num,exe_src2_num,exe_dst_num,mem_dst_num)
	begin
	if((exe_dst_num=exe_src1_num) AND exe_reg_write='1' AND src1_exist='1') then
		ALU1<="01"; --forward from memory
	elsif((mem_dst_num=exe_src1_num) AND mem_reg_write='1' AND src1_exist='1') then
		ALU1<="10";   --forward from write back
	else
		ALU1<="00"; 		-- no forwarding
	end if;
	if((exe_dst_num=exe_src2_num) AND exe_reg_write='1' AND src2_exist='1') then
		ALU2<="01"; 		--forward from memory
	elsif((mem_dst_num=exe_src2_num) AND mem_reg_write='1' AND src2_exist='1') then
		ALU2<="10";		--forward from write back
	else	
		ALU2<="00";			-- no forwarding
	end if;
	end process;
end DataForwarding_ARC;