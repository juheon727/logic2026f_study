module shiftreg #(
    parameter n_regs = 8
)(
    input wire clk,
    input wire [n_regs - 1:0] data,
    input wire load,
    input wire reset,
    input wire enable,
    output reg [n_regs - 1:0] q
);
    //Make use of if statements as much as possible instead of explicitly trying to model everything with ANd and OR.
    always @(posedge clk) begin
        if (reset) begin
            q <= {n_regs{1'b0}};
        end
        else if (load) begin
            q <= data;
        end
        else if (enable) begin
            q <= {1'b0, q[n_regs-1:1]};
        end
    end

endmodule

module full_adder(
    input wire a,
    input wire b,
    input wire c_in,
    output reg s,
    output reg c_out
);
    always @(*) begin
        s = a ^ b ^ c_in;
        c_out = (a & b) | (a & c_in) | (b & c_in);
    end

endmodule

module serial_adder #(
    parameter n_bits = 8
)(
    input wire clk,
    input wire [n_bits - 1 : 0] input_a,
    input wire [n_bits - 1 : 0] input_b,
    input wire load_a,
    input wire load_b,
    input wire reset,
    output wire c_out,
    output wire s
);
    wire [n_bits - 1 : 0] data_a;
    wire [n_bits - 1 : 0] data_b;
    reg c_in;

    shiftreg #(
        .n_regs(n_bits)
    ) shr_a (
        .clk(clk),
        .data(input_a),
        .load(load_a),
        .reset(reset),
        .enable(1'b1),
        .q(data_a)
    );

    shiftreg #(
        .n_regs(n_bits)
    ) shr_b (
        .clk(clk),
        .data(input_b),
        .load(load_b),
        .reset(reset),
        .enable(1'b1),
        .q(data_b)
    );

    full_adder fa(
        .a(data_a[0]),
        .b(data_b[0]),
        .c_in(c_in),
        .s(s),
        .c_out(c_out)
    );

    always @(posedge clk) begin
        if (reset)
            c_in <= 1'b0;
        else
            c_in <= c_out;
    end

endmodule