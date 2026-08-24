`timescale 1ns/1ps

module binary_counter_tb;
    reg clk, up, reset;
    wire [2:0] state;

    binary_counter dut (
        .clk(clk),
        .up(up),
        .reset(reset),
        .state(state)
    );

    parameter CLK_PERIOD = 4;

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, binary_counter_tb);

        reset = 1'b1; #3;
        reset = 1'b0; up = 1'b1;

        #100;

        $finish;
    end

endmodule