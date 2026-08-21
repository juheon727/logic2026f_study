`timescale 1ns/1ps

module tb_circuit;
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sum;
    wire p_out, g_out;

    cla16 uut (
        .a(a),
        .b(b),
        .c_0(1'b0),
        .sum(sum),
        .p_out(p_out),
        .g_out(g_out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_circuit);

        a = 16'h01af;
        b = 16'h103e;

        #10 $display("Sum: %d", sum);
    end
endmodule