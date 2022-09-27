`timescale 1ns/1ps
// AUTHOR: Vincent Michelini
// PURPOSE: Test bench for fifo.v
// DESCRIPTION: test bench for fifo.v




module fifo_tb();


localparam depth = 8;
localparam width = 8;

reg [width - 1 : 0] din_tb;
reg wr_en_tb;
reg rd_en_tb;
reg clk_tb;
reg reset_tb;

wire [width - 1 : 0] dout_tb;
wire full_tb;
wire empty_tb;



fifo
#(
    .depth(depth),
    .width(width)
)
muv
(
    .din_i(din_tb),
    .dout_o(dout_tb),
    .wr_en_i(wr_en_tb),
    .rd_en_i(rd_en_tb),
    .full_o(full_tb),
    .empty_o(empty_tb),
    .clk_i(clk_tb),
    .reset_i(reset_tb)

);


initial
begin
    reset_tb <= 1;
    din_tb <= 0;

    @(posedge clk_tb)
    reset_tb <= 0;
    din_tb <= 'hf0;
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;
    @(negedge clk_tb)
    wr_en_tb <= 1;
    @(posedge clk_tb)
    wr_en_tb <= 0;


    #20;
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
    @(negedge clk_tb)
    rd_en_tb <= 1;
    @(posedge clk_tb)
    rd_en_tb <= 0;
end

// Clock signal
always
begin

    clk_tb <= 0;
    #10;
    clk_tb <= 1;
    #10;

end


initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, fifo_tb);
end



endmodule
