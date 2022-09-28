// Created on 9/26/2022
// Author: Vincent Michelini
// Description: FIFO module to be used when testing the Lease Cache memory
// controller
// NOTES:
//
//
// TODO: Test furher and fix any edge cases that arise, for the time being the
// module works as intended and provieds fast feedback to upper modules

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

// defines
// the following two are for the read and write pointers wrap bit which is
// used to determine if the fifo is full or empty
`define RD_A_BITS read_ptr[CLOG2_DEPTH - 1:0] 
`define WR_A_BITS write_ptr[CLOG2_DEPTH - 1:0] 

`define RD_W_BIT read_ptr[CLOG2_DEPTH] 
`define WR_W_BIT write_ptr[CLOG2_DEPTH] 


// internal registers
reg [width - 1 : 0] fifo_reg [depth - 1 : 0];

// read and write pointers
reg [CLOG2_DEPTH : 0] read_ptr;
reg [CLOG2_DEPTH : 0] write_ptr;


// ptr signaling registers
reg PTR_SIG_FULL;
reg PTR_SIG_EMPTY;


// initial state of the fifo
initial
begin
    full_o <= 0;
    empty_o <= 1;
    dout_o <= 'b0;
    read_ptr <= 0;
    write_ptr <= 0;
end



always @(*)
begin
    PTR_SIG_FULL <= (`RD_W_BIT!=`WR_W_BIT)&&(`RD_A_BITS==`WR_A_BITS);
    PTR_SIG_EMPTY <= (`RD_W_BIT==`WR_W_BIT)&&(`RD_A_BITS==`WR_A_BITS);
    
    
    // This works really well and gets rid of the one clock cycle delay for
    // upper level to recieve its full or empty
    // This also reduces the number of times full and empty need to be
    // assigned in the CL
    full_o <= PTR_SIG_FULL ? 1 : 0;
    empty_o <= PTR_SIG_EMPTY ? 1 : 0;
end

// Used for debugging and can be removed or commented out in final release
reg inWrRd;

always @(posedge clk_i)
begin
    // synchronous reset
    if(reset_i)
    begin
        full_o <= 0;
        empty_o <= 1;
        read_ptr <= 0;
        write_ptr <= 0;
        inWrRd <= 0;
    end
    else
    begin
        // Enables the ability to read and write at the same time
        // Due to dout_o being a register it takes one clock cycle for the
        // output data to be available
        if(wr_en_i && rd_en_i)
        begin
            if(~(PTR_SIG_FULL || PTR_SIG_EMPTY))
            begin
                inWrRd <= 1;
                read_ptr <= read_ptr + 1;
                write_ptr <= write_ptr + 1;
                if(~(PTR_SIG_FULL || PTR_SIG_EMPTY))
                begin
                    dout_o <= fifo_reg[read_ptr[CLOG2_DEPTH - 1 : 0]];
                    fifo_reg[write_ptr[CLOG2_DEPTH - 1 : 0]] <= din_i;
                end
            end    
        end

        // Section for writing to the fifo
        else if(wr_en_i)
        begin
            if(~PTR_SIG_FULL)
            begin
                full_o <= 0;
                write_ptr <= write_ptr + 1;
                if(~PTR_SIG_FULL)
                begin
                    fifo_reg[write_ptr[CLOG2_DEPTH - 1 : 0]] <= din_i;
                    if(!PTR_SIG_EMPTY) empty_o <= 0;
                end
            end
        end

        // SEction for reading to the fifo
        else if(rd_en_i)
        begin
            if(~PTR_SIG_EMPTY)
            begin
                read_ptr <= read_ptr + 1;
                if(~PTR_SIG_EMPTY)
                begin
                    dout_o <= fifo_reg[read_ptr[CLOG2_DEPTH - 1 : 0]];
                end
            end
        end

        // If no read or write signals are high the fifo preserves its current
        // state until a control signal arrives
        else
        begin
            read_ptr <= read_ptr;
            write_ptr <= write_ptr;
        end


    end
end
endmodule
