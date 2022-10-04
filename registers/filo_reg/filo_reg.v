// Author: Vincent Michelini
// Description: verilog code for the FILO register, this will act as a stack
//              in future uses of this. Due to this the write and read enable
//              will be called push and pop respectively
//
// NOTE: To implement the STACK i am going to use pointers that point to the
// locations of the read and the write. A diagram is below
//              
//         time:    1 2 3 4 5 6 7 8     1 2 3 4 5 6 7 8
//                  wr                  rd
//     1:  []       x                   x
//     2:  []         x                   x
//     3:  []           x                   
//     4:  []
//     5:  []
//     6:  []
//     7:  []
//
//          The read pointer is always one behind the write pointer so the
//          read goes to the next space and the read points to the last
//          written space
//          
//          For now I am going to omit the full signal and just have the stack
//          circle to the beginning and overwrite the data that was written in
//          the beginning
//

module filo_reg
#(
    parameter DEPTH = 8,
    parameter WIDTH = 8
)
(
    input push_i,                   // push an item to the top of the stack
    input [WIDTH - 1 : 0] din_i,
    input pop_i,                    // pop an item from the top of the stack
    input clk_i,
    input reset_i,                  // 1: reset         0: no reset

    output reg [WIDTH - 1 : 0] dout_o,
    output reg full_o,
    output reg empty_o
);


localparam CLOG2 = $clog2(DEPTH);
integer i;

// registers that hold the data pushed into it
reg [WIDTH - 1 : 0] stack [DEPTH - 1 : 0];

// pointer that points to the end of the data in the stack, when it reaches
// the end of the stack, it signifies that the stack is full
reg [CLOG2 : 0] writePtr;
reg [CLOG2 : 0] readPtr;
reg FULL;
reg EMPTY;


always @(*)
begin
    FULL <= (writePtr == DEPTH) ? 1 : 0;
    EMPTY <= (writePtr == 0) ? 1 : 0;

    full_o <= FULL;
    empty_o <= EMPTY;
end


always @(posedge clk_i)
begin
    if(reset_i)
    begin
        writePtr <= 0;
        readPtr <= -1;
        dout_o <= 0;
    end
    else
    begin
        if(push_i && ~FULL)
        begin
            stack[writePtr] <= din_i;
            writePtr <= writePtr + 1;
            readPtr <= readPtr + 1;
        end
        else if(pop_i && ~EMPTY)
        begin
            dout_o <= stack[readPtr];
            writePtr <= writePtr - 1;
            readPtr <= readPtr - 1;
        end    
    end
end


endmodule
