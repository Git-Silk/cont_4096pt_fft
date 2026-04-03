module cordic_tb;

reg clk;

reg signed [15:0] x;
reg signed [15:0] y;
reg signed [15:0] theta;

wire signed [15:0] xo;
wire signed [15:0] yo;

cordic_rotator_1 DUT(
.clk(clk),
.x_in(x),
.y_in(y),
.theta(theta),
.x_out(xo),
.y_out(yo)
);

always #5 clk = ~clk;

initial
begin

clk = 0;

x = 16'sd16384; // 0.5
y = 16'sd0;
theta = 16'sd8192; // 45°

#200;

$finish;

end

endmodule