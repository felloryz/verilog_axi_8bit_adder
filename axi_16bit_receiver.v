`timescale 1ns / 1ns

module axi_16bit_receiver (
	input clk,
	input [15:0] s_axis_data,
	input s_axis_valid,
	output reg s_axis_ready = 1,
	output reg [15:0] result = 0
);

parameter 	HIGH_RANGE = 50,
			LOW_RANGE = 20;

reg [7:0] latency;
reg is_latency;

always @(posedge clk)
begin
	if (s_axis_valid & s_axis_ready)
	begin
		result <= s_axis_data;
		if (!HIGH_RANGE & !LOW_RANGE)
			s_axis_ready <= 1;
		else
		begin
			s_axis_ready <= 0;
			is_latency <= 1;
		end
	end
end

always @(*)
begin
	if (is_latency)
	begin
		latency = $urandom_range(HIGH_RANGE,LOW_RANGE);
		#latency;
		is_latency = 0;
	end
end

always @(posedge clk)
begin
	if (!is_latency & !s_axis_ready)
		s_axis_ready <= 1;
end


endmodule