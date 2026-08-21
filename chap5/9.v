`timescale 1ns/1ps

module carry_lookahead4(
    input wire [3:0] p_in,
    input wire [3:0] g_in,
    input wire c_0,
    output wire [3:0] c,
    output wire p_out,
    output wire g_out
);
    assign p_out = &p_in;
    assign g_out = (
        g_in[3] 
        | (p_in[3] & g_in[2]) 
        | (&p_in[3:2] & g_in[1]) 
        | (&p_in[3:1] & g_in[0])
    );

    assign c[0] = c_0;
    assign c[1] = (
        g_in[0]
        | (p_in[0] & c_0) 
    );
    assign c[2] = (
        g_in[1]
        | (p_in[1] & g_in[0])
        | (p_in[1] & p_in[0] & c_0)
    );
    assign c[3] = (
        g_in[2]
        | (p_in[2] & g_in[1])
        | (p_in[2] & p_in[1] & g_in[0])
        | (p_in[2] & p_in[1] & p_in[0] & c_0)
    );
    
endmodule

module cla4(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire c_0,
    output wire [3:0] sum,
    output wire p_out,
    output wire g_out
);
    wire [3:0] carries;
    wire [3:0] prop;
    wire [3:0] gen;

    assign prop = a ^ b;
    assign gen = a & b;

    carry_lookahead4 cla (
        .p_in(prop),
        .g_in(gen),
        .c_0(c_0),
        .c(carries),
        .p_out(p_out),
        .g_out(g_out)
    );

    assign sum = prop ^ carries;

endmodule

module cla16(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire c_0,
    output wire [15:0] sum,
    output wire p_out,
    output wire g_out
);

    wire [3:0] carries;
    wire [3:0] prop;
    wire [3:0] gen;

    genvar i;

    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_cla
            cla4 sub_cl_adder (
                .a(a[4*i + 3 : 4*i]),
                .b(b[4*i + 3 : 4*i]),
                .c_0(carries[i]),
                .sum(sum[4*i + 3 : 4*i]),
                .p_out(prop[i]),
                .g_out(gen[i])
            );
        end
    endgenerate

    carry_lookahead4 cla (
        .p_in(prop),
        .g_in(gen),
        .c_0(c_0),
        .c(carries),
        .p_out(p_out),
        .g_out(g_out)
    );

endmodule