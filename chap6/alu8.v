module alu8(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [2:0] opcode,
    output reg [7:0] f
);

    always @(*) begin
        case (opcode)
            3'b000: f = ~a;
            3'b001: f = a | b;
            3'b010: f = a & b;
            3'b011: f = a ^ b;
            3'b100: f = a << b;
            3'b101: f = a >> b;
            3'b110: f = a + b;
            3'b111: f = a - b;
            default: f = 8'b00000000;
        endcase
    end

endmodule