module fsm_a(
    input wire clk,
    input wire up,
    input wire reset,
    input wire [1:0] state_b,
    output reg [1:0] state
);

    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;
        else begin
            case (state)
                2'b11: begin
                    if (up && state_b == 2'b10)
                        state <= 2'b00;
                    else if (!up && state_b == 2'b00)
                        state <= 2'b10;
                end
                default: begin
                    if (up)
                        state <= state + 1;
                    else
                        state <= state - 1;
                end
            endcase
        end
    end

endmodule

module fsm_b(
    input wire clk,
    input wire up,
    input wire reset,
    input wire [1:0] state_a,
    output reg [1:0] state
);

    always @(posedge clk) begin
        if (reset)
            state <= 2'b11;
        else begin
            case (state)
                2'b11: begin
                    if (up && state_a == 2'b10)
                        state <= 2'b00;
                    else if (!up && state_a == 2'b00)
                        state <= 2'b10;
                end
                default: begin
                    if (up)
                        state <= state + 1;
                    else
                        state <= state - 1;
                end
            endcase
        end
    end

endmodule

module binary_counter(
    input wire clk,
    input wire up,
    input wire reset,
    output reg [2:0] state
);
    wire [1:0] state_a, state_b;

    fsm_a lower_fsm (
        .clk(clk),
        .up(up),
        .reset(reset),
        .state_b(state_b),
        .state(state_a)
    );

    fsm_b upper_fsm (
        .clk(clk),
        .up(up),
        .reset(reset),
        .state_a(state_a),
        .state(state_b)
    );

    always @(*) begin
        if (state_a == 2'b11)
            state = state_b + 2'd3;
        else
            state = state_a;
    end

endmodule