`timescale 1ns / 1ns

module tb_axi_8bit_adder ();

reg clk = 0;

wire [15:0] sum_data;
wire sum_valid, sum_ready;

wire [7:0] term1_data; 
wire term1_valid, term1_ready;

wire [7:0] term2_data; 
wire term2_valid, term2_ready;

wire [15:0] result;

initial
	forever #5 clk = ~clk;

axi_8bit_transmitter_sync term1 (
	.clk(clk),
	.m_axis_data(term1_data),
	.m_axis_valid(term1_valid),
	.m_axis_ready(term1_ready)
);

axi_8bit_transmitter_sync term2 (
	.clk(clk),
	.m_axis_data(term2_data),
	.m_axis_valid(term2_valid),
	.m_axis_ready(term2_ready)
);

axi_8bit_adder adder (
	.clk(clk),
	.s_axis_data1(term1_data),
	.s_axis_valid1(term1_valid),
	.s_axis_ready1(term1_ready),

	.s_axis_data2(term2_data),
	.s_axis_valid2(term2_valid),
	.s_axis_ready2(term2_ready),

	.m_axis_data(sum_data),
	.m_axis_ready(sum_ready),
	.m_axis_valid(sum_valid)
);

axi_16bit_receiver res (
	.clk(clk),
	.s_axis_data(sum_data),
	.s_axis_valid(sum_valid),
	.s_axis_ready(sum_ready),
	.result(result)
);

initial
begin
	#500
	$finish;
end

initial
begin
    $dumpfile("test.vsd");
    $dumpvars;
end

endmodule