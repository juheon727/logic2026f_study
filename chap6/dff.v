module dff(
    input wire d,
    input wire en,
    input wire clk,
    output reg q
);

    always @(posedge clk) begin
        if(en)
            q <= d;
    end

endmodule