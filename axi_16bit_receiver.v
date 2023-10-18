`timescale 1ns / 1ns

module axi_16bit_receiver (
	input clk,
	input [15:0] s_axis_data,
	input s_axis_valid,
	output reg s_axis_ready = 1,
	output reg [15:0] result = 0
);

reg [7:0] latency;
reg is_latency;

always @(posedge clk)
begin
	if (s_axis_valid == 1 & s_axis_ready == 1)
	begin
		result <= s_axis_data;
		s_axis_ready <= 0;
		is_latency <= 1;
	end
end

always @(*)
begin
	if (is_latency == 1)
	begin
		latency = $urandom_range(50,20);
		#latency;
		is_latency = 0;
	end
end

always @(posedge clk)
begin
	if (is_latency == 0 & s_axis_ready == 0)
		s_axis_ready <= 1;
end


endmodule