`timescale 1ns/1ps

module sign_and_magnitude_adder(
	input wire [3:0] a,
	input wire [3:0] b,
	output reg [3:0] f,
	output reg of
);
	reg signed [3:0] atc;
	reg signed [3:0] btc;
	reg [3:0] s;

	always @(*) begin
		if (a[3])
			atc = -$signed({1'b0, a[2:0]});
		else
			atc = $signed({1'b0, a[2:0]});

		if (b[3])
			btc = -$signed({1'b0, b[2:0]});
		else
			btc = $signed({1'b0, b[2:0]});

		s = atc + btc;
		of = ((~(atc[3] ^ btc[3])) & (atc[3] ^ s[3]));
		
		if (s[3]) begin
			f[3] = 1'b1;
			f[2:0] = (~s[2:0]) + 3'b001;
		end
		else begin
			f[3] = 1'b0;
			f[2:0] = s[2:0];
		end
	end

endmodule