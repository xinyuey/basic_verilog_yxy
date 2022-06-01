library verilog;
use verilog.vl_types.all;
entity edge_detect is
    generic(
        REGISTER_OUTPUTS: vl_logic := Hi0
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        \in\            : in     vl_logic;
        rising          : out    vl_logic;
        falling         : out    vl_logic;
        both            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of REGISTER_OUTPUTS : constant is 1;
end edge_detect;
