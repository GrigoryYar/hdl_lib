////////////////////////////////////////////////////////////////
//
// Project  : async_lib
// Function : async_fifo16_tb
// Engineer : Grigory Polushkin
// Created  : 10.07.2022
//
////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module async_fifo16_tb();

reg W_CLK = 0;
reg R_CLK = 0;
reg DIN = 0;
reg DIN_DV = 0;
wire DOUT;
wire DOUT_DV;

integer i;

parameter PERIOD_WR = 60;
parameter PERIOD_RD = 17;

always #(PERIOD_WR/2) W_CLK = ~W_CLK;
always #(PERIOD_RD/2) R_CLK = ~R_CLK;

initial begin
    #(10*PERIOD_WR);
    DIN_DV = 1;
    #(PERIOD_WR)
    DIN_DV = 0;

    #(100*PERIOD_WR);
    for (i = 0; i < 15; i = i + 1 ) 
    begin
        DIN = !DIN;
        DIN_DV = 1;
        #(PERIOD_WR);
        DIN_DV = 0;
        #(PERIOD_WR);
    end
end

async_fifo16
    async_fifo16_inst
    (
        .W_CLK      (W_CLK   ), // in,  u[1], write clock
        .DIN        (DIN     ), // in,  u[1], data to write
        .DIN_DV     (DIN_DV  ), // in,  u[1], input data valid

        .R_CLK      (R_CLK   ), // in,  u[1], read clock
        .DOUT       (DOUT    ), // out, u[1], data out
        .DOUT_DV    (DOUT_DV )  // out, u[1], output data valid
    );

reg FIFO_OUT = 0;
initial
begin
    forever 
    begin
        
        @(posedge R_CLK)
    
        if(DOUT_DV)
        begin
            FIFO_OUT <= DOUT;
            $display("FIFO_OUT",FIFO_OUT);
        end
    end 
end

endmodule