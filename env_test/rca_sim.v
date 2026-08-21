`timescale 1ns/1ps

module tb_ripple_carry_adder;
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    // Instantiate the Ripple Carry Adder
    ripple_carry_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        // Open a dump file to record waveforms
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_ripple_carry_adder);

        // Test Case 1: Simple addition
        a = 4'd5;  b = 4'd3;  cin = 1'b0; #10;
        $display("A: %d + B: %d + Cin: %b = Sum: %d, Cout: %b", a, b, cin, sum, cout);

        // Test Case 2: Addition with Carry In
        a = 4'd10; b = 4'd2;  cin = 1'b1; #10;
        $display("A: %d + B: %d + Cin: %b = Sum: %d, Cout: %b", a, b, cin, sum, cout);

        // Test Case 3: Generating a Carry Out (Overflow)
        a = 4'd12; b = 4'd5;  cin = 1'b0; #10;
        $display("A: %d + B: %d + Cin: %b = Sum: %d, Cout: %b", a, b, cin, sum, cout);

        // Test Case 4: Max values
        a = 4'd15; b = 4'd15; cin = 1'b1; #10;
        $display("A: %d + B: %d + Cin: %b = Sum: %d, Cout: %b", a, b, cin, sum, cout);

        $finish;
    end
endmodule