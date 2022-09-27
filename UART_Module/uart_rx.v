`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2022 10:33:15 AM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx 
#(
parameter BAUD_RATE = 115200, 
parameter CLK_FREQ = 300000000,
parameter BUS_WIDTH = 8
)
(
input i_rx_serial, 
input i_clk, 
output reg [BUS_WIDTH - 1 : 0] o_rx_bus,
output o_rx_hs,
output o_rx_active
);

//Registers
reg [2:0]r_bit_index;
reg [11:0] r_clk_cnt;
reg [1:0] r_cstate;
reg [BUS_WIDTH - 1 : 0] r_rx_data_bus;
reg r_rx_active;
reg r_rx_done;

//Definitions
`define IDLE 0
`define START 1
`define DATA 2
`define STOP 3
`define CLK_PER_BIT 2604

initial
begin
    r_clk_cnt <= 0;
    r_cstate <= `IDLE;
    r_bit_index <= 0;
    r_rx_active <= 0;
    r_rx_done <= 0;
end

always @(posedge i_clk)
begin

case (r_cstate)

    `IDLE :
    begin
        r_rx_done <= 0;
        r_clk_cnt <= 0;
        r_bit_index <= 0;
        r_rx_active <= 0;
        if(i_rx_serial == 0)
        begin
            r_cstate <= `START;
        end
        else
        begin
            r_cstate <= `IDLE;
        end
    end
    
    `START :
    begin
        if(i_rx_serial == 1)
        begin
            r_cstate <= `IDLE;
        end
        else
        begin
            if(r_clk_cnt > `CLK_PER_BIT / 2)
            begin
                r_clk_cnt <= 0;
                r_bit_index <= 0;
                r_cstate <= `DATA;
            end
            else
            begin
                r_clk_cnt <= r_clk_cnt + 1;
                r_cstate <= `START;
            end
        end
    end
    
    `DATA :
    begin
        r_rx_active <= 1;
        if(r_clk_cnt < `CLK_PER_BIT - 1)
        begin
            r_clk_cnt <= r_clk_cnt + 1;
            r_cstate <= `DATA;
        end
        else
        begin
            r_clk_cnt <= 0;
            o_rx_bus[r_bit_index] <= i_rx_serial;
            if(r_bit_index < 7)
            begin
                r_bit_index <= r_bit_index + 1;
                r_cstate <= `DATA;
            end
            else
            begin
                r_bit_index <= 0;
                r_cstate <= `STOP;
            end
        end
    end
    
    `STOP :
    begin
        if(r_clk_cnt < `CLK_PER_BIT - 1)
        begin
            r_clk_cnt <= r_clk_cnt + 1;
            r_cstate <= `STOP;
        end
        else
        begin
            r_rx_done <= 1;
            r_clk_cnt <= 0;
            r_rx_active <= 0;
            r_cstate <= `IDLE;
        end
    end
endcase
end

//Assigns the active and handshake register to their respective output
assign o_rx_hs = r_rx_done;
assign o_rx_active = r_rx_active;

endmodule
