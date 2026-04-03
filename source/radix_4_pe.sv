`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2026 15:44:39
// Design Name: 
// Module Name: radix_4_pe
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


`timescale 1ns / 1ps

module radix_4_pe #(
    parameter IN_WIDTH  = 16,
    parameter INT_WIDTH = 18  
)(
    input  logic signed [IN_WIDTH-1:0] x_re [4],
    input  logic signed [IN_WIDTH-1:0] x_im [4],

    output logic signed [IN_WIDTH-1:0] X_re [4],
    output logic signed [IN_WIDTH-1:0] X_im [4]
);

    logic signed [INT_WIDTH-1:0] A_re, A_im;
    logic signed [INT_WIDTH-1:0] B_re, B_im;
    logic signed [INT_WIDTH-1:0] C_re, C_im;
    logic signed [INT_WIDTH-1:0] D_re, D_im;

    logic signed [INT_WIDTH-1:0] X0_re_int, X0_im_int;
    logic signed [INT_WIDTH-1:0] X1_re_int, X1_im_int;
    logic signed [INT_WIDTH-1:0] X2_re_int, X2_im_int;
    logic signed [INT_WIDTH-1:0] X3_re_int, X3_im_int;

    always_comb begin

        A_re = x_re[0] + x_re[2];
        A_im = x_im[0] + x_im[2];

        B_re = x_re[1] + x_re[3];
        B_im = x_im[1] + x_im[3];

        C_re = x_re[0] - x_re[2];
        C_im = x_im[0] - x_im[2];

        D_re = x_re[1] - x_re[3];
        D_im = x_im[1] - x_im[3];

        X0_re_int = A_re + B_re;
        X0_im_int = A_im + B_im;

        X2_re_int = A_re - B_re;
        X2_im_int = A_im - B_im;

        X1_re_int = C_re + D_im;
        X1_im_int = C_im - D_re;

        X3_re_int = C_re - D_im;
        X3_im_int = C_im + D_re;

        X_re[0] = X0_re_int[IN_WIDTH-1:0];
        X_im[0] = X0_im_int[IN_WIDTH-1:0];

        X_re[1] = X1_re_int[IN_WIDTH-1:0];
        X_im[1] = X1_im_int[IN_WIDTH-1:0];

        X_re[2] = X2_re_int[IN_WIDTH-1:0];
        X_im[2] = X2_im_int[IN_WIDTH-1:0];

        X_re[3] = X3_re_int[IN_WIDTH-1:0];
        X_im[3] = X3_im_int[IN_WIDTH-1:0];

    end

endmodule
