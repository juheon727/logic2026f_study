`timescale 1ns/1ps

module calculate_day_of_year(
    input wire [4:0] day,
    input wire [3:0] month,
    input wire leap_year,
    output reg [15:0] day_of_year
);

    always @(*) begin
        case (month)
            4'd1: day_of_year = day;
            4'd2: day_of_year = 16'd31 + day;
            4'd3: day_of_year = 16'd59 + day + leap_year;
            4'd4: day_of_year = 16'd90 + day + leap_year;
            4'd5: day_of_year = 16'd120 + day + leap_year;
            4'd6: day_of_year = 16'd151 + day + leap_year;
            4'd7: day_of_year = 16'd181 + day + leap_year;
            4'd8: day_of_year = 16'd212 + day + leap_year;
            4'd9: day_of_year = 16'd243 + day + leap_year;
            4'd10: day_of_year = 16'd273 + day + leap_year;
            4'd11: day_of_year = 16'd304 + day + leap_year;
            4'd12: day_of_year = 16'd334 + day + leap_year;
            default: day_of_year = 16'd0;
        endcase
    end

endmodule