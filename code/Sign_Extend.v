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
               
//I/O ports
input   [16-1:0] data_i;
input            enable;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(*)begin
    if(enable)begin
        data_o[15:0] = data_i;
        data_o[31:16] = {16{data_i[15]}};
    end
    else if(!enable)begin
        data_o[15:0] = data_i;
        data_o[31:16] = 16'd0;
    end
end
          
endmodule      
     