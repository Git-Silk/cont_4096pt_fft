module pe_stage2( 
    input logic clk,
    input logic rst,
    input  logic signed [15:0] x_stage2 [0:15][0:1], 
    output logic signed [15:0] X_stage2 [0:15][0:1] 
);

    logic signed [15:0] bs_out [0:15][0:1];

    bs16_complex bs_inst (
        .clk(clk),
        .x(x_stage2),
        .X(bs_out)
    );
    
    assign X_stage2[0][0] = bs_out[0][0];
    assign X_stage2[0][1] = bs_out[0][1];
    
    logic unsigned [20:0] theta_temp [0:14];
    logic unsigned [16:0] theta_scaled [0:14];
    logic signed [15:0] theta [0:14];
    logic signed [15:0] x_cordic_in [0:14][0:1];
    
    logic [7:0] n_counter;
    logic [7:0] n;
    
    
    always_ff @(posedge clk) begin
        if (rst) begin
            n_counter <= 8'd0;
        end else begin
            n_counter <= n_counter + 1;
        end
    end
  
    assign n = {n_counter[3:0], n_counter[7:4]};
    
    always_comb begin   
        for (int k = 0; k < 15; k++) begin
           theta_temp[k] = n * (k+1) * 256;
           theta_scaled[k] = -{1'b0,theta_temp[k][15:0]};
        end
    end  
     
     always_comb begin
    for (int k = 0; k < 15; k++) begin

        if (theta_scaled[k] >= -17'sd16384) begin
            // -0.5 ? 0
            x_cordic_in[k][0] = bs_out[k+1][0];
            x_cordic_in[k][1] = bs_out[k+1][1];
            theta[k] = theta_scaled[k];

        end else if (theta_scaled[k] >= -17'sd32768) begin
            // -1 ? -0.5
            x_cordic_in[k][0] =  bs_out[k+1][1];
            x_cordic_in[k][1] = -bs_out[k+1][0];
            theta[k] = theta_scaled[k] + 17'sd16384;

        end else if (theta_scaled[k] >= -17'sd49152) begin
            // -1.5 ? -1
            x_cordic_in[k][0] = -bs_out[k+1][1];
            x_cordic_in[k][1] =  bs_out[k+1][0];
            theta[k] = theta_scaled[k] + 17'sd49152;

        end else begin
            // -2 ? -1.5
            x_cordic_in[k][0] = bs_out[k+1][0];
            x_cordic_in[k][1] = bs_out[k+1][1];
            theta[k] = theta_scaled[k] + 18'sd65536;

        end

    end
end
    

    genvar i;
    generate
        for (i = 0; i < 15; i++) begin : cordic_block
            cordic_rotator_1 cordic_inst (
                .clk(clk),
                .x_in(x_cordic_in[i][0]),
                .y_in(x_cordic_in[i][1]),   
                .theta(theta[i]),           
                .x_out(X_stage2[i+1][0]),
                .y_out(X_stage2[i+1][1])
            );
        end
    endgenerate

endmodule