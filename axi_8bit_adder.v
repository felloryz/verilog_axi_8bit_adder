`timescale 1ns / 1ns

module axi_8bit_adder (
	input clk,

	input [7:0] s_axis_data1,
	input s_axis_valid1,
	output s_axis_ready1,

	input [7:0] s_axis_data2,
	input s_axis_valid2,
	output s_axis_ready2,

	output reg [15:0] m_axis_data,
	output reg m_axis_valid = 0,
	input m_axis_ready	
);

reg [7:0] s_axis_data1_buf = 0;
reg [7:0] s_axis_data2_buf = 0;

reg is_s_axis_data1 = 0;
reg is_s_axis_data2 = 0;

reg s_axis_ready1_state = 1;
reg s_axis_ready2_state = 1;

assign s_axis_ready1 = s_axis_ready1_state;
assign s_axis_ready2 = s_axis_ready2_state; 

always @(posedge clk)
begin

	if (m_axis_valid == 1 & m_axis_ready == 1)
	begin
		m_axis_valid <= 0;
	end

	if ((s_axis_valid1 == 1 & s_axis_ready1 == 1) & (s_axis_valid2 == 1 & s_axis_ready2 == 1) & ((m_axis_valid == 0) | (m_axis_valid == 1 & m_axis_ready == 1)))
	begin
		m_axis_data <= s_axis_data1 + s_axis_data2;
		m_axis_valid <= 1;
	end
	else if (s_axis_valid1 == 1 & s_axis_ready1 == 1)
	begin
		if ((is_s_axis_data2 == 1) & ((m_axis_valid == 0) | (m_axis_valid == 1 & m_axis_ready == 1)))
		begin
			m_axis_data <= s_axis_data1 + s_axis_data2_buf;
			is_s_axis_data2 <= 0;
			s_axis_ready2_state <= 1;
			m_axis_valid <= 1;
		end
		else
		begin
			s_axis_data1_buf <= s_axis_data1;
			is_s_axis_data1 <= 1;
			s_axis_ready1_state <= 0;
		end
	end
	else if (s_axis_valid2 == 1 & s_axis_ready2 == 1)
	begin
		if ((is_s_axis_data1 == 1) & ((m_axis_valid == 0) | (m_axis_valid == 1 & m_axis_ready == 1)))
		begin
			m_axis_data <= s_axis_data2 + s_axis_data1_buf;
			is_s_axis_data1 <= 0;
			s_axis_ready1_state <= 1;
			m_axis_valid <= 1;
		end
		else
		begin
			s_axis_data2_buf <= s_axis_data2;
			is_s_axis_data2 <= 1;
			s_axis_ready2_state <= 0;
		end
	end
	else if ((is_s_axis_data1 == 1 & is_s_axis_data2 == 1) & ((m_axis_valid == 0) | (m_axis_valid == 1 & m_axis_ready == 1)))
	begin
		m_axis_data <= s_axis_data1_buf + s_axis_data2_buf;
		is_s_axis_data1 <= 0;
		s_axis_ready1_state <= 1;
		is_s_axis_data2 <= 0;
		s_axis_ready2_state <= 1;
		m_axis_valid <= 1;
	end

end

endmodule