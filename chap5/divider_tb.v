`timescale 1ns/1ps

module divider_tb;
    reg [3:0] a, b;
    wire [3:0] quotient, remainder;
    wire zf;

    unsigned_divider #(
        .n_bits(4)
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

        a = 4'b1011;
        b = 4'b0011;

        #30;

        $display("Quotient: %d, Remainder: %d\n", quotient, remainder);
        $display("ZF: %b\n", zf);
    end
endmodule