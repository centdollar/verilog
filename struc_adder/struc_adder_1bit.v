// Author: Vincent Michelini
// Description: This is a 1 bit strucural full adder that is used in the upper
// level module in a generate for loop



module struc_adder_1bit
(
    input x_i,
    input y_i,
    input cin_i,

    output sum_o,
    output cout_o
);

wire xandy;
wire xandcin;
wire yandcin;

xor(sum_o, x_i, y_i, cin_i);
and(xandy, x_i, y_i);
and(xandcin, x_i, cin_i);
and(yandcin, y_i, cin_i);
or(cout_o, xandy, xandcin, yandcin);


endmodule
