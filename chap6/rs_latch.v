module rs_latch(
    input wire r,
    input wire s,
    output wire q,
    output wire qb
);
    always @(*) begin
        if (r) begin
            q = 1'b0;
            qb = 1'b1;
        end

        if (s) begin
            q = 1'b1;
            qb = 1'b0;
        end
    end

endmodule