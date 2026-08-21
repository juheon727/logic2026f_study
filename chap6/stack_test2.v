`timescale 1ns/1ps

module stack_tb;

    parameter n_regs = 8;
    parameter word_size = 8;
    parameter bits_of_counter = 4;

    reg clk;
    reg pop;
    reg push;
    reg reset;
    reg [word_size-1:0] data_input;

    wire [word_size-1:0] stack_top;
    wire lifo_empty;
    wire lifo_full;

    integer i;

    stack #(
        .n_regs(n_regs),
        .word_size(word_size),
        .bits_of_counter(bits_of_counter)
    ) dut (
        .clk(clk),
        .pop(pop),
        .push(push),
        .reset(reset),
        .data_input(data_input),
        .stack_top(stack_top),
        .lifo_empty(lifo_empty),
        .lifo_full(lifo_full)
    );

    // 10 ns clock period
    always #5 clk = ~clk;


    // --------------------------------------------------
    // Push task
    // --------------------------------------------------
    task push_value;
        input [word_size-1:0] value;
        begin
            @(negedge clk);
            data_input = value;
            push = 1'b1;
            pop  = 1'b0;

            @(negedge clk);
            push = 1'b0;
        end
    endtask


    // --------------------------------------------------
    // Pop task
    // --------------------------------------------------
    task pop_value;
        begin
            @(negedge clk);
            push = 1'b0;
            pop  = 1'b1;

            @(negedge clk);
            pop = 1'b0;
        end
    endtask


    // --------------------------------------------------
    // Print current stack state
    // --------------------------------------------------
    task print_state;
        begin
            $display(
                "time=%0t  pointer=%0d  empty=%b  full=%b  top=%h",
                $time,
                dut.stack_pointer,
                lifo_empty,
                lifo_full,
                stack_top
            );
        end
    endtask


    initial begin

        // Initial signal values
        clk        = 1'b0;
        reset      = 1'b0;
        pop        = 1'b0;
        push       = 1'b0;
        data_input = {word_size{1'b0}};

        // Waveform output
        $dumpfile("stack_tb.vcd");
        $dumpvars(0, stack_tb);


        // ==================================================
        // TEST 1: Reset
        // ==================================================

        $display("\n--- TEST 1: RESET ---");

        @(negedge clk);
        reset = 1'b1;

        // Reset is synchronous, so it must cross a rising edge.
        @(negedge clk);
        reset = 1'b0;

        #1;
        print_state();

        if (lifo_empty !== 1'b1)
            $display("ERROR: Stack should be empty after reset");

        if (lifo_full !== 1'b0)
            $display("ERROR: Stack should not be full after reset");

        if (stack_top !== {word_size{1'b0}})
            $display(
                "ERROR: Stack top should be zero after reset, got %h",
                stack_top
            );


        // ==================================================
        // TEST 2: Push one value
        // ==================================================

        $display("\n--- TEST 2: PUSH 11 ---");

        push_value(8'h11);
        #1;
        print_state();

        if (stack_top !== 8'h11)
            $display(
                "ERROR: Expected top=11, got %h",
                stack_top
            );

        if (lifo_empty !== 1'b0)
            $display("ERROR: Stack should not be empty");


        // ==================================================
        // TEST 3: Push additional values
        // ==================================================

        $display("\n--- TEST 3: PUSH 22, 33 ---");

        push_value(8'h22);
        print_state();

        if (stack_top !== 8'h22)
            $display(
                "ERROR: Expected top=22, got %h",
                stack_top
            );

        push_value(8'h33);
        print_state();

        if (stack_top !== 8'h33)
            $display(
                "ERROR: Expected top=33, got %h",
                stack_top
            );


        // ==================================================
        // TEST 4: Verify LIFO behavior
        // ==================================================

        $display("\n--- TEST 4: POP 33 ---");

        pop_value();
        #1;
        print_state();

        if (stack_top !== 8'h22)
            $display(
                "ERROR: Expected top=22 after pop, got %h",
                stack_top
            );


        $display("\n--- POP 22 ---");

        pop_value();
        #1;
        print_state();

        if (stack_top !== 8'h11)
            $display(
                "ERROR: Expected top=11 after pop, got %h",
                stack_top
            );


        $display("\n--- POP 11 ---");

        pop_value();
        #1;
        print_state();

        if (lifo_empty !== 1'b1)
            $display(
                "ERROR: Stack should be empty after final pop"
            );


        // ==================================================
        // TEST 5: Pop while empty
        // ==================================================

        $display("\n--- TEST 5: POP WHILE EMPTY ---");

        pop_value();
        #1;
        print_state();

        if (lifo_empty !== 1'b1)
            $display(
                "ERROR: Stack changed after pop while empty"
            );

        if (dut.stack_pointer !== 0)
            $display(
                "ERROR: Pointer changed after pop while empty"
            );


        // ==================================================
        // TEST 6: Fill the stack
        // ==================================================

        $display("\n--- TEST 6: FILL STACK ---");

        for (i = 0; i < n_regs; i = i + 1) begin
            push_value(i + 1);
            print_state();
        end

        if (lifo_full !== 1'b1)
            $display(
                "ERROR: Stack should be full"
            );

        if (dut.stack_pointer !== n_regs)
            $display(
                "ERROR: Expected pointer=%0d, got %0d",
                n_regs,
                dut.stack_pointer
            );

        if (stack_top !== n_regs)
            $display(
                "ERROR: Expected top=%0d, got %h",
                n_regs,
                stack_top
            );


        // ==================================================
        // TEST 7: Push while full
        // ==================================================

        $display("\n--- TEST 7: PUSH WHILE FULL ---");

        push_value(8'hFF);
        #1;
        print_state();

        if (lifo_full !== 1'b1)
            $display(
                "ERROR: Stack should remain full"
            );

        if (dut.stack_pointer !== n_regs)
            $display(
                "ERROR: Pointer changed after push while full"
            );

        if (stack_top !== n_regs)
            $display(
                "ERROR: Top changed after push while full"
            );


        // ==================================================
        // TEST 8: Pop everything
        // ==================================================

        $display("\n--- TEST 8: EMPTY STACK ---");

        for (i = n_regs; i > 0; i = i - 1) begin

            if (stack_top !== i)
                $display(
                    "ERROR: Expected top=%0d, got %h",
                    i,
                    stack_top
                );

            pop_value();
            #1;
            print_state();

        end

        if (lifo_empty !== 1'b1)
            $display(
                "ERROR: Stack should be empty"
            );

        if (dut.stack_pointer !== 0)
            $display(
                "ERROR: Pointer should be zero"
            );


        // ==================================================
        // TEST 9: Reset a non-empty stack
        // ==================================================

        $display("\n--- TEST 9: RESET NON-EMPTY STACK ---");

        push_value(8'hAA);
        push_value(8'hBB);
        push_value(8'hCC);

        print_state();

        @(negedge clk);
        reset = 1'b1;

        @(negedge clk);
        reset = 1'b0;

        #1;
        print_state();

        if (lifo_empty !== 1'b1)
            $display(
                "ERROR: Stack should be empty after reset"
            );

        if (dut.stack_pointer !== 0)
            $display(
                "ERROR: Pointer should be zero after reset"
            );


        // ==================================================
        // Done
        // ==================================================

        $display("\n================================");
        $display("       TESTBENCH COMPLETE");
        $display("================================\n");

        #10;
        $finish;

    end

endmodule