`timescale 1ns/1ps

module identity(
    input wire i,
    output wire o
);
    assign o = i;
endmodule

module full_subtractor(
    input wire a,
    input wire b,
    input wire bi,
    output wire d,
    output wire bl
);
    assign d = a ^ b ^ bi;
    assign bl = ((~a) & (b ^ bi)) | (b & bi);

endmodule

module divmodule(
    input wire rem_in,
    input wire flag_in,
    input wire borrow_in,
    input wire div_in,
    input wire flag_final,
    output wire flag_out,
    output wire rem_out,
    output wire borrow_out
);
    assign flag_out = (flag_in & (~(rem_in ^ div_in))) | (rem_in & ~div_in);
    
    full_subtractor sub (
        .a(rem_in),
        .b(div_in & flag_final),
        .bi(borrow_in),
        .d(rem_out),
        .bl(borrow_out)
    );

endmodule

module divider(
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output wire [3:0] quotient,
    output wire [3:0] remainder,
    output wire div_by_zero
);
    wire [6:0] padded;
    wire []
    assign padded = {3'b000, dividend};

    assign div_by_zero = &(~divisor);

    genvar i, j;

    generate
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < i + 1; j = j + 1) begin
                divmodule div_element (
                    
                );
            end
        end
    endgenerate    

endmodule