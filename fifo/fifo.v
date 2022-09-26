// Created on 9/26/2022
// Author: Vincent Michelini
// Description: FIFO moudle to be used when testing the Lease Cache memory
// controller

module fifo
#(
    // parameters that describe the fifo
    parameter width = 8,
    parameter depth = 8

)

(
    
    input clk_i,                        // input clock where read and writes can occur
    input reset_i,                      // 1: reset         0: do not reset 
    input [width - 1 : 0] din_i,        // input data to be placed in fifo
    input er_en_i,                      // 1: enable write to occur     0: not write occurs
    input rd_en_i,                      // 1: enable read to occur      0: no read occurs 
    output full_o,                      // 1: fifo is full              0: fifo is not full
    output empty_o,                     // 1: fifo is empty             0: fifo is not empty
    output [width - 1 : 0] dout_o       // output data bus to be read from fifo
    
);

// localparams for the states of the fifo
localparam EMPTY = 2'b00;
localparam READ  = 2'b01;
localparam WRITE = 2'b10;
localparam FULL  = 2'b11;

// internal registers
reg [1:0] cstate_r;
reg [width - 1 : 0] fifo_reg [depth - 1 : 0];

// initial state of the fifo
initial
begin
    cstate_r <= EMPTY;
    full_o <= 0;
    empty_o <= 0;
    dout_o <= 'b0;
end



always @(posedge clk_i)
begin
    if(reset_i == 1'b1)
    begin
        cstate_r <= EMPTY;
        full_o <= 0;
        empty_o <= 1;

    end
end

endmodule
