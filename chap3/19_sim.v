`timescale 1ns/1ps

module tb_circuit;
    reg a, b;
    wire f, g;

    circuit uut (
        .a(a),
        .b(b),
        .f(f),
        .g(g)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_circuit);

        a = 1'b0; b = 1'b0; #3;

        a = 1'b1; #5;

        a = 1'b0; #5;

        b = 1'b1; #5;

        a = 1'b1; #5;

        a = 1'b0; #20;

        $finish;
    end
endmodule