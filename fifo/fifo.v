// Created on 9/26/2022
// Author: Vincent Michelini
// Description: FIFO moudle to be used when testing the Lease Cache memory
// controller

module fifo
#(
    // parameters that describe the fifo
    parameter width = 8,
    parameter depth = 8             // Use only powers of two so the parameterized read and write pointers do not get messed up

)

(
    
    input clk_i,                        // input clock where read and writes can occur
    input reset_i,                      // 1: reset         0: do not reset 
    input [width - 1 : 0] din_i,        // input data to be placed in fifo
    input wr_en_i,                      // 1: enable write to occur     0: not write occurs
    input rd_en_i,                      // 1: enable read to occur      0: no read occurs 
    output reg full_o,                      // 1: fifo is full              0: fifo is not full
    output reg empty_o,                     // 1: fifo is empty             0: fifo is not empty
    output reg [width - 1 : 0] dout_o       // output data bus to be read from fifo
    
);

// localparams for the states of the fifo
localparam EMPTY = 3'b000;
localparam READ  = 3'b001;
localparam WRITE = 3'b010;
localparam FULL  = 3'b011;
localparam IDLE  = 3'b100;

// defines
// the following two are for the read and write pointers wrap bit which is
// used to determine if the fifo is full or empty
`define RD_A_BITS read_ptr[clog2(depth)-1:0] 
`define WR_A_BITS write_ptr[clog2(depth)-1:0] 

`define RD_W_BIT read_ptr[clog2(depth)] 
`define WR_W_BIT write_ptr[clog2(depth)] 

// the following are used for the address bits for the read and write fifo
// pointers



// internal registers
reg [2:0] cstate_r;
reg [width - 1 : 0] fifo_reg [depth - 1 : 0];

// read and write pointers
reg [clog2(depth) : 0] read_ptr;
reg [clog2(depth) : 0] write_ptr;

// initial state of the fifo
initial
begin
    cstate_r <= EMPTY;
    full_o <= 0;
    empty_o <= 1;
    dout_o <= 'b0;
end



always @(posedge clk_i)
begin
    // synchronous reset
    if(reset_i)
    begin
        cstate_r <= EMPTY;
        full_o <= 0;
        empty_o <= 1;
    end
    else
    begin
        // start of fifo state machine
        case(cstate_r)
            
            EMPTY:
            begin
                if(wr_en_i) cstate_r <= WRITE;
                else if(rd_en_i) cstate <= READ;
                else cstate <= EMPTY;                
            end

            WRITE:
            begin
                write_ptr <= write_ptr + 1'b1;
                if((RD_W_BIT == WR_W_BIT) && (RD_A_BITS == WR_A_BITS))
                begin
                    cstate_r <= EMPTY;
                end
                else if((RD_W_BIT !+ WR_W_BIT) && (RD_A_BITS == WR_A_BITS))
                begin
                    cstate_r <= FULL;
                end
                else
                begin
                    fifo_reg[WR_A_BITS] <= din_i;
                end
            end
        endcase
    end
end

endmodule
