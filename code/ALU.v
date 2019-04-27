//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Tracy Liu
//----------------------------------------------
//Date:        2019.4.26
//----------------------------------------------
//Description: using 32-bit ALU
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
always@(ctrl_i, src1_i, src2_i) begin
    case (ctrl_i)
        0:  result_o <= src1_i & src2_i;
        1:  result_o <= src1_i | src2_i;
        2:  result_o <= src1_i + src2_i;
        6:  result_o <= src1_i - src2_i;
        7:  result_o <= src1_i < src2_i ? 1 : 0;
        8:  result_o <= src1_i >>> src2_i;  // shift right
        9:  result_o <= src2_i << 16;       // lui
        10: result_o <= src1_i - src2_i;    // bne
        12: result_o <= ~(src1_i | src2_i); // nor
        default: result_o <= 0;
    endcase
end
assign zero_o = (result_o == 0) ^ (ctrl_i == 10);

endmodule





                    
                    
