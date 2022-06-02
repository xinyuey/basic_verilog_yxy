module uart_tx#(
	parameter CLK_FREQ = 48000,
	parameter BAUD = 9600
)(
	input clk,
	input rst_n,
	input [7:0] tx_data,
	input tx_start,
	output reg txd,
	output reg tx_busy);

	reg [15:0] tx_sample_cntr;
	reg [3:0] tx_cntr;
	reg [1:0] tx_state,tx_nextstate;

	parameter 	BAUD_DIVIDOR = CLK_FREQ / BAUD;
	parameter 	IDLE = 2'b00,
				SEND = 2'b01,
				STOP = 2'b10;

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			tx_state <= IDLE;
		else
			tx_state <= tx_nextstate;
	end
	
	always@* begin
		if(!rst_n)begin
			tx_nextstate <= IDLE;
			tx_cntr <= 2'b00;
		end
		else begin
			case(tx_state)
				IDLE:begin
					if(tx_start == 1'b1)
						tx_nextstate <= SEND;
					else
						tx_nextstate <= IDLE;
				end
				SEND:begin
					if(tx_cntr == 9)
						tx_nextstate <= STOP;
					else
						tx_nextstate <= SEND;
				end
				STOP:begin
					if(tx_start)
						tx_nextstate <= STOP;
					else
						tx_nextstate <= IDLE;
				end
				default:tx_nextstate <= IDLE;
			endcase
		end
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			txd <= 1'b1;
			tx_busy <= 1'b0;
			tx_cntr <= 4'd0;
			tx_sample_cntr <= 16'd0;
		end
		else begin
			case(tx_state)
				IDLE:begin
					txd <= 1'b1;
					tx_busy <= 1'b0;
					tx_cntr <= 4'd0;
				end
				SEND:begin
					if(tx_sample_cntr == BAUD_DIVIDOR/2 - 1)begin
						case(tx_cntr)
							4'd0:	txd <= 1'b0;
							4'd1:	txd <= tx_data[7];
							4'd2:	txd <= tx_data[6];
							4'd3:	txd <= tx_data[5];
							4'd4:	txd <= tx_data[4];
							4'd5:	txd <= tx_data[3];
							4'd6:	txd <= tx_data[2];
							4'd7:	txd <= tx_data[1];
							4'd8:	txd <= tx_data[0];
							4'd9:	txd <= 1'b1;
						endcase
						
					end
					tx_busy <= 1'b1;
					//baudrate_counter
					if(tx_sample_cntr == BAUD_DIVIDOR - 1)
						tx_sample_cntr <= 16'd0;
					else
						tx_sample_cntr <= tx_sample_cntr + 1;
					//tx_data_counter
					if(tx_cntr == 4'd9 && tx_cntr && tx_sample_cntr == BAUD_DIVIDOR - 1)
						tx_cntr <= 4'd0;
					else if(tx_sample_cntr == BAUD_DIVIDOR - 1)
						tx_cntr <= tx_cntr + 1;
				end
				STOP:begin
					txd <= 1'b1;
					tx_busy <= 1'b0;
				end
				default:begin
					txd <= 1'b1;
					tx_busy <= 1'b0;
				end
			endcase
		end
	end
endmodule
