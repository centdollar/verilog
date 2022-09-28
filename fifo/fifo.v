// Created on 9/26/2022
// Author: Vincent Michelini
// Description: FIFO moudle to be used when testing the Lease Cache memory
// controller
// NOTES:
//          Right now the full_o and empty_o signals take an extra clock cycle to become high.
//          The PTR_SIG... both go high and then the corresponding output signals take another cycle to complete
//          REASONS:
//          1. the assignment of the PTR_SIG... occur in an always @(*) block so they will always just occur immediatly
//              - i feel like this is the reason and one clock cycle should not really affect the performace
//
//
//
// TODO: Optimize the code and remove redundancy, the first if statement is useless and their are def
//       assignments that are not needed
//       Basically improve the logic before pushing to main

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

// localparam for depth
localparam CLOG2_DEPTH = $clog2(depth);


// NOT NEEDED IN THIS DESIGN
// localparams for the states of the fifo
//localparam EMPTY = 3'b000;
//localparam READ  = 3'b001;
//localparam WRITE = 3'b010;
//localparam FULL  = 3'b011;
//localparam IDLE  = 3'b100;
//localparam RW    = 3'b101;

// defines
// the following two are for the read and write pointers wrap bit which is
// used to determine if the fifo is full or empty
`define RD_A_BITS read_ptr[CLOG2_DEPTH - 1:0] 
`define WR_A_BITS write_ptr[CLOG2_DEPTH - 1:0] 

`define RD_W_BIT read_ptr[CLOG2_DEPTH] 
`define WR_W_BIT write_ptr[CLOG2_DEPTH] 

// the following are used for the address bits for the read and write fifo
// pointers



// internal registers
//reg [2:0] cstate_r;       //NOT NEEDED
reg [width - 1 : 0] fifo_reg [depth - 1 : 0];

// read and write pointers
reg [CLOG2_DEPTH : 0] read_ptr;
reg [CLOG2_DEPTH : 0] write_ptr;

// initial state of the fifo
initial
begin
    full_o <= 0;
    empty_o <= 1;
    dout_o <= 'b0;
    read_ptr <= 0;
    write_ptr <= 0;
end

reg PTR_SIG_FULL;
reg PTR_SIG_EMPTY;


always @(*)
begin
    assign PTR_SIG_FULL = (`RD_W_BIT!=`WR_W_BIT)&&(`RD_A_BITS==`WR_A_BITS);
    assign PTR_SIG_EMPTY = (`RD_W_BIT==`WR_W_BIT)&&(`RD_A_BITS==`WR_A_BITS);
end

always @(posedge clk_i)
begin
    // synchronous reset
    if(reset_i)
    begin
        full_o <= 0;
        empty_o <= 1;
        read_ptr <= 0;
        write_ptr <= 0;
    end
    else
    begin
       
                if((!PTR_SIG_FULL) || (!PTR_SIG_EMPTY))     // This will never evaluate to the else statement
                begin
                    empty_o <= 0;
                    full_o <= 0;
                    if(wr_en_i && rd_en_i)
                    begin
                        if(PTR_SIG_EMPTY || PTR_SIG_FULL)
                        begin
                            if(PTR_SIG_EMPTY) empty_o <= 1;
                            else full_o <= 1;
                        end
                        else
                        begin
//                            cstate_r <= RW;
                            read_ptr <= read_ptr + 1;
                            write_ptr <= write_ptr + 1;
                            dout_o <= fifo_reg[read_ptr[CLOG2_DEPTH - 1 : 0]];
                            fifo_reg[write_ptr[CLOG2_DEPTH - 1 : 0]] <= din_i;
                            if(PTR_SIG_FULL) full_o <= 1;
                            if(PTR_SIG_EMPTY) empty_o <= 1;
                        end
                    end
                    else if(rd_en_i)
                    begin
                        
                        if(PTR_SIG_EMPTY)
                        begin
//                            cstate_r <= RW;
                            empty_o <= 1;
                        end
                        else
                        begin
//                            cstate_r <= RW;
                            read_ptr <= read_ptr + 1;
                            dout_o <= fifo_reg[read_ptr[CLOG2_DEPTH - 1 : 0]];
                            if(PTR_SIG_EMPTY) empty_o <= 1;
                        end
                    end
                    else if(wr_en_i)
                    begin
                        if(PTR_SIG_FULL)
                        begin
//                            cstate_r <= RW;
                            full_o <= 1;
                        end
                        else
                        begin
//                            cstate_r <= RW;
                            write_ptr <= write_ptr + 1;
                            fifo_reg[write_ptr[CLOG2_DEPTH - 1 : 0]] <= din_i;
                            if(PTR_SIG_FULL) full_o <= 1;
                        end
                    end
                    else
                    begin
                        if(PTR_SIG_FULL) full_o <= 1;
                        else if(PTR_SIG_EMPTY) empty_o <= 1;
//                        cstate_r <= RW;
                    end
                end
                else
                begin
                    if(PTR_SIG_FULL) full_o <= 1;
                    else empty_o <= 1;
//                    else cstate_r <= RW;
                end
            end
    end

endmodule
