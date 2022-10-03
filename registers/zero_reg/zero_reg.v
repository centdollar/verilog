// Author: Vincent Michelini
// Description: Register that when written to does not change its value and
//              read from it returns zero


module zero_reg
#(
    parameter SIZE = 8
)
(
    input [SIZE - 1 : 0] din_i,
    input wr_en_i,
    input clk_i,
    output reg [SIZE - 1 : 0] dout_o

);


always @(posedge clk_i)
begin
    if(wr_en_i) dout_o <= 0;
    else dout_o <= 0;
end


endmodule
