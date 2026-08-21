`timescale 1ns/1ps

module stack_tb;

    parameter n_regs   = 8;
    parameter word_size = 8;

    reg clk;
    reg pop;
    reg push;
    reg [word_size-1:0] data_input;
    reg reset;

    wire [word_size-1:0] stack_top;
    wire lifo_empty;
    wire lifo_full;

    integer i;

    stack #(
        .n_regs(n_regs),
        .word_size(word_size)
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

    // Push one value
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

    // Pop one value
    task pop_value;
        begin
            @(negedge clk);
            push = 1'b0;
            pop  = 1'b1;

            @(negedge clk);
            pop = 1'b0;
        end
    endtask

    // Print internal stack contents
    task print_stack;
        integer j;
        begin
            $write("time=%0t empty=%b full=%b top=%h | ",
                   $time, lifo_empty, lifo_full, stack_top);

            for (j = 0; j < n_regs; j = j + 1)
                $write("[%b:%h] ",
                       dut.storage[j][word_size],
                       dut.storage[j][word_size-1:0]);

            $write("\n");
        end
    endtask

    initial begin
        clk = 1'b0;
        pop = 1'b0;
        push = 1'b0;
        data_input = {word_size{1'b0}};
        reset = 1'b1;
        #1;
        reset = 1'b0;

        // // The DUT has no reset, so initialize its storage manually.
        // for (i = 0; i < n_regs; i = i + 1)
        //     dut.storage[i] = {(word_size + 1){1'b0}};

        $dumpfile("stack_tb.vcd");
        $dumpvars(0, stack_tb);

        #1;

        // ----------------------------------------
        // Test 1: Stack should initially be empty
        // ----------------------------------------

        $display("\n--- Initial state ---");
        print_stack();

        if (lifo_empty !== 1'b1)
            $display("ERROR: Stack should initially be empty");


        // ----------------------------------------
        // Test 2: Push several values
        // ----------------------------------------

        $display("\n--- Push 11 ---");
        push_value(8'h11);
        print_stack();

        if (stack_top !== 8'h11)
            $display("ERROR: Expected top=11, got %h", stack_top);


        $display("\n--- Push 22 ---");
        push_value(8'h22);
        print_stack();

        if (stack_top !== 8'h22)
            $display("ERROR: Expected top=22, got %h", stack_top);


        $display("\n--- Push 33 ---");
        push_value(8'h33);
        print_stack();

        if (stack_top !== 8'h33)
            $display("ERROR: Expected top=33, got %h", stack_top);


        // ----------------------------------------
        // Test 3: Pop
        // ----------------------------------------

        $display("\n--- Pop ---");
        pop_value();
        print_stack();

        if (stack_top !== 8'h22)
            $display("ERROR: Expected top=22 after pop, got %h", stack_top);


        $display("\n--- Pop ---");
        pop_value();
        print_stack();

        if (stack_top !== 8'h11)
            $display("ERROR: Expected top=11 after pop, got %h", stack_top);


        $display("\n--- Pop last value ---");
        pop_value();
        print_stack();

        if (lifo_empty !== 1'b1)
            $display("ERROR: Stack should be empty");


        // ----------------------------------------
        // Test 4: Pop while empty
        // ----------------------------------------

        $display("\n--- Pop while empty ---");
        pop_value();
        print_stack();

        if (lifo_empty !== 1'b1)
            $display("ERROR: Empty pop changed stack state");


        // ----------------------------------------
        // Test 5: Fill entire stack
        // ----------------------------------------

        $display("\n--- Fill stack ---");

        push_value(8'h01);
        push_value(8'h02);
        push_value(8'h03);
        push_value(8'h04);
        push_value(8'h05);
        push_value(8'h06);
        push_value(8'h07);
        push_value(8'h08);

        print_stack();

        if (lifo_full !== 1'b1)
            $display("ERROR: Stack should be full");

        if (stack_top !== 8'h08)
            $display("ERROR: Expected top=08, got %h", stack_top);


        // ----------------------------------------
        // Test 6: Push while full
        // ----------------------------------------

        $display("\n--- Push while full ---");
        push_value(8'hFF);
        print_stack();

        if (stack_top !== 8'h08)
            $display("ERROR: Push while full modified stack");


        // ----------------------------------------
        // Test 7: Empty entire stack
        // ----------------------------------------

        $display("\n--- Empty stack ---");

        for (i = 0; i < n_regs; i = i + 1) begin
            pop_value();
            print_stack();
        end

        if (lifo_empty !== 1'b1)
            $display("ERROR: Stack should be empty");


        // ----------------------------------------
        // Done
        // ----------------------------------------

        $display("\n--- TESTBENCH COMPLETE ---");

        #10;
        $finish;
    end

endmodule