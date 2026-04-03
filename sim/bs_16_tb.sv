`timescale 1ns/1ps

module bs16_complex_tb;

    // Clock
    logic clk;

    // Inputs
    logic signed [19:0] x [0:15][0:1];

    // Outputs
    logic signed [19:0] X [0:15][0:1];

    // Instantiate DUT
    bs16_complex dut (
        .x(x),
        .clk(clk),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;

    initial begin

        // Initialize inputs
        for(i = 0; i < 16; i = i + 1) begin
            x[i][0] = 0;   // real
            x[i][1] = 0;   // imag
        end

        #20;

        // Test case 1: impulse input
        x[4][0] = -16'sd1;
        x[4][1] = 16'sd0;

        #50;

        $display("Output:");
        for(i = 0; i < 16; i = i + 1) begin
            $display("X[%0d] = %0d + j%0d", i, X[i][0], X[i][1]);
        end

        #20;

        // Test case 2: random values
        for(i = 0; i < 16; i++) begin
            x[i][0] = $urandom_range(-5000, 5000);
            x[i][1] = $urandom_range(-5000, 5000);
        end

        #50;

        $display("Random test output:");
        for(i = 0; i < 16; i = i + 1) begin
            $display("X[%0d] = %0d + j%0d", i, X[i][0], X[i][1]);
        end

        #20;
        $finish;

    end

endmodule
