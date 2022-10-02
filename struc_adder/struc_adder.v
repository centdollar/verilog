// Author: Vincent Michelini
//
// Description: My custom design of a structural adder in verilog


module struc_adder
#(
    parameter SIZE = 4
)
(
    input [SIZE - 1 : 0] dinx_i,
    input [SIZE - 1 : 0] diny_i,

    output cout_o,
    output [SIZE - 1 : 0] sum_o
);


wire [SIZE : 0] internal_cin;
generate

    assign internal_cin[0] = 0;
    assign cout_o = internal_cin[SIZE];
    genvar i;
    for(i = 0; i < SIZE; i = i + 1)
    begin
       : adder struc_adder_1bit addr
        (
            .x_i(dinx_i[i]),
            .y_i(diny_i[i]),
            .cin_i(internal_cin[i]),
            .cout_o(internal_cin[i + 1]),
            .sum_o(sum_o[i])
        );
    end
endgenerate



endmodule
