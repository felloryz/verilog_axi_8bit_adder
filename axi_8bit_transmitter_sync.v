`timescale 1ns / 1ns

module axi_8bit_transmitter_sync (
	input clk,
	input m_axis_ready,
	output reg m_axis_valid = 1,
	output [7:0] m_axis_data
);

reg [7:0] number;
reg [7:0] latency;

reg is_latency;

assign m_axis_data = number;

initial
	number = $urandom%8'hFF;

always @(posedge clk)
begin
	if (m_axis_valid == 1 & m_axis_ready == 1)
	begin
		m_axis_valid <= 0;
		is_latency <= 1;
	end
end

always @(*)
begin
	if (is_latency == 1)
	begin
		latency = $urandom_range(60,20);
		#latency;
		is_latency = 0;
	end
end

always @(posedge clk)
begin
	if (is_latency == 0 & m_axis_valid == 0)
	begin
		number <= $urandom_range(8'hFF,0);
		m_axis_valid <= 1;
	end
end

endmodule