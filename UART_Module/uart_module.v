`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2022 09:15:27 AM
// Design Name: 
// Module Name: uart_module
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


module uart_module
//parameters
#(
parameter BAUD_RATE = 115200,
parameter CLK_FREQ = 300000000
)
//ports
(
input i_data,                   //Serial Data in for reciever
input [3:0] i_data_bus,         //Bus data in for transmitter
input i_clk,                    //Clock Signal
input i_transmit,               //Control Signal to let the transmitter send data                          
                                 //Output info signal that says when the data has been transmitted
output [7:0] o_data_bus,        //Output data bus from reciever
output o_serial                //Serial output from transmitter
                            //Output info signal for when the transmitter is currently sending data
);
    
wire o_data_transmitted;
wire o_tx_active;
wire w_rx_hs;
wire w_rx_active;
//Instantiate the reciever
uart_rx 
#(
.BAUD_RATE(BAUD_RATE), 
.CLK_FREQ(CLK_FREQ)
)
reciever 
(
.i_rx_serial(i_data), 
.i_clk(i_clk), 
.o_rx_bus(o_data_bus),
.o_rx_hs(w_rx_hs),
.o_rx_active(w_rx_active)
);

//instantiate the transmitter
uart_tx_v
#(
.BAUD_RATE(BAUD_RATE),
.CLK_FREQ(CLK_FREQ)
)
transmitter
(
.i_data({4'b0011, i_data_bus}),
.i_clk(i_clk),
.i_tx_send(i_transmit),
.o_tx(o_serial),
.o_tx_hs(o_data_transmitted),
.o_active(o_tx_active)
);

endmodule
