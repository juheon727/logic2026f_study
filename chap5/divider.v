`timescale 1ns/1ps

module full_subtractor(
    input wire a,
    input wire b,
    input wire bi,
    output wire d,
    output wire bl
);
    assign #1 d = a ^ b ^ bi;
    assign #1 bl = ((~a) & (b ^ bi)) | (b & bi);

endmodule

module conditional_subtractor #(
    parameter n_bits = 4
)(
    input wire [n_bits - 1 : 0] a,
    input wire [n_bits - 1 : 0] b,
    input wire initial_borrow,
    output reg [n_bits - 1 : 0] result,
    output wire [n_bits - 1 : 0] intermediate_borrows
);

    wire [n_bits - 1 : 0] subtraction_result;

    full_subtractor fs_0 (
        .a(a[0]),
        .b(b[0]),
        .bi(initial_borrow),
        .d(subtraction_result[0]),
        .bl(intermediate_borrows[0])
    );

    genvar i;
    generate
        for (i = 1; i < n_bits; i = i + 1) begin
            full_subtractor fs (
                .a(a[i]),
                .b(b[i]),
                .bi(intermediate_borrows[i - 1]),
                .d(subtraction_result[i]),
                .bl(intermediate_borrows[i])
            );
        end
    endgenerate

    always @(*) begin
        if (intermediate_borrows[n_bits - 1])
            result = a;
        else
            result = subtraction_result;
    end

endmodule

module unsigned_divider #(
    parameter n_bits = 4
)(
    input wire [n_bits - 1 : 0] dividend,
    input wire [n_bits - 1 : 0] divisor,
    output wire [n_bits - 1 : 0] quotient,
    output wire [n_bits - 1 : 0] remainder,
    output wire zero_flag
);

    wire [n_bits - 1 : 0] subtraction_pathway [0 : n_bits - 1];
    wire [n_bits - 1 : 0] borrows [0 : n_bits - 1];

    assign zero_flag = (divisor == {n_bits{1'b0}});
    assign remainder = subtraction_pathway[n_bits - 1];

    conditional_subtractor #(
        .n_bits(n_bits)
    ) csub_init (
        .a({{(n_bits - 1){1'b0}}, dividend[n_bits - 1]}),
        .b(divisor),
        .initial_borrow(1'b0),
        .result(subtraction_pathway[0]),
        .intermediate_borrows(borrows[0])
    );

    genvar i;
    generate
        for (i = 1; i < n_bits; i = i + 1) begin : gen_csubs 
            conditional_subtractor #(
                .n_bits(n_bits)
            ) csub (
                .a({subtraction_pathway[i - 1][n_bits - 2 : 0], dividend[n_bits - 1 - i]}),
                .b(divisor),
                .initial_borrow(1'b0),
                .result(subtraction_pathway[i]),
                .intermediate_borrows(borrows[i])
            );
        end

        for (i = 0; i < n_bits; i = i + 1) begin : gen_quotient
            assign quotient[i] = ~borrows[n_bits - 1 - i][n_bits - 1];
        end
    endgenerate

endmodule