module string_detector(
    input wire clk,
    input wire in,
    input wire reset,
    output reg out
);

    reg [2:0] state;

    always @(*) begin
        case (state)
            3'd6: begin
                if (in) out = 1'b0;
                else out = 1'b1;
            end
            default: out = 1'b0;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else begin
            case (state)
                3'd0: begin
                    if (in) state <= 3'd2;
                    else state <= 3'd1;
                end
                3'd1: begin
                    if (in) state <= 3'd4;
                    else state <= 3'd3;
                end
                3'd2: begin
                    if (in) state <= 3'd3;
                    else state <= 3'd4;
                end
                3'd3: state <= 3'd5;
                3'd4: begin
                    if (in) state <= 3'd6;
                    else state <= 3'd5;
                end
                default: state <= 3'd0;
            endcase
        end
    end

endmodule