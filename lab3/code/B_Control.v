//Subject:     CO project 2 - B_Control
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Tracy Liu
//----------------------------------------------
//Date:        2019.5.12
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module B_Control(
    zero_i,
    result_i,
    BranchType,
    control_o
);

//I/O ports
input         zero_i;
input  [31:0] result_i;
input   [1:0] BranchType;
output        control_o;  

//Internal Signals
wire  signed [31:0] result_i;
reg          control_o;

//Main function
always@(*) begin
  case (BranchType)
    0: control_o = zero_i;   // beq
    1: control_o = ~zero_i;  // bne, bnez
    2: control_o = result_i; // ble
    3: control_o = (result_i < 0); // bltz
  endcase
end

endmodule