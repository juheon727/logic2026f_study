`timescale 1ns/1ps

module tb_circuit;

    reg [4:0] day;
    reg [3:0] month;
    reg leap_year;
    wire [15:0] day_of_year;

    calculate_day_of_year uut (
        .day(day),
        .month(month),
        .leap_year(leap_year),
        .day_of_year(day_of_year)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_circuit);

        day = 5'd6;
        month = 4'd8;
        leap_year = 1'd0;

        #10 $display("Day of Year: %d", day_of_year);
    end
endmodule