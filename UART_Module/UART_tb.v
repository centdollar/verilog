`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2022 08:01:45 PM
// Design Name: 
// Module Name: UART_tb
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


module UART_tb();

//CLK_FREQ = 300000000;
//BAUDRATE = 115200;
parameter CLK_PERIOD_NS = 3.3;
parameter CLK_PER_BIT = 2604;       //CLK_FREQ/BAUDRATE
parameter BIT_PERIOD = 8593.2;


reg [7:0] tx_tb;
reg tx_start_tb;
reg clk_tb = 0;

wire tx_active_tb;
wire rx_active_tb;
wire tx_hs_tb;
wire rx_hs_tb;
wire [7:0] data_out_tb;
wire clk_tb_out;
wire serial_line;



uart_tx_v tx(
.i_data(tx_tb),
.i_clk(clk_tb),
.i_tx_send(tx_start_tb),
.o_tx(serial_line),
.o_tx_hs(tx_hs_tb),
.o_active(tx_active_tb)

);

uart_rx rx(
.i_rx_serial(serial_line),
.i_clk(clk_tb),
.o_rx_bus(data_out_tb),
.o_rx_hs(rx_hs_tb),
.o_rx_active(rx_active_tb)

);





//Have the clock switch states with hald the period of a whole wave
//always 
//begin
//clk_tb <= ~clk_tb;
//#(CLK_PERIOD_NS/2);
//clk_tb <= ~clk_tb;
//#(CLK_PERIOD_NS/2);
//end
//#(CLK_PERIOD_NS/2) clk_tb <= !clk_tb;

integer i;

initial
begin
    forever begin
        clk_tb <= ~clk_tb;
        #(CLK_PERIOD_NS/2);
        clk_tb <= ~clk_tb;
        #(CLK_PERIOD_NS/2);
    end
end
    
initial
begin
    //TELL UART TO SEND DATA
    for(i = 0; i < 10; i = i+1) begin
    @(posedge clk_tb);
    end
    tx_start_tb <= 1'b1;
    tx_tb <= 8'hAB;
    @(posedge clk_tb);
    tx_start_tb <= 1'b0;
    @(posedge rx_hs_tb);
    if (data_out_tb == 8'hAB) $display("TEST PASSES");
    else $display("TEST FAILED");
    
end

assign clk_tb_out = clk_tb;


endmodule
