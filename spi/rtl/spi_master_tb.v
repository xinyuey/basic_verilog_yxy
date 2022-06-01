`timescale 1ns/1ps
module spi_master_tb();
    reg clk;
    reg rst_n;
    reg spi_wr_cmd;
    reg spi_rd_cmd;
    reg [7:0] mosi_data;

    wire [7:0] miso_data_0,miso_data_1,miso_data_2,miso_data_3;
    wire sck_0,sck_1,sck_2,sck_3;
    wire cs_0,cs_1,cs_2,cs_3;
    wire mosi_0,mosi_1,mosi_2,mosi_3;
    reg miso_0,miso_1,miso_2,miso_3;

    initial begin
        clk = 0;
        forever #10 clk = ~clk;//50MHz
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
    end

    initial begin
        spi_rd_cmd = 0;
        miso_0 = 1;
        miso_1 = 1;
        miso_2 = 1;
        miso_3 = 1;
        #390 spi_rd_cmd = 1;
        #200 spi_rd_cmd = 0;
        #10000
        $stop;
    end

    spi_master #(
        .SYS_CLK(),
        .SPI_FREQ(),
        .SPI_MODE(0),
        .SPI_WIDTH(8),
        .SPI_MSB(0)
    )s0(
        .clk(clk),
        .rst_n(rst_n),
        .spi_wr_cmd(spi_wr_cmd),
        .spi_rd_cmd(spi_rd_cmd),
        .mosi_data(mosi_data),
        .miso_data(miso_data_0),
        .SCK(sck_0),
        .MOSI(mosi_0),
        .CS(cs_0),
        .MISO(miso_0)
    );
    spi_master #(
        .SYS_CLK(),
        .SPI_FREQ(),
        .SPI_MODE(1),
        .SPI_WIDTH(8),
        .SPI_MSB(0)
    )s1(
        .clk(clk),
        .rst_n(rst_n),
        .spi_wr_cmd(spi_wr_cmd),
        .spi_rd_cmd(spi_rd_cmd),
        .mosi_data(mosi_data),
        .miso_data(miso_data_1),
        .SCK(sck_1),
        .MOSI(mosi_1),
        .CS(cs_1),
        .MISO(miso_1)
    );
    spi_master #(
        .SYS_CLK(),
        .SPI_FREQ(),
        .SPI_MODE(2),
        .SPI_WIDTH(8),
        .SPI_MSB(0)
    )s2(
        .clk(clk),
        .rst_n(rst_n),
        .spi_wr_cmd(spi_wr_cmd),
        .spi_rd_cmd(spi_rd_cmd),
        .mosi_data(mosi_data),
        .miso_data(miso_data_2),
        .SCK(sck_2),
        .MOSI(mosi_2),
        .CS(cs_2),
        .MISO(miso_2)
    );
    spi_master #(
        .SYS_CLK(),
        .SPI_FREQ(),
        .SPI_MODE(3),
        .SPI_WIDTH(8),
        .SPI_MSB(0)
    )s3(
        .clk(clk),
        .rst_n(rst_n),
        .spi_wr_cmd(spi_wr_cmd),
        .spi_rd_cmd(spi_rd_cmd),
        .mosi_data(mosi_data),
        .miso_data(miso_data_3),
        .SCK(sck_3),
        .MOSI(mosi_3),
        .CS(cs_3),
        .MISO(miso_3)
    );
    
endmodule