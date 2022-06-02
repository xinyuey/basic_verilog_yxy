`timescale 1us/1ns

module uart_tx_rx_tb();
	reg clk,rst_n;
	reg [7:0] tx_data;
	reg tx_start;
	wire serial_data;
	wire tx_busy;
	wire [7:0] rx_data;
	wire rx_valid;

	uart_tx u1(
		.clk(clk),
		.rst_n(rst_n),
		.tx_data(tx_data),
		.tx_start(tx_start),
		.txd(serial_data),
		.tx_busy(tx_busy)
		);
	uart_rx u2(
		.clk(clk),
		.rst_n(rst_n),
		.rxd(serial_data),
		.rx_data(rx_data),
		.rx_valid(rx_valid)
		);

	initial begin
		clk = 1'b0;
		forever #10 clk = ~clk;
	end
	
	initial begin
		rst_n = 1'b1;
		#15 rst_n = 1'b0;
		#5 rst_n = 1'b1;
	end
	
	initial begin
	#20
		tx_data = 8'b10001100;
		tx_start = 1'b1;
	#20
		tx_start = 1'b0;
	#2000
		$stop;
	end
	
endmodule
