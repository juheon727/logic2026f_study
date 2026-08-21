module stack #(
    parameter n_regs = 8,
    parameter word_size = 8,
    parameter bits_of_counter = 3
)(
    input wire clk,
    input wire pop,
    input wire push,
    input wire reset,
    input wire [word_size - 1 : 0] data_input,
    output reg [word_size - 1 : 0] stack_top,
    output reg lifo_empty,
    output reg lifo_full
);
    reg [bits_of_counter - 1 : 0] stack_pointer;
    reg [word_size - 1 : 0] storage [0 : n_regs - 1];
    
    integer i;

    always @(*) begin
        lifo_empty = (stack_pointer == {bits_of_counter{1'b0}});
        lifo_full = (stack_pointer == n_regs);
        if (!lifo_empty)
            stack_top = storage[stack_pointer - 1];
        else
            stack_top = {word_size{1'b0}};
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < n_regs; i = i + 1) begin
                storage[i] <= {word_size{1'b0}};
            end
            stack_pointer <= {bits_of_counter{1'b0}};
        end
        else begin
            case ({pop & ~lifo_empty, push & ~lifo_full})
                2'b01: begin
                    storage[stack_pointer] <= data_input;
                    stack_pointer <= stack_pointer + 1;
                end

                2'b10: begin
                    stack_pointer <= stack_pointer - 1;
                end
            endcase
        end
    end

endmodule