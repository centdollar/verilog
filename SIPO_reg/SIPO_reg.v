// Author: Vincent Michelini
// Description: This is a serial in parallel out register
//              the serial data in will be pushed out of the reigster once the
//              register is full
//              By Default the serial input shifts its data in from the LSB
//
//
// NOTES:   One note is that the output data_ready signal does not come out
//          until the next clock cycle, this could lose a cycle of time, but
//          it also means that the module pulling the bus data will always get
//          proper data
//   
//
// TODO:    Could add functionality for making it a
//          shift or could make it shift the data in from the other side going
//          from 7 down to 0 instead of 0 to 7
//          This can be done with params and then based on the params being
//          true or false and then change the always block based on these
//          params using if else if

module SIPO_reg
#(
    parameter OUTPUT_BW = 8,
    parameter SHIFT_LEFT = 1,       // shifts into the LSB of output bus
    parameter SHIFT_RIGHT = 0       // shifts into the MSB of output bus
)       
(

    input serial_data_i,
    input wr_en_i,
    input reset_i,              // 1: reset     0: no reset
    input clk_i,     

    output reg [OUTPUT_BW - 1 : 0]  dout_bus_o,
    output reg data_ready_o           // 1: ready to read     0: not ready to read
);


localparam CLOG2_BW = $clog2(OUTPUT_BW);
reg [CLOG2_BW : 0] write_cnt_r;

always @(posedge clk_i)
begin
    if(reset_i)
    begin
        write_cnt_r <= 0;
        dout_bus_o <= 0;
        data_ready_o <= 0;
    end
    else
    begin
        if(wr_en_i)
        begin
            if(write_cnt_r == OUTPUT_BW)
            begin
                data_ready_o <= 1;
                write_cnt_r <= 0;
            end
            else
            begin
                if(SHIFT_LEFT & !SHIFT_RIGHT)
                begin
                    dout_bus_o <= {dout_bus_o[OUTPUT_BW - 1  - 1 : 0], serial_data_i};
                    write_cnt_r <= write_cnt_r + 1;
                end
                else if(SHIFT_RIGHT & !SHIFT_LEFT)
                begin
                    dout_bus_o <= {serial_data_i, dout_bus_o[OUTPUT_BW - 1 : 1]};
                    write_cnt_r <= write_cnt_r + 1;
                end
                else
                begin
                    write_cnt_r <= 0;
                    data_ready_0 <= 0;
                end
            end
        end
        else  data_ready_o <= 0;


    end



end


endmodule
