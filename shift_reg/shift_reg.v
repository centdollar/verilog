// Shift register
// Author: Vincent Michelini
// Description: intended to make a shift register with a lot of modular
// functionality and paramaterization to make this functionality possible
//
// TODO: first get a basic shift register made.
//       Then make a different shift signal for each possible switch, but
//       think about maybe using a parameter based shift register 
//       Lots of options to choose from
//       parameter ideas:
//       - width
//       - shift amount
//       - idk


module shift_reg
#(

)
(

    input [7 : 0] din_i,
    input shift_i,          // 1: shift     0: no shift
    input clk_i,
    input reset_i,          // 1: reset     0: no reset

    output reg [7 : 0] dout_o

);

reg [7 : 0] data_reg;       // register that holds the data while shifting

always @(posedge clk_i)
begin
    if(reset_i)
    begin
        dout_0
    end

end





endmodule
