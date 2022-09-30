// Author: Vincent Michelini
// Description: This is a serial in parallel out register
//              the serial data in will be pushed out of the reigster once the
//              register is full


module SIPO_reg
#(

)
(

    input serial_data_i,
    input wr_en_i,
    input reset_i,              // 1: reset     0: no reset
    input clk_i,     

    output reg [7 : 0]  dout_bus_o,
    output data_ready
);

reg write_cnt_r;



endmodule
