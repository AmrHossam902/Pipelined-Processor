library ieee;
use ieee.std_logic_1164.all;

Entity CPU is
	port(in_port: in std_logic_vector(15 downto 0);
		out_port: out std_logic_vector(15 downto 0);
		rst, clk, interrupt: std_logic);
end CPU;

Architecture CPU_ARC of CPU is
	
------------------------------------------------------components------------------------------------------------------	
--register file
	component registerfile is
	port(
		Clk,rst,reg_wr,sp_selector,sp_enable : IN std_logic;
    	pc,data_in: IN  std_logic_vector(15 DOWNTO 0);
		srcin1,srcin2,dst:IN  std_logic_vector(2 DOWNTO 0);
		srcout1,srcout2:OUT  std_logic_vector(15 DOWNTO 0));
	end component;

--ALU
	component ALU is
	port( OPCODE: in std_logic_vector(4 downto 0);
		A,B : IN std_logic_vector(15 downto 0);
		ALU_flags_out: out std_logic_vector(3 downto 0);    -- V: overflow,  N: negative,  Z: zero C: carry,  
		ALU_flags_in: in std_logic_vector(3 downto 0);
		ALU_OUT: out std_logic_vector(15 downto 0));
	end component;
	

--Instruction memory
	component Ins_Memory IS
	PORT (clk : IN std_logic;
	   address : IN std_logic_vector(9 DOWNTO 0);
	   dataout : OUT std_logic_vector(15 DOWNTO 0) );
	END component;
	
	
--Data memory
	component DataMemory IS
	PORT (clk : IN std_logic;
       write_en, Read_en, rst : IN std_logic;
	   address : IN std_logic_vector(9 DOWNTO 0);
	   datain   : IN std_logic_vector(15 DOWNTO 0);
	   dataout : OUT std_logic_vector(15 DOWNTO 0);
	   mem_of_0, mem_of_1: out std_logic_vector(15 downto 0));
	END component;


--Control unit
	component CU IS
		PORT(
		OPCODE_INPUT : in std_logic_vector(4 downto 0);
		Signals: out std_logic_vector(17 downto 0));
	END component;
	
--FSM
	
	component FSM is
		port(global_int, clk, rst: in std_logic;
		int, buffer_rst, dft_bar: out std_logic);
	end component;
	
--register
	component  nbit_Register IS
		Generic(n: integer := 16);
		PORT( Clk,rst, enable : IN std_logic;
			d, rst_value: IN  std_logic_vector(n-1 DOWNTO 0);
			q : OUT std_logic_vector(n-1 DOWNTO 0));
	END component;
	
--Adder
	component nbit_adder IS
		GENERIC (n : integer := 16);
		PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            add_out : OUT std_logic_vector(n-1 DOWNTO 0);    
              cout,overflow : OUT std_logic);
	END component;
	
	
----------------------------------------------------------signals------------------------------------------------------
-- 1- Fetch Stage------------------------------------------------------------------------------------
signal instruction, mux3_value: std_logic_vector(15 downto 0);
signal pc_value, pc_plus_one, mux1_value: std_logic_vector(9 downto 0);
signal pc_cry, pc_oflw ,int, dft_bar, rst_from_fsm, pc_enable: std_logic;  -- malhomsh lazma


-- 2- Decode stage----------------------------------------------------------------------------------
--buffer signals
signal dec_PC: std_logic_vector(9 downto 0);	   -- be careful it's a 10 bit register
signal dec_instruction: std_logic_vector(15 downto 0);
signal dec_opcode: std_logic_vector(4 downto 0);
signal dec_src1_num: std_logic_vector(2 downto 0);
signal dec_src2_num: std_logic_vector(2 downto 0);
signal dec_dst_num: std_logic_vector(2 downto 0);
signal dec_shamt: std_logic_vector(3 downto 0);

--signals not belonging to the buffer 
signal src1_value, src2_value: std_logic_vector(15 downto 0);
signal mux6_value, PCtoRegfile: std_logic_vector(15 downto 0);
signal CU_signals: std_logic_vector(17 downto 0);
signal sp_enable: std_logic;

	
-- 3- Execution stage---------------------------------------------------------------------------
--buffer signals
signal exe_opcode: std_logic_vector(4 downto 0);
signal exe_src1_value, exe_src2_value: std_logic_vector(15 downto 0);
signal exe_pc_imm_EA: std_logic_vector(15 downto 0);
signal exe_dst_num, exe_src1_num, exe_src2_num: std_logic_vector(2 downto 0);
signal exe_src1_exist, exe_src2_exist, exe_mem_read, exe_mem_write, exe_reg_write, exe_flags_enable: std_logic;
signal exe_mux9_s0, exe_mux12_s0, exe_mux15_s0: std_logic;
signal exe_mux10_s, exe_mux11_s: std_logic_vector(1 downto 0);

--signals not belonging to the buffer
signal mux9_value, mux10_value, mux11_value, alu_out: std_logic_vector(15 downto 0);
signal mux12_value: std_logic_vector(9 downto 0);
signal alu_flags_out, flags_reg_value, flags_save_value , mux14_value: std_logic_vector(3 downto 0);
signal flag_save_enable, B, C, flags_enable, ret: std_logic;



-- 4- Memory stage-----------------------------------------------------------------------------
-- buffer signals
signal mem_c, mem_ret ,mem_mem_read, mem_mem_write, mem_reg_write: std_logic;
signal mem_mux10_value, mem_mux11_value: std_logic_vector(15 downto 0);
signal mem_mux12_value: std_logic_vector(9 downto 0);
signal mem_dst_num: std_logic_vector(2 downto 0);

--signals not belonging to the buffer
signal data_mem_out, mux15_value, mem_of_0, mem_of_1: std_logic_vector(15 downto 0);

-- 5- Write back stage----------------------------------------------------------------------------
-- buffer signals
signal wb_reg_write: std_logic;
signal wb_dst_num: std_logic_vector(2 downto 0);
signal wb_mux15_value: std_logic_vector(15 downto 0);


-- control unit signals--------------------------------------------------------------------------
signal reg_write, mem_read, mem_write, sp_selector ,sp_enable_cu, pop, flags_enable_cu: std_logic;
signal mux9_s0, mux12_s0, mux15_s0, src1_exist, src2_exist: std_logic;
signal mux10_s, mux11_s, mux6_s: std_logic_vector(1 downto 0); -- selector for the muxes 10,11


-- connections between stages
signal J, fd_buffer_rst, de_buffer_rst, em_buffer_rst, mw_buffer_rst: std_logic;
signal mux16_value: std_logic_vector(9 downto 0);
signal fd_buffer_input, fd_buffer_value: std_logic_vector(25 downto 0);
signal de_buffer_input, de_buffer_value: std_logic_vector(74 downto 0);
signal em_buffer_input, em_buffer_value: std_logic_vector(51 downto 0);
signal mw_buffer_input, mw_buffer_value: std_logic_vector(19 downto 0);


----------------------------------------------constants--------------------------------------
constant JC_CODE : std_logic_vector(4 downto 0) := "10110";
constant JZ_CODE : std_logic_vector(4 downto 0) := "10100";
constant JN_CODE : std_logic_vector(4 downto 0) := "10101";
constant CALL_CODE : std_logic_vector(4 downto 0) := "11000";
constant RTI_CODE : std_logic_vector(4 downto 0) := "11010";
constant RET_CODE : std_logic_vector(4 downto 0) := "11001";
constant INT_CODE : std_logic_vector(4 downto 0) := "11111";
constant JMP_CODE : std_logic_vector(4 downto 0) := "10111";
constant LDM_CODE : std_logic_vector(4 downto 0) :=  "11011";   
constant LDD_CODE : std_logic_vector(4 downto 0) :=  "11100";	 
constant STD_CODE : std_logic_vector(4 downto 0) :=  "11101";	 


begin
----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------Fetching stage-------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

PC: nbit_Register generic map(10) port map(clk, rst, pc_enable, mux1_value,  mem_of_0(9 downto 0), pc_value);
p1: nbit_adder generic map(10) port map(pc_value, "0000000000", '1', pc_plus_one, pc_cry, pc_oflw); 
F_S_M: FSM port map(interrupt, clk, rst, int, rst_from_fsm, dft_bar);
Imem: Ins_Memory port map(clk, pc_value, Instruction);


mux1_value <= mux16_value when J = '1' and int = '0'
	else	mem_of_1(9 downto 0) when dft_bar = '1' and int = '1' and J= '0'
	else	pc_plus_one;
	
pc_enable <= '0' when (dft_bar = '1' and J = '0' and int = '0') or (dft_bar = '0' and interrupt = '1')
	else '1';
	
mux3_value <= Instruction when int = '0'
	else	"1111100000011000";  -- int format
	

----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------Decoding stage-------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
PCtoRegfile <= "000000"&dec_PC;
RF: registerfile port map(clk, rst, wb_reg_write, sp_selector, sp_enable, PCtoRegfile, wb_mux15_value, dec_src1_num, dec_src2_num, wb_dst_num, src1_value, src2_value);

C_U: CU port map(dec_opcode, CU_signals);

M6: mux6_value <=   "000000"&dec_PC            	when mux6_s = "00"
	else 			"000000000000"&dec_shamt	when mux6_s = "01"
	else			instruction					when mux6_s = "10";

sp_enable <= sp_enable_cu and (not(B or C));	

reg_write <= CU_signals(17);
mem_read <= CU_signals(16);
mem_write <= CU_signals(15); 
pop <= CU_signals(14);
sp_enable_cu <= CU_signals(13);
sp_selector <= CU_signals(12);
flags_enable_cu <= CU_signals(11);
mux6_s <= CU_signals(10 downto 9);
mux9_s0 <= CU_signals(8);
mux10_s <= CU_signals(7 downto 6);
mux11_s <= CU_signals(5 downto 4);
mux12_s0 <= CU_signals(3);
mux15_s0 <= CU_signals(2);
src1_exist <= CU_signals(1);
src2_exist <= CU_signals(0);

	
----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------Execution stage------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

AU: ALU port map(exe_opcode, exe_src1_value, exe_src2_value, alu_flags_out, flags_reg_value, alu_out); 

mux9_value <=	exe_src2_value				when exe_mux9_s0 = '0'
	else			exe_pc_imm_EA;
	
M10:mux10_value<=	exe_src1_value				when exe_mux10_s = "00"
	else			exe_pc_imm_EA				when exe_mux10_s = "01"
	else			alu_out						when exe_mux10_s = "10";
	
M11:mux11_value<=	exe_src1_value				when exe_mux11_s = "00"
	else			exe_pc_imm_EA				when exe_mux11_s = "01"
	else			alu_out  					when exe_mux11_s = "10"
	else			in_port						when exe_mux11_s = "11";

M12:mux12_value<=	exe_src2_value(9 downto 0)	when exe_mux12_s0 = '1'
	else			exe_pc_imm_EA(9 downto 0);

M14:mux14_value<=	flags_save_value				when exe_opcode = RTI_CODE   --opcode = rti opcode	
	else			alu_flags_out;

flag_save_enable<= '1'							when exe_opcode = INT_CODE   --opcode = interrupt 
	else		   '0';
	

B <=	'1'   when exe_opcode = CALL_CODE OR exe_opcode = JMP_CODE OR (exe_opcode = JC_CODE and flags_reg_value(0)= '1') OR (exe_opcode = JN_CODE and flags_reg_value(2)= '1') OR (exe_opcode = JZ_CODE and flags_reg_value(1)= '1')	
else	'0';

C <=	'1'	  when exe_opcode = RTI_CODE OR exe_opcode = RET_CODE
else	'0';

ret <= '1' when exe_opcode = RET_CODE
	else '0';

flags_enable <= exe_flags_enable and (not mem_ret);

Flag_reg: nbit_Register generic map(4) port map(clk, rst, flags_enable, mux14_value, "0000", flags_reg_value);
Flag_save: nbit_Register generic map(4) port map(clk, rst, flag_save_enable, flags_reg_value, "0000", flags_save_value);	




----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------MEmory stage-------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
	
DM: DataMemory port map(clk,mem_mem_write ,mem_mem_read, rst, mem_mux12_value, mem_mux10_value, data_mem_out, mem_of_0, mem_of_1);
M15: mux15_value <= data_mem_out when mux15_s0 = '1'
	else			mem_mux11_value;
	
----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------Write back stage-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ connections between stages ------------------------------------------

J <= B or mem_c;
mux16_value <= data_mem_out(9 downto 0) when mem_c = '1'
	else	exe_src1_value(9 downto 0);

bufferFD: nbit_Register generic map(26) port map(clk, fd_buffer_rst, '1', fd_buffer_input, (others => '0'), fd_buffer_value);   --fetch/decode buffer
bufferDE: nbit_Register generic map(75) port map(clk, de_buffer_rst, '1', de_buffer_input, (others => '0'), de_buffer_value);	 --decode/execute buffer
bufferEM: nbit_Register generic map(52) port map(clk, em_buffer_rst, '1', em_buffer_input, (others => '0'), em_buffer_value);   --execute/memory buffer
bufferMW: nbit_Register generic map(20) port map(clk, mw_buffer_rst, '1', mw_buffer_input, (others => '0'), mw_buffer_value);   --memory/write back

--inputs to buffers
fd_buffer_input <= pc_value & mux3_value;
de_buffer_input <= dec_opcode & src1_value & src2_value & mux6_value & dec_dst_num & dec_src1_num & dec_src2_num & src1_exist & src2_exist & mem_read & mem_write & reg_write & flags_enable_cu & mux9_s0 & mux10_s & mux11_s & mux12_s0 & mux15_s0;
em_buffer_input <= ret & C & mux10_value & mux11_value & mux12_value & exe_reg_write & exe_dst_num & exe_src1_exist & exe_src2_exist & exe_mem_read & exe_mem_write;
mw_buffer_input <= mem_reg_write & mem_dst_num & mux15_value;


--outputs from buffers
--FD buffer
dec_PC <= fd_buffer_value(25 downto 16);
dec_instruction <= fd_buffer_value(15 downto 0);
dec_opcode <= dec_instruction(15 downto 11);
dec_dst_num <= dec_instruction(10 downto 8);
dec_src1_num <= dec_instruction(7 downto 5);
dec_src2_num <= dec_instruction(4 downto 2);
dec_shamt <= dec_instruction(4 downto 1);


--DE buffer
exe_opcode <= de_buffer_value(74 downto 70);
exe_src1_value <= de_buffer_value(69 downto 54);
exe_src2_value <= de_buffer_value(53 downto 38);
exe_pc_imm_EA <= de_buffer_value(37 downto 22);
exe_dst_num <= de_buffer_value(21 downto 19);
exe_src1_num <= de_buffer_value(18 downto 16);
exe_src2_num <= de_buffer_value(15 downto 13);
exe_src1_exist <= de_buffer_value(12);
exe_src2_exist <= de_buffer_value(11);
exe_mem_read <= de_buffer_value(10);
exe_mem_write <= de_buffer_value(9);
exe_reg_write <= de_buffer_value(8);
exe_flags_enable <= de_buffer_value(7);
exe_mux9_s0 <= de_buffer_value(6);
exe_mux10_s <= de_buffer_value(5 downto 4);
exe_mux11_s <= de_buffer_value(3 downto 2);
exe_mux12_s0 <= de_buffer_value(1);
exe_mux15_s0 <= de_buffer_value(0);

--EM buffer
mem_ret <= em_buffer_value(51);
mem_c <= em_buffer_value(50);
mem_mux10_value <= em_buffer_value(49 downto 34);
mem_mux11_value <= em_buffer_value(33 downto 18);
mem_mux12_value <= em_buffer_value(17 downto 8);
mem_reg_write <= em_buffer_value(7);
mem_dst_num <= em_buffer_value(6 downto 4);
mem_mem_read <= em_buffer_value(1);
mem_mem_write <= em_buffer_value(0);

--MW buffer
wb_reg_write <= mw_buffer_value(19);
wb_dst_num <= mw_buffer_value(18 downto 16);
wb_mux15_value <= mw_buffer_value(15 downto 0);


-----------------------buffers reset
fd_buffer_rst <= '1' when J = '1' or rst = '1' or rst_from_fsm = '1' or dec_opcode = LDD_CODE or dec_opcode = LDM_CODE or dec_opcode = STD_CODE
	else 		 '0';

de_buffer_rst <= '1' when J = '1' or rst = '1'
	else		 '0';

em_buffer_rst <= '1' when mem_c = '1' or rst = '1'
	else		 '0';

mw_buffer_rst <= rst;	

end CPU_ARC;