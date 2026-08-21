`timescale 1ns/1ps

module tb_circuit;
    reg a, b, c;
    wire ret;

    circuit uut (
        .a(a),
        .b(b),
        .c(c),
        .ret(ret)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_circuit);

        a = 1'b0;  b = 1'b1;  c = 1'b1; #10;
        
        c = 1'b0; #10;

        $finish;
    end

endmodule