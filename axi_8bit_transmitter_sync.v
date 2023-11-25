`timescale 1ns / 1ns

module axi_8bit_transmitter_sync (
	input clk,
	input m_axis_ready,
	output reg m_axis_valid = 1,
	output [7:0] m_axis_data
);

parameter 	HIGH_RANGE = 20,
			LOW_RANGE = 0;

reg [7:0] number;
reg [7:0] latency;

reg is_latency;

assign m_axis_data = number;

initial
	number = $urandom%8'hFF;

always @(posedge clk)
begin
	if (m_axis_valid & m_axis_ready)
	begin
		if (!HIGH_RANGE & !LOW_RANGE)
		begin
			number <= $urandom_range(8'hFF,0);
			m_axis_valid <= 1;
		end
		else
		begin
			m_axis_valid <= 0;
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
	if (!is_latency & !m_axis_valid)
	begin
		number <= $urandom_range(8'hFF,0);
		m_axis_valid <= 1;
	end
end

endmodule