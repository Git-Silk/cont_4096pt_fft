module pe_stage1_tb;

    // Clock & reset
    logic clk;
    logic rst;

    // DUT I/O
    logic signed [15:0] x_stage1 [0:15][0:1];
    logic signed [15:0] X_stage1 [0:15][0:1];

    // Instantiate DUT
    pe_stage1 dut (
        .clk(clk),
        .rst(rst),
        .x_stage1(x_stage1),
        .X_stage1(X_stage1)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Function to generate random 16-bit signed values
    function automatic logic signed [15:0] rand16();
        rand16 = $urandom_range(-32768, 32767);
    endfunction

    // Test procedure
    initial begin
        clk = 0;
        rst = 1;

        // Initialize
        for (int i = 0; i < 16; i++) begin
            x_stage1[i][0] = 0;
            x_stage1[i][1] = 0;
        end

        // Release reset
        #20;
        rst = 0;

        // ? Apply multiple random test vectors
        repeat (20) begin

            // Apply new random input
            for (int i = 0; i < 16; i++) begin
                x_stage1[i][0] = rand16();  // real
                x_stage1[i][1] = rand16();  // imag
            end

            // Run for some cycles (let pipeline settle)
            repeat (20) @(posedge clk);

        end

        $finish;
    end

    // Monitor (keep it light, or you'll flood console)
    initial begin
        $monitor("Time=%0t | n=%0d | X0=(%0d,%0d)",
            $time,
            dut.n_counter,
            X_stage1[0][0],
            X_stage1[0][1]
        );
    end

endmodule