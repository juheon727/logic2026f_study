module pulse_generator(
    input wire clk,
    input wire in,
    input wire reset,
    output reg q
);

    reg block_switch;

    always @(posedge clk) begin
        if(!reset) begin
            block_switch <= in;
            q <= in & ~block_switch;
        end
        else begin
            block_switch <= 1'b0;
            q <= 1'b0;
        end
    end

endmodule