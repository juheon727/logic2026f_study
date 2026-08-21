module regfile #(
    parameter word_size = 8
)(
    input wire clk,
    input wire [word_size - 1:0] new_data,
    input wire [2:0] w_addr,
    input wire en,
    input wire [2:0] r_addr1,
    input wire [2:0] r_addr2,
    output reg [word_size - 1:0] r_out1,
    output reg [word_size - 1:0] r_out2
);
    // Allows us to create 8 registers of size word_size bits.
    reg [word_size-1:0] storage [0:7];

    always @(posedge clk) begin
        if(en)
            storage[w_addr] <= new_data; 
    end
    
    always @(*) begin
        r_out1 = storage[r_addr1];
        r_out2 = storage[r_addr2];
    end

endmodule