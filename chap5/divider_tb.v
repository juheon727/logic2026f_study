`timescale 1ns/1ps

module divider_tb;
    reg [7:0] a, b;
    wire [7:0] quotient, remainder;
    wire zf;

    unsigned_divider #(
        .n_bits(8)
    ) dut (
        .dividend(a),
        .divisor(b),
        .quotient(quotient),
        .remainder(remainder),
        .zero_flag(zf)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, divider_tb);

        a = 8'd149;
        b = 8'd3;

        #40;

        $display("Quotient: %d, Remainder: %d\n", quotient, remainder);
        $display("ZF: %b\n", zf);
    end
endmodule