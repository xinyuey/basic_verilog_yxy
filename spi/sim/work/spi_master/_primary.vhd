library verilog;
use verilog.vl_types.all;
entity spi_master is
    generic(
        SYS_CLK         : integer := 50000000;
        SPI_FREQ        : integer := 1000000;
        SPI_MODE        : integer := 0;
        SPI_WIDTH       : integer := 8;
        SPI_MSB         : integer := 0
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        spi_wr_cmd      : in     vl_logic;
        spi_rd_cmd      : in     vl_logic;
        mosi_data       : in     vl_logic_vector;
        miso_data       : out    vl_logic_vector;
        SCK             : out    vl_logic;
        MOSI            : out    vl_logic;
        CS              : out    vl_logic;
        MISO            : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SYS_CLK : constant is 1;
    attribute mti_svvh_generic_type of SPI_FREQ : constant is 1;
    attribute mti_svvh_generic_type of SPI_MODE : constant is 1;
    attribute mti_svvh_generic_type of SPI_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SPI_MSB : constant is 1;
end spi_master;
