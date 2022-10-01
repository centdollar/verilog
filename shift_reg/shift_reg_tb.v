// This is the test bench for the custom shift register
`timescale 1ns/1ps


module shift_reg_tb();

reg [SIZE - 1 : 0] din_tb;
reg shift_tb;
reg wr_en_tb;
reg reset_tb;
reg clk_tb;

wire [SIZE - 1 : 0] dout_o;


localparam SIZE = 16;

shift_reg 
#(
    .SIZE(SIZE),
    .SHIFT_LEFT(0),
    .SHIFT_RIGHT(1),
    .SHIFT_LOGICAL(0),
    .SHIFT_ARITHMETIC(1),
    .SHIFT_AMOUNT(4)
)
muv
(

    .din_i(din_tb),
    .shift_i(shift_tb),
    .clk_i(clk_tb),
    .reset_i(reset_tb),
    .wr_en_i(wr_en_tb),

    .dout_o(dout_o)

);


initial
begin
    clk_tb <= 0;
    shift_tb <= 0;
    din_tb <= 0;
    reset_tb <= 0;
    wr_en_tb <= 0;
    

    @(negedge clk_tb)
    wr_en_tb <= 1;
    din_tb <= 16'hABCD;
    @(negedge clk_tb)
    wr_en_tb <= 0;
    shift(3);
end


always
begin
    #10;
    clk_tb = ~clk_tb;
end


integer i;

task shift;
    input [10:0] N;
    begin
        for(i = 0; i < N; i = i+1)
        begin
            @(negedge clk_tb)
            shift_tb <= 1;
            @(negedge clk_tb)
            shift_tb <= 0;
        end
    end

endtask


initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, shift_reg_tb);
end

endmodule
