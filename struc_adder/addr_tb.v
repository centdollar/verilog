`timescale 1ns/1ps
// Author: Vincent Michelini
// Description: testbench for the n-bit structural adder module


module addr_tb();


localparam SIZE = 4;

reg [SIZE - 1 : 0] x_tb;
reg [SIZE - 1 : 0] y_tb;

wire [SIZE - 1 : 0] sum_tb;
wire cout_tb;


struc_adder
#(
    .SIZE(SIZE)
)
muv
(
    .dinx_i(x_tb),
    .diny_i(y_tb),
    .cout_o(cout_tb),
    .sum_o(sum_tb)
    
);

initial
begin
    x_tb <= 'hf;
    y_tb <= 'h1; 
    #100;   
end

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, addr_tb);
end

endmodule
