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