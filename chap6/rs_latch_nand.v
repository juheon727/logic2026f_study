module rs_latch_nand(
    input  wire sn,
    input  wire rn,
    output wire q,
    output wire qb
);

    nand (q,  sn, qb);
    nand (qb, rn, q);

endmodule