`timescale 1ns/1ps

module tb_circuit;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] f;
    wire of;

    sign_and_magnitude_adder uut (
        .a(a),
        .b(b),
        .f(f),
        .of(of)
    );

    initial begin
        a = 4'b0010;
        b = 4'b1001;

        #10 $display("Sum: %d, Overflow: %d\n", f, of);

        a = 4'b0110;
        b = 4'b0101;

        #10 $display("Sum: %d, Overflow: %d\n", f, of);
    end

endmodule