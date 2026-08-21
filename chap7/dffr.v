module dff(
    input wire clk,
    input wire d,
    input wire r,
    input wire en,
    output reg q
);

    always @(posedge clk) begin
        if (en)
            q <= d;
        if (r)
            q <= 1'b0;
    end

endmodule