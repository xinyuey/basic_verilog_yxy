module edge_detect#(
   parameter REGISTER_OUTPUTS = 1'b0
)(
    input clk,
    input rst_n,
    input in,
    output rising,
    output falling,
    output both
);
    reg in_delay;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            in_delay <= 0;
        else
            in_delay <= in; 
    end

    wire rising_comb;
    wire falling_comb;
    wire both_comb;

    assign rising_comb = rst_n && (in && ~in_delay);
    assign falling_comb = rst_n && (~in && in_delay);
    assign both_comb = rst_n && (rising_comb || falling_comb);

    if(REGISTER_OUTPUTS == 0)begin
        assign rising = rst_n && (in && ~in_delay);
        assign falling = rst_n && (~in && in_delay);
        assign both_comb = rst_n && (rising || falling);
    end
    else begin
        reg rising;
        reg falling;
        reg both;
        always@(posedge clk or negedge rst_n)begin
            if(!rst_n)begin
                rising = 0;
                falling = 0;
                both = 0;
            end
            else begin
                rising = rising_comb;
                falling = falling_comb;
                both = both_comb; 
            end
        end
    end

endmodule