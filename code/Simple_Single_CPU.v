//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;
//Internal Signles
wire [32-1:0] PC_i, PC_o, RSdata_o, RTdata_o, ALU_result, instr, shift_o;
wire [32-1:0] PC_4, RDdata_i, se_o, Mux_src, PC_b, se_sa_o, RSdata_o_temp;
wire [5-1:0] RDaddr;
wire [4-1:0] ALU_Ctrl;
wire [3-1:0] ALUop;
wire RegDst, RegWrite, ALUsrc, branch, enable, zero, shift_o_de;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_i) ,   
	    .pc_out_o(PC_o) 
	    );
	
Adder Adder1(
        .src1_i(PC_o),     
	    .src2_i(32'd4),     
	    .sum_o(PC_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(PC_o),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(RDaddr) ,  
        .RDdata_i(ALU_result)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RSdata_o_temp) ,  
        .RTdata_o(RTdata_o)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]),
        .funct(instr[5:0]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUop),   
	    .ALUSrc_o(ALUsrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch),
		.shift_o(shift_o_de),
		.SE_o(enable)   
	    );

Sign_Extend #(.size(5)) SE_sa(
        .data_i(instr[10:6]),
        .enable(enable),
        .data_o(se_sa_o)
        );
        
MUX_2to1 #(.size(32)) Mux_Shift(
        .data0_i(RSdata_o_temp),
        .data1_i(se_sa_o),
        .select_i(shift_o_de),
        .data_o(RSdata_o)
        );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUop),   
        .ALUCtrl_o(ALU_Ctrl) 
        );
	
Sign_Extend #(.size(16)) SE(
        .data_i(instr[15:0]),
        .enable(enable),
        .data_o(se_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_o),
        .data1_i(se_o),
        .select_i(ALUsrc),
        .data_o(Mux_src)
        );	
		
ALU ALU(
        .src1_i(RSdata_o),
	    .src2_i(Mux_src),
	    .ctrl_i(ALU_Ctrl),
	    .result_o(ALU_result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(shift_o),     
	    .src2_i(PC_4),     
	    .sum_o(PC_b)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se_o),
        .data_o(shift_o)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(PC_4),
        .data1_i(PC_b),
        .select_i(branch & zero),
        .data_o(PC_i)
        );	

endmodule
		  


