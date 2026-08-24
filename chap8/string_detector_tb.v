`timescale 1ns/1ps

module string_detector_tb;
    reg clk, in, reset;
    wire out;

    parameter CLK_PERIOD = 10;

    string_detector dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, string_detector_tb);

        reset = 1'b1;

        #6;

        reset = 1'b0;

        in = 1'b1;

        #10;

        in = 1'b0;

        #10;

        in = 1'b1;
        
        #10;

        in = 1'b0;

        #10;

        $finish;
    end

endmodule