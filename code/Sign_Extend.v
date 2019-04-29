//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Chieh Nien
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    enable,
    data_o
    );
               
parameter size = 0;
//I/O ports
input   [size-1:0] data_i;
input            enable;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(*)begin
    if(enable)begin
        data_o[size-1:0] = data_i;
        data_o[31:size] = {16{data_i[size-1]}};
    end
    else if(!enable)begin
        data_o[size-1:0] = data_i;
        data_o[31:size] = 16'd0;
    end
end
          
endmodule      
     