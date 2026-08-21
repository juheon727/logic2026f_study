`timescale 1ns/1ps

module circuit(
    input wire a,
    input wire b,
    input wire c,
    output wire ret
);
    wire not_a, not_b;
    wire and1, and2, and3;

    assign #1 not_a = ~a;
    assign #3 not_c = ~c;

    assign #1 and1 = b & not_c;
    assign #1 and2 = not_a & c;
    assign #1 and3 = not_a & b;

    assign #1 ret = and1 | and2 | and3;

endmodule