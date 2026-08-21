module stack #(
    parameter n_regs = 8,
    parameter word_size = 8
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
    reg [word_size : 0] storage [0 : n_regs - 1];
    integer i;

    always @(*) begin
        lifo_empty = ~storage[0][word_size];
        lifo_full = storage[n_regs - 1][word_size];
        stack_top = storage[0][word_size - 1 : 0];
    end

    always @(posedge clk) begin
        if (reset) begin
            for(i = 0; i < n_regs; i = i + 1) begin
                storage[i] = {(word_size + 1){1'b0}};
            end
        end
        else begin
            for(i = 1; i < n_regs - 1; i = i + 1) begin
                case ({~lifo_empty & pop, ~lifo_full & push})
                    2'b01: storage[i] <= storage[i - 1];
                    2'b10: storage[i] <= storage[i + 1];
                    default: storage[i] <= storage[i];
                endcase
            end

            case ({~lifo_empty & pop, ~lifo_full & push})
                2'b01: storage[0] <= {1'b1, data_input};
                2'b10: storage[0] <= storage[1];
                default: storage[0] <= storage[0];
            endcase

            case ({~lifo_empty & pop, ~lifo_full & push})
                2'b01: storage[n_regs - 1] <= storage[n_regs - 2];
                2'b10: storage[n_regs - 1] <= {(word_size + 1){1'b0}};
                default: storage[n_regs - 1] <= storage[n_regs - 1];
            endcase
        end
    end

endmodule