//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Tracy Liu, Chieh Nien
//----------------------------------------------
//Date:        2019.4.30
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    funct,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	shift_o,
	SE_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg,
	Jump_o,
	BranchType
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] funct;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         shift_o;
output         SE_o;

//for Lab3
output	       MemRead_o;
output     	   MemWrite_o;
output     	   MemtoReg;
output     	   Jump_o;
output 	       BranchType;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg    [2-1:0] Branch_o;
reg            shift_o;
reg            SE_o;
reg    [3-1:0] type;

//Parameter


//Main function
always@(*) begin
  case (instr_op_i)
    // R
    6'b000000: type <= 0;
    // B
    6'b000100: type <= 1;
    6'b000101: type <= 1;
    // I
    6'b001000: type <= 2;
    6'b001011: type <= 2;
    6'b001111: type <= 2;
    6'b001101: type <= 2;

    6'b100011: type <= 3; // lw
    6'b101011: type <= 4; // sw

    6'b000010: type <= 5; // j
    6'b000011: type <= 5; // jal
  endcase
  case (type)
    0: begin // R-format
      if(funct == 6'b000011) shift_o <= 1;
      else shift_o <= 0;
      ALU_op_o <= 3'b010;
      ALUSrc_o <= 0;
      Branch_o <= 0;
      RegWrite_o <= 1;
      RegDst_o <= 1;
    end
    1: begin // Branch
      if (instr_op_i == 6'b000100) ALU_op_o <= 3'b001; // beq
      if (instr_op_i == 6'b000101) ALU_op_o <= 3'b101; // bne
      ALUSrc_o <= 0;
      Branch_o <= 1;
      RegWrite_o <= 0;
      shift_o <= 0;
    end
    2: begin // I-format
      ALUSrc_o <= 1;
      Branch_o <= 0;
      RegWrite_o <= 1;
      RegDst_o <= 0;
      shift_o <= 0;
      if (instr_op_i == 6'b001000) ALU_op_o <= 3'b000; // addi
      if (instr_op_i == 6'b001011) ALU_op_o <= 3'b110; // sltiu
      if (instr_op_i == 6'b001111) ALU_op_o <= 3'b011; // lui
      if (instr_op_i == 6'b001101) ALU_op_o <= 3'b100; // ori
    end
  endcase
  case (instr_op_i)
    6'b001000: SE_o <= 1;
    6'b001011: SE_o <= 0;
    6'b000100: SE_o <= 1;
    6'b001111: SE_o <= 1;
    6'b001101: SE_o <= 0;
    6'b000101: SE_o <= 1;
  endcase
  case (funct)
    6'b000011: SE_o <= 0; //sra unsign for extend
  endcase
end

endmodule





                    
                    