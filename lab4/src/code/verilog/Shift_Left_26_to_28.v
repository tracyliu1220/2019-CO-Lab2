module Shift_Left_26_to_28(
    data_i,
    data_o
    );

//I/O ports                    
input [25:0] data_i;
output [27:0] data_o;

//shift left 2
assign data_o = {data_i, 2'b00};
     
endmodule