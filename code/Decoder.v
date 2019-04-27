//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	SE_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         SE_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            SE_o;

//Parameter


//Main function
always@(*) begin
  case (instr_op_i[3:2])
    2'b00: begin // R-format
      ALU_op_o <= 3'b000;
      ALUSrc_o <= 0;
      Branch_o <= 0;
      RegWrite_o <= 1;
      RegDst_o <= 1;
    end
    2'b01: begin // Branch
      ALU_op_o <= 3'b001;
      ALUSrc_o <= 0;
      Branch_o <= 1;
      RegWrite_o <= 0;
    end
    default: begin // I-format
      ALUSrc_o <= 1;
      Branch_o <= 0;
      RegWrite_o <= 1;
      RegDst_o <= 0;
      if (instr_op_i == 6'b001011) ALU_op_o <= 3'b110; // sltiu
      if (instr_op_i == 6'b001111) ALU_op_o <= 3'b011; // lui
      if (instr_op_i == 6'b001101) ALU_op_o <= 3'b100; // ori
      if (instr_op_i == 6'b000101) ALU_op_o <= 3'b101; // bne
    end
  endcase
  case (instr_op_i)
    6'b001000: SE_o <= 1;
    6'b001011: SE_o <= 0;
    6'b000100: SE_o <= 1;
    6'b001111: SE_o <= 1;
    6'b001101: SE_o <= 1;
    6'b000101: SE_o <= 1;
  endcase
end

endmodule





                    
                    