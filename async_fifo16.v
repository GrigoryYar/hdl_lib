////////////////////////////////////////////////////////////////
//
// Project  : async_lib
// Function : async_fifo16
// Engineer : Grigory Polushkin
// Created  : 10.07.2022
//
////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

/*
async_fifo16
    async_fifo16_inst
    (
        .W_CLK      ( ), // in,  u[1], write clock
        .DIN        ( ), // in,  u[1], data to write
        .DIN_DV     ( ), // in,  u[1], input data valid

        .R_CLK      ( ), // in,  u[1], read clock
        .DOUT       ( ), // out, u[1], data out
        .DOUT_DV    ( )  // out, u[1], output data valid
    );
*/

module async_fifo16
    (
        input   wire    W_CLK,
        input   wire    DIN,
        input   wire    DIN_DV,

        input   wire    R_CLK,
        output  wire    DOUT,
        output  wire    DOUT_DV
    );

reg [3:0] r_wr_pointer = 4'h0;
reg [3:0] r_rd_pointer = 4'h0;

reg [15:0]  r_data;
reg         r_dout;
reg r_dout_dv = 1'b0;
wire w_not_equal;
reg  r_not_equal;

assign w_not_equal = (r_wr_pointer == r_rd_pointer) ? 1'b0 : 1'b1;
assign DOUT_DV = r_not_equal;
assign DOUT = r_dout;


always @(posedge W_CLK)
begin
    if( DIN_DV )
    begin
        r_data[{r_wr_pointer[3], r_wr_pointer[3]^r_wr_pointer[2], r_wr_pointer[2]^r_wr_pointer[1], r_wr_pointer[1]^r_wr_pointer[0]}] <= DIN;
        r_wr_pointer <= r_wr_pointer + 1'b1;
    end
end

always @(posedge R_CLK)
begin
    if(w_not_equal)
    begin
        r_rd_pointer <= r_rd_pointer + 1'b1;
    end
    r_not_equal <= w_not_equal;
    r_dout <= r_data[{r_rd_pointer[3], r_rd_pointer[3]^r_rd_pointer[2], r_rd_pointer[2]^r_rd_pointer[1], r_rd_pointer[1]^r_rd_pointer[0]}];
end


endmodule