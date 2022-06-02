module uart_rx#(
	parameter CLK_FREQ = 48000,
	parameter BAUD = 9600
)
(
	input clk,
	input rst_n,
	input rxd,
	output reg[7:0] rx_data,
	output reg rx_valid
);

	reg rxd_delay;
	reg [15:0] rx_sample_cntr;
	reg [3:0] rx_cntr;
	reg rx_stop;
	reg rx_busy;
	wire rx_start;
	wire rx_do_sample;

	parameter 	BAUD_DIVIDOR = CLK_FREQ / BAUD;

	//start_detect
	assign rx_start = ~rxd & rxd_delay;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rxd_delay <= 1'b0;
		else
			rxd_delay <= rxd;
	end
	//baudrate_counter
	assign rx_do_sample = (rx_sample_cntr == (BAUD_DIVIDOR/2)-1) ? 1'b1 : 1'b0;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			rx_sample_cntr <= 16'h0;
			rx_busy <= 1'b0;
		end
		else if(rx_start && ~rx_busy)begin
			rx_sample_cntr <= 16'h1;
			rx_busy <= 1'b1;
		end
		else if(rx_sample_cntr == BAUD_DIVIDOR - 1)
			rx_sample_cntr <= 16'h0;
		else if(rx_busy)
			rx_sample_cntr <= rx_sample_cntr + 1; 
	end
	//rx_data_counter
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rx_cntr <= 4'h0;
		else if(rx_cntr == 4'h8 && rx_sample_cntr == BAUD_DIVIDOR - 1)
			rx_cntr <= 4'h0;
		else if(rx_sample_cntr == BAUD_DIVIDOR - 1)
			rx_cntr <= rx_cntr + 1;
	end
	//rx_data_shifter
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			rx_data <= 8'd0;
			rx_valid <= 1'b0;
		end
		else if(rx_start && ~rx_busy)
			rx_data <= 8'h01;
		else if(rx_stop)begin
			rx_valid <= 1'b1;
			rx_busy <= 1'b0;
		end
		else if(rx_do_sample && rx_cntr)
			{rx_stop,rx_data[7:0]} <= {rx_data[7:0],rxd};
	end
	
endmodule
