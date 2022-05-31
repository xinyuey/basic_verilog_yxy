module spi_master#(
    parameter SYS_CLK = 50000000,
    parameter SPI_FREQ = 1000000,     //1_000_000
    parameter SPI_MODE = 3,           //CPOL = 1,CPHA = 1
    parameter SPI_WIDTH = 8,          //8-bit，16-bit，32-bit
    parameter SPI_MSB = 0             //1:MSB first 0:LSB first
)(
    input clk,                        //50_000_000
    input rst_n,
    input spi_wr_cmd,
    input spi_rd_cmd,
    input [SPI_WIDTH-1:0] mosi_data,
    output reg [SPI_WIDTH-1:0] miso_data,
    output reg SCK,
    output reg MOSI,
    output reg CS,
    input MISO
);
    //spi_start_wr/rd
    wire spi_wr_cmd_rise;
    wire spi_rd_cmd_rise;
    wire SCK_rise;//extend of spi_wr_cmd
    wire SCK_fall;//extend of spi_rd_cmd

    reg [7:0] sequence_cntr;
    reg [SPI_WIDTH-1:0] mosi_data_buf;
    reg [SPI_WIDTH-1:0] miso_data_buf;
    reg spi_write;
    reg spi_read;

    parameter SPI_END = SPI_WIDTH * 2;

    edge_detect edge_wr_cmd(
        .clk(clk),
        .rst_n(rst_n),
        .in(spi_wr_cmd),
        .rising(spi_wr_cmd_rise),
        .falling(),
        .both()
    );
    edge_detect edge_rd_cmd(
        .clk(clk),
        .rst_n(rst_n),
        .in(spi_rd_cmd),
        .rising(spi_rd_cmd_rise),
        .falling(),
        .both()
    );
    edge_detect edge_sck(
        .clk(clk),
        .rst_n(rst_n),
        .in(SCK),
        .rising(SCK_rise),
        .falling(SCK_fall),
        .both()
    );

    //spi_clk_dividor
    parameter SCK_DIVIDOR = SYS_CLK / SPI_FREQ;
    reg [5:0] sck_div_cntr;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            sck_div_cntr <= 6'd0; 
        else if(sequence_cntr == SPI_END && SCK == SPI_MODE/2)//完成一次传输，分频停止
            sck_div_cntr <= 6'd0;
        else if(sequence_cntr == 7'd0 && (spi_wr_cmd_rise || spi_rd_cmd_rise))
            sck_div_cntr <= 6'd1;
        else if(sck_div_cntr == SCK_DIVIDOR)
            sck_div_cntr <= 6'd1;
        else if(sck_div_cntr)
            sck_div_cntr <= sck_div_cntr + 1'b1;
    end
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            SCK <= SPI_MODE/2;
        else if(sequence_cntr == SPI_END && sck_div_cntr == SCK_DIVIDOR/2)//完成一次传输，释放SCK
            SCK <= SPI_MODE/2; 
        else if(sequence_cntr == 7'd0 && (spi_wr_cmd_rise || spi_rd_cmd_rise))//检测到开始命令，翻转SCK
            SCK <= ~(SPI_MODE/2);
        else if(sck_div_cntr == SCK_DIVIDOR/2 || sck_div_cntr == SCK_DIVIDOR)//时钟分频
            SCK <= ~SCK;
    end

    //extend write&read command
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            spi_write <= 1'b0;
        else if(sequence_cntr == SPI_END)
            spi_write <= 1'b0;
        else if(spi_wr_cmd_rise == 1)
            spi_write <= 1'b1;  
    end   
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            spi_read <= 1'b0;
        else if(sequence_cntr == SPI_END)
            spi_read <= 1'b0;
        else if(spi_rd_cmd_rise == 1)
            spi_read <= 1'b1;  
    end   

    //CS
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            CS <= 1'b1;
        else if(sequence_cntr == SPI_END)
            CS <= 1'b1;
        else if(spi_wr_cmd_rise || spi_rd_cmd_rise)
            CS <= 1'b0;
    end

    //data input & output
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            mosi_data_buf [7:0] <= 8'd0;
        else if(spi_wr_cmd_rise)
            mosi_data_buf [7:0] <= mosi_data[7:0];
    end
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            miso_data [7:0] <= 8'd0;
        else if(spi_read && sequence_cntr == SPI_END)
            miso_data [7:0] <= miso_data_buf[7:0];
    end

    //update(wr) & sample(rd)
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            MOSI <= 1'b0;
            sequence_cntr <= 7'd0;
            miso_data_buf [7:0] <= 8'd0;
        end 
        else if(sequence_cntr == SPI_END)
            sequence_cntr <= 7'd0;
        else if(spi_write || spi_read)begin
            if(SPI_MODE == 0 || SPI_MODE == 3)begin
                if(spi_write && SCK_fall)begin
                    if(SPI_MSB)begin
                        MOSI <= mosi_data_buf[7];
                        mosi_data_buf[7:0] <= {mosi_data_buf[6:0],1'b0};
                    end
                    else begin
                        MOSI <= mosi_data_buf[0];
                        mosi_data_buf[7:0] <= {1'b0,mosi_data_buf[7:1]};
                    end
                    sequence_cntr <= sequence_cntr + 1'b1;
                end
                else if(SCK_fall)begin
                    sequence_cntr <= sequence_cntr + 1'b1;
                end
                if(spi_read && SCK_rise)begin
                    if(SPI_MSB)
                        miso_data_buf[7:0] <= {MISO,miso_data_buf[7:1]};
                    else
                        miso_data_buf[7:0] <= {miso_data_buf[6:0],MISO};
                    sequence_cntr <= sequence_cntr + 1'b1;
                end
                else if(SCK_rise)begin
                    sequence_cntr <= sequence_cntr + 1'b1;
                end
            end
            else  if(SPI_MODE == 1 || SPI_MODE == 2)begin
                if(spi_write && SCK_rise)begin
                    if(SPI_MSB)begin
                        MOSI <= mosi_data_buf[7];
                        mosi_data_buf[7:0] <= {mosi_data_buf[6:0],1'b0};
                    end
                    else begin
                        MOSI <= mosi_data_buf[0];
                        mosi_data_buf[7:0] <= {1'b0,mosi_data_buf[7:1]};
                    end
                    sequence_cntr <= sequence_cntr + 1'b1;
                end
                if(spi_read && SCK_fall)begin
                    if(SPI_MSB)
                        miso_data_buf[7:0] <= {MISO,miso_data_buf[7:1]};
                    else
                        miso_data_buf[7:0] <= {miso_data_buf[6:0],MISO};
                    sequence_cntr <= sequence_cntr + 1'b1;
                end
            end
        end
    end

endmodule