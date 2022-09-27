`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2022 07:42:42 PM
// Design Name: 
// Module Name: uart_tx_v
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Uart Transmitter for 8 bit no parity, 1 start and 1 stop bit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx_v
#(
parameter CLK_FREQ = 300000000,
parameter BAUD_RATE = 115200
)
(

input [7:0] i_data,
input i_clk,
input i_tx_send,
output reg o_tx,
output o_tx_hs,
output o_active

);
    
//Registers
reg [2:0]r_bit_index;
reg [11:0] r_clk_cnt;
reg [1:0] r_cstate;
reg [7:0] r_tx_data;
reg r_tx_active;
reg r_tx_done;

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
    r_tx_active <= 0;
end

always @(posedge i_clk)
begin

case (r_cstate)

    `IDLE :
    begin
        o_tx <= 1;
        r_tx_done <= 0;
        r_clk_cnt <= 0;
        r_bit_index <= 0;
        
        if(i_tx_send == 1'b1)
        begin
            r_tx_data <= i_data;
            r_tx_active <= 1;
            r_cstate <= `START;
        end
        else r_cstate <= `IDLE;
    end
    
    `START :
    begin
        o_tx <= 0;
        
        if(r_clk_cnt < `CLK_PER_BIT - 1)
        begin
            r_clk_cnt <= r_clk_cnt + 1;
            r_cstate <= `START;
        end
        else
        begin
            r_clk_cnt <= 0;
            r_cstate <= `DATA;
        end
    end
    
    `DATA :
    begin
        o_tx <= i_data[r_bit_index];
        
        if(r_clk_cnt < `CLK_PER_BIT - 1)
        begin
            r_clk_cnt <= r_clk_cnt + 1;
            r_cstate <= `DATA;
        end
        else
        begin
            r_clk_cnt <= 0;
            
            if(r_bit_index < 7)
            begin
                r_cstate <= `DATA;
                r_bit_index <= r_bit_index + 1;
            end
            else
            begin
                r_cstate <= `STOP;
                r_bit_index <= 0;
            end
        end
    end
    
    `STOP :
    begin
        o_tx <= 1;
        
        if(r_clk_cnt < `CLK_PER_BIT - 1)
        begin
            r_clk_cnt <= r_clk_cnt + 1;
            r_cstate <= `STOP;
        end
        else
        begin
            r_tx_done <= 1;
            r_clk_cnt <= 0;
            r_tx_active <= 0;
            r_cstate <= `IDLE;
        end
    end
endcase
end

//Assigns the active and handshake register to their respective output
assign o_tx_hs = r_tx_done;
assign o_tx_active = r_tx_active;

    
endmodule
