// Author: Vincent Michelini
// Description: verilog code for the FILO register, this will act as a stack
//              in future uses of this. Due to this the write and read enable
//              will be called push and pop respectively


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
reg [CLOG2 : 0] dataPtr;
reg FULL;
reg EMPTY;


always @(*)
begin
    FULL <= (dataPtr == DEPTH) ? 1 : 0;
    EMPTY <= (dataPtr == 0) ? 1 : 0;

    full_o <= FULL;
    empty_o <= EMPTY;
end


always @(posedge clk_i)
begin
    if(reset_i)
    begin
        dataPtr <= 0;
        dout_o <= 0;
    end
    else
    begin
        if(push_i && ~FULL)
        begin
            // TODO: redo this, first thought it to do a for loop to make it
            // parameterizable.
            // Think of other ways too
            stack[DEPTH - 1 : 0] <= {stack[DEPTH - 1 - 1 : 1], din_i};
        end    
    end
end


endmodule
