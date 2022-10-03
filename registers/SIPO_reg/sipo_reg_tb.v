`timescale 1ns/1ps


module sipo_reg_tb();

reg serial_data_tb;
reg wr_en_tb;
reg clk_tb;
reg reset_tb;


wire [BW - 1  : 0] dout_tb;
wire data_rdy_tb;


localparam BW = 4;

SIPO_reg #(
    .OUTPUT_BW(BW),
    .SHIFT_LEFT(0),
    .SHIFT_RIGHT(1)
)
muv
(
    .clk_i(clk_tb),
    .reset_i(reset_tb),
    .wr_en_i(wr_en_tb),
    .serial_data_i(serial_data_tb),
    .dout_bus_o(dout_tb),
    .data_ready_o(data_rdy_tb)

);



always
begin
clk_tb <= 0;
#10;
clk_tb <= 1;
#10;
end


initial
begin

    reset_tb <= 1;
    serial_data_tb <= 0;
    wr_en_tb <= 0;
    #10; 
    @(posedge clk_tb)
    write(4);
    @(negedge data_rdy_tb)
    write(16);

end


initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, sipo_reg_tb);
end

integer i;

task  write;
    input [10 : 0]  N;
    begin
        for(i = 0; i < N; i = i + 1)
        begin
            @(negedge clk_tb)
            serial_data_tb <= 1;
            wr_en_tb <= 1;
            @(negedge clk_tb)
            wr_en_tb <= 0;
            
        end
    end

endtask






endmodule
