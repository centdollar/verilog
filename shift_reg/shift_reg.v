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
    parameter SIZE = 8,
    parameter SHIFT_LEFT = 1,
    parameter SHIFT_RIGHT = 0,
    parameter SHIFT_LOGICAL = 1,
    parameter SHIFT_ARITHMETIC = 0,
    parameter SHIFT_AMOUNT = 1
)
(

    input [SIZE - 1 : 0] din_i,
    input shift_i,          // 1: shift     0: no shift
    input clk_i,
    input wr_en_i,          // 1: write     0: no write
    input reset_i,          // 1: reset     0: no reset

    output reg [SIZE - 1 : 0] dout_o

);

// reg [7 : 0] data_reg;       // register that holds the data while shifting

always @(posedge clk_i)
begin
    if(reset_i)
    begin
//        data_reg <- 0;
        dout_o <= 0;
    end
    else
    begin
        if(wr_en_i)
        begin
           dout_o <= din_i; 
        end
        else
        begin
            if(shift_i)
            begin
                if(SHIFT_LEFT && (SHIFT_LOGICAL | SHIFT_ARITHMETIC))
                begin
                    dout_o <= {dout_o[SIZE - 1 - SHIFT_AMOUNT : 0], {SHIFT_AMOUNT{1'b0}}};
                end
                else if(SHIFT_RIGHT && SHIFT_LOGICAL)
                begin
                    dout_o <= {{SHIFT_AMOUNT{1'b0}}, dout_o[SIZE - 1 : SHIFT_AMOUNT]};
                end
                else if(SHIFT_RIGHT && SHIFT_ARITHMETIC)
                begin
                    dout_o <= {{SHIFT_AMOUNT{dout_o[SIZE - 1]}}, dout_o[SIZE - 1 : SHIFT_AMOUNT]};
                end
                else dout_o <= dout_o;
            end
        end
    end
end




endmodule
