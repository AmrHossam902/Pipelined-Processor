vsim -voptargs=+acc work.cpu
# vsim -voptargs=+acc work.cpu 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.cpu(cpu_arc)
# Loading work.nbit_register(nbit_register_arc)
# Loading work.nbit_adder(nbit_adder_arc)
# Loading work.bit_adder(bit_adder_arc)
# Loading work.fsm(fsm_arc)
# Loading ieee.numeric_std(body)
# Loading work.ins_memory(ins_memory_arc)
# Loading work.registerfile(registerfile_arc)
# Loading work.decoder3x8(behavioral)
# Loading work.mux8x1(multiplexer8_1_arc)
# Loading work.cu(cu_arc)
# Loading work.alu(alu_arc)
# Loading work.datamemory(datamemory_arc)
add wave -position insertpoint  \
sim:/cpu/in_port \
sim:/cpu/out_port \
sim:/cpu/rst \
sim:/cpu/clk \
sim:/cpu/interrupt \
sim:/cpu/instruction \
sim:/cpu/mux3_value \
sim:/cpu/pc_value \
sim:/cpu/pc_plus_one \
sim:/cpu/mux1_value \
sim:/cpu/pc_cry \
sim:/cpu/pc_oflw \
sim:/cpu/int \
sim:/cpu/dft_bar \
sim:/cpu/rst_from_fsm \
sim:/cpu/pc_enable \
sim:/cpu/dec_PC \
sim:/cpu/dec_instruction \
sim:/cpu/dec_opcode \
sim:/cpu/dec_src1_num \
sim:/cpu/dec_src2_num \
sim:/cpu/dec_dst_num \
sim:/cpu/dec_shamt \
sim:/cpu/src1_value \
sim:/cpu/src2_value \
sim:/cpu/mux6_value \
sim:/cpu/PCtoRegfile \
sim:/cpu/CU_signals \
sim:/cpu/sp_enable \
sim:/cpu/exe_opcode \
sim:/cpu/exe_src1_value \
sim:/cpu/exe_src2_value \
sim:/cpu/exe_pc_imm_EA \
sim:/cpu/exe_dst_num \
sim:/cpu/exe_src1_num \
sim:/cpu/exe_src2_num \
sim:/cpu/exe_src1_exist \
sim:/cpu/exe_src2_exist \
sim:/cpu/exe_mem_read \
sim:/cpu/exe_mem_write \
sim:/cpu/exe_reg_write \
sim:/cpu/exe_flags_enable \
sim:/cpu/exe_mux9_s0 \
sim:/cpu/exe_mux12_s0 \
sim:/cpu/exe_mux15_s0 \
sim:/cpu/exe_mux10_s \
sim:/cpu/exe_mux11_s \
sim:/cpu/mux9_value \
sim:/cpu/mux10_value \
sim:/cpu/mux11_value \
sim:/cpu/alu_out \
sim:/cpu/inport_value \
sim:/cpu/mux12_value \
sim:/cpu/alu_flags_out \
sim:/cpu/flags_reg_value \
sim:/cpu/flags_save_value \
sim:/cpu/mux14_value \
sim:/cpu/flag_save_enable \
sim:/cpu/B \
sim:/cpu/C \
sim:/cpu/flags_enable \
sim:/cpu/ret \
sim:/cpu/out_enable \
sim:/cpu/in_enable \
sim:/cpu/mem_c \
sim:/cpu/mem_ret \
sim:/cpu/mem_mem_read \
sim:/cpu/mem_mem_write \
sim:/cpu/mem_reg_write \
sim:/cpu/mem_mux10_value \
sim:/cpu/mem_mux11_value \
sim:/cpu/mem_of_0 \
sim:/cpu/mem_of_1 \
sim:/cpu/mem_mux12_value \
sim:/cpu/mem_dst_num \
sim:/cpu/data_mem_out \
sim:/cpu/mux15_value \
sim:/cpu/wb_reg_write \
sim:/cpu/wb_dst_num \
sim:/cpu/wb_mux15_value \
sim:/cpu/reg_write \
sim:/cpu/mem_read \
sim:/cpu/mem_write \
sim:/cpu/sp_selector \
sim:/cpu/sp_enable_cu \
sim:/cpu/pop \
sim:/cpu/flags_enable_cu \
sim:/cpu/mux9_s0 \
sim:/cpu/mux12_s0 \
sim:/cpu/mux15_s0 \
sim:/cpu/src1_exist \
sim:/cpu/src2_exist \
sim:/cpu/mux10_s \
sim:/cpu/mux11_s \
sim:/cpu/mux6_s \
sim:/cpu/J \
sim:/cpu/fd_buffer_rst \
sim:/cpu/de_buffer_rst \
sim:/cpu/em_buffer_rst \
sim:/cpu/mw_buffer_rst \
sim:/cpu/mux16_value \
sim:/cpu/fd_buffer_input \
sim:/cpu/fd_buffer_value \
sim:/cpu/de_buffer_input \
sim:/cpu/de_buffer_value \
sim:/cpu/em_buffer_input \
sim:/cpu/em_buffer_value \
sim:/cpu/mw_buffer_input \
sim:/cpu/mw_buffer_value
add wave -position insertpoint sim:/cpu/F_S_M/*
add wave -position insertpoint sim:/cpu/DM/*
add wave -position insertpoint sim:/cpu/RF/*
force -freeze sim:/cpu/in_port 0000000000000000 0
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/cpu/interrupt 0 0
mem load -i {D:/3rd year 2nd term/Computer Architecture/Project/mem.mem} -format binary -filltype value -filldata 0 -fillradix symbolic -skip 0 /cpu/Imem/ram
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /cpu/Imem
run
force -freeze sim:/cpu/rst 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/cpu/in_port 0000000000000001 0
run
run
run
run
run
run
# WARNING: No extended dataflow license exists
run
run
run
run
run
run
run
run
run
run
mem load -filltype value -filldata 0000000001100100 -fillradix symbolic /cpu/DM/ram(1)
mem load -filltype value -filldata 1101000000011000 -fillradix symbolic /cpu/Imem/ram(100)
run
run
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/cpu/interrupt 1 0
run
run
force -freeze sim:/cpu/interrupt 0 0
run
run
run
run
run
run
run
run