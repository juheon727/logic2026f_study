`timescale 1ns/1ps

module serial_adder_tb;

    parameter n_bits = 8;
    parameter CLK_PERIOD = 10;

    reg clk;
    reg [n_bits-1:0] input_a;
    reg [n_bits-1:0] input_b;
    reg load_a;
    reg load_b;
    reg reset;

    wire c_out;
    wire s;

    // Store the serial result so it can be checked
    reg [n_bits-1:0] sum_result;
    integer i;

    // DUT
    serial_adder #(
        .n_bits(n_bits)
    ) dut (
        .clk(clk),
        .input_a(input_a),
        .input_b(input_b),
        .load_a(load_a),
        .load_b(load_b),
        .reset(reset),
        .c_out(c_out),
        .s(s)
    );

    // ------------------------------------------------------------
    // Clock generation
    // Period = 10 ns
    //
    //       5ns      5ns
    //    ____      ______
    // clk    |____|      |____
    //
    // Rising edges at 5, 15, 25, 35, ... ns
    // ------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end


    // ------------------------------------------------------------
    // Test sequence
    // Example: 8 + 4 = 12
    //          00001000
    //        + 00000100
    //        ----------
    //          00001100
    // ------------------------------------------------------------
    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, serial_adder_tb);

        // Initial values
        input_a = 8'b00000000;
        input_b = 8'b00000000;
        load_a  = 1'b0;
        load_b  = 1'b0;
        reset   = 1'b0;
        sum_result = 0;

        // -------------------------
        // Apply synchronous reset
        // -------------------------
        #2;
        reset = 1'b1;

        // Reset is sampled at the rising edge at t = 5 ns
        @(posedge clk);
        #1;
        reset = 1'b0;

        // -------------------------
        // Load A and B
        // -------------------------
        input_a = 8'd12;
        input_b = 8'd6;
        load_a  = 1'b1;
        load_b  = 1'b1;

        // Values loaded on next rising edge
        @(posedge clk);

        // Wait for nonblocking assignments to update data_a/data_b.
        #1;

        load_a = 1'b0;
        load_b = 1'b0;

        // At this point the full adder is processing bit 0.
        //
        // Capture s BEFORE each following rising edge because
        // the edge shifts both operand registers.
        for (i = 0; i < n_bits; i = i + 1) begin

            sum_result[i] = s;

            $display(
                "time=%0t  bit=%0d  Areg=%b  Breg=%b  cin=%b  s=%b  cout=%b",
                $time,
                i,
                dut.data_a,
                dut.data_b,
                dut.c_in,
                s,
                c_out
            );

            @(posedge clk);

            // Allow nonblocking assignments and combinational
            // full-adder output to settle.
            #1;
        end

        // -------------------------
        // Display result
        // -------------------------
        $display("----------------------------------------");
        $display("A          = %d (%b)", input_a, input_a);
        $display("B          = %d (%b)", input_b, input_b);
        $display("Serial sum = %d (%b)", sum_result, sum_result);
        $display("Final carry= %b", dut.c_in);
        $display("----------------------------------------");

        /*if (sum_result == 8'd12)
            $display("TEST PASSED: 8 + 4 = 12");
        else
            $display("TEST FAILED: expected 12, got %d", sum_result);*/

        #20;
        $finish;
    end

endmodule