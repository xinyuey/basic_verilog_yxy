`timescale 1ns/1ps
module spi_master_tb();
    reg clk;
    reg rst_n;
    reg [7:0] mosi_data;
    reg spi_wr_cmd;
    reg spi_rd_cmd;
    reg miso_pin;

    wire [7:0] miso_data;
    wire mosi_pin;
    wire sck_pin;
    wire cs_pin;

    spi_master s1(
        .clk(clk),
        .rst_n(rst_n),
        .spi_wr_cmd(spi_wr_cmd),
        .spi_rd_cmd(spi_rd_cmd),
        .mosi_data(mosi_data),
        .miso_data(miso_data),
        .SCK(sck_pin),
        .MOSI(mosi_pin),
        .CS(cs_pin),
        .MISO(miso_pin)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst_n = 1;
        #200 rst_n = 0;
        #200 rst_n = 1;
    end

    initial begin
        spi_wr_cmd = 0;
        mosi_data = 8'h00;
        #390 
        spi_wr_cmd = 1;
        mosi_data = 8'b11001001;
        #200
        spi_wr_cmd = 0;

        // #8000 spi_wr_cmd = 1;
        // #20 spi_wr_cmd = 0;
        // #8000
        // $stop;
    end

    initial begin
        spi_rd_cmd = 0;
        miso_pin = 1;
        #390 spi_rd_cmd = 1;
        #200 spi_rd_cmd = 0;
        #10000
        $stop;
    end
endmodule