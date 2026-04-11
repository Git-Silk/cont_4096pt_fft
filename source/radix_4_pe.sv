module radix_4_pe #(
    parameter IN_WIDTH  = 16,
    parameter INT_WIDTH = 18  
)(
    input  logic signed [IN_WIDTH-1:0] x_re [4],
    input  logic signed [IN_WIDTH-1:0] x_im [4],

    output logic signed [IN_WIDTH-1:0] X_re [4],
    output logic signed [IN_WIDTH-1:0] X_im [4]
);

    logic signed [INT_WIDTH-1:0] a_re, a_im;
    logic signed [INT_WIDTH-1:0] b_re, b_im;
    logic signed [INT_WIDTH-1:0] c_re, c_im;
    logic signed [INT_WIDTH-1:0] d_re, d_im;

    always_comb begin

        a_re = x_re[0] + x_re[2];
        a_im = x_im[0] + x_im[2];

        b_re = x_re[1] + x_re[3];
        b_im = x_im[1] + x_im[3];

        c_re = x_re[0] - x_re[2];
        c_im = x_im[0] - x_im[2];

        d_re = x_re[1] - x_re[3];
        d_im = x_im[1] - x_im[3];

        X_re[0] = (a_re + b_re) >>> 2;
        X_im[0] = (a_im + b_im) >>> 2;

        X_re[2] = (a_re - b_re) >>> 2;
        X_im[2] = (a_im - b_im) >>> 2;

        X_re[1] = (c_re + d_im) >>> 2;
        X_im[1] = (c_im - d_re) >>> 2;

        X_re[3] = (c_re - d_im) >>> 2;
        X_im[3] = (c_im + d_re) >>> 2;

    end

endmodule