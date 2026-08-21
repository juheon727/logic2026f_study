`timescale 1ns/1ps

module pulse_generator_tb;
    reg clk;
    reg in;
    wire q;

    parameter CLK_PERIOD = 10;

    pulse_generator uut (
        .clk(clk),
        .in(in),
        .q(q)
    );

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, pulse_generator_tb);

        uut.block_switch = 1'b0;

        #2;

        in = 1'b1;

        #20;

        in = 1'b0;

        #20;

        in = 1'b1;

        #30;

        in = 1'b0;

        #10;

        $finish;
    end

endmodule