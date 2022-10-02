// Author: Vincent Michelini
//
// Description: My custom design of a structural adder in verilog


module struc_adder
#(
    parameter N = 4
)
(
    input [N - 1 : 0] dinx_i,
    input [N - 1 : 0] diny_i,

    output cout_o,
    output [N - 1 : 0] sum_o
);

wire [N : 0] internal_cin;
assign interal_cin[0] = 0;

genvar i;
generate
    for(i = 0; i < N; i = i + 1)
    begin : adder
        struc_adder_1bit
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
