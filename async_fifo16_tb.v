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

parameter FIFO_WIDTH = 10;

reg  W_CLK = 0;
reg  [FIFO_WIDTH-1:0] DIN = 0;
reg  DIN_DV = 0;

reg  R_CLK = 0;
wire [FIFO_WIDTH-1:0] DOUT;
wire DOUT_DV;

integer i;

parameter PERIOD_WR = 37;
parameter PERIOD_RD = 36;

always #(PERIOD_WR/2.0) W_CLK = ~W_CLK;
always #(PERIOD_RD/2.0) R_CLK = ~R_CLK;

initial begin
    #(10*PERIOD_WR);
    @(posedge W_CLK)
    #0.1 DIN_DV = 1;
    @(posedge W_CLK)
    #0.1 DIN_DV = 0;

    #(20*PERIOD_WR);
    for (i = 1; i < 60; i = i + 1 ) 
    begin
        @(posedge W_CLK) 
        #0.1 DIN = i;
        DIN_DV = 1;
        //@(posedge W_CLK)
        //#0.5 DIN_DV = 0;
    end
    @(posedge W_CLK)
    #0.1 DIN_DV = 0;
end

async_fifo16
    #(
        .WIDTH      (FIFO_WIDTH)
    )
    async_fifo16_inst
    (
        .W_CLK      (W_CLK   ), // in,  u[1], write clock
        .DIN        (DIN     ), // in,  u[1], data to write
        .DIN_DV     (DIN_DV  ), // in,  u[1], input data valid

        .R_CLK      (R_CLK   ), // in,  u[1], read clock
        .DOUT       (DOUT    ), // out, u[1], data out
        .DOUT_DV    (DOUT_DV )  // out, u[1], output data valid
    );

initial
begin
    forever 
    begin
        @(posedge R_CLK)
        if(DOUT_DV)
            $display("FIFO_OUT: ", DOUT);
    end 
end

endmodule