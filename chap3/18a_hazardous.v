`timescale 1ns/1ps

module circuit(
    input wire a,
    input wire b,
    input wire c,
    output wire ret
);
    wire not_c, not_a;
    wire and1, and2;

    assign #1 not_a = ~a;
    assign #3 not_c = ~c;
    assign #1 and1 = b & not_c;
    assign #1 and2 = not_a & c;
    assign #1 ret = and1 | and2;

endmodule