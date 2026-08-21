`timescale 1ns/1ps

module circuit(
    input wire a,
    input wire b,
    input wire c,
    output wire ret
);
    wire not_b;
    wire or1, or2, or3;

    assign #1 not_b = ~b;
    assign #1 or1 = a | b;
    assign #1 or2 = not_b | c;
    assign #1 ret = or1 & or2;

endmodule