`timescale 1ns/1ps
// Author: Vincent Michelini
// Description: Testbench for the zero reigster, simple just test input and
//              output


module zero_reg_tb();

localparam SIZE = 8;

reg clk_tb;
reg [SIZE - 1 : 0] din_tb;
reg wr_en_tb;

wire [SIZE - 1 : 0] dout_tb;


zero_reg
#(
    .SIZE(SIZE)
)
muv
(
    .din_i(din_tb),
    .wr_en_i(wr_en_tb),
    .clk_i(clk_tb),
    .dout_o(dout_tb)


);


initial
begin
    clk_tb <= 0;
    wr_en_tb <= 0;
    din_tb <= 0;
    @(posedge clk_tb)
    wr_en_tb <= 1;
    din_tb <= 'hff;
    @(posedge clk_tb)
    wr_en_tb <= 0;

end


always
begin
    #10; clk_tb <= ~clk_tb;
end


initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, zero_reg_tb);
end

endmodule
