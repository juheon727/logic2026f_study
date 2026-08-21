`timescale 1ns/1ps

module circuit(
    input wire a,
    input wire b,
    output reg f,
    output reg g
);
    reg xor1, nand1;

    always @(*) begin
        xor1 <= #10 a ^ b;
        nand1 <= #5 ~(a & b);
        f <= #5 ~(a & xor1);
        g <= #10 xor1 ^ nand1;
    end

endmodule