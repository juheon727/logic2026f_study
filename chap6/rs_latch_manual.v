module rs_latch(
    input wire r,
    input wire s,
    output wire q,
    output wire qb
);
    assign q = ~(r | qb);
    assign qb = ~(s | q);

endmodule