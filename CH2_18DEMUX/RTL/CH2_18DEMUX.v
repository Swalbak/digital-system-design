//CH2_18DEMUX.V

module CH2_18DEMUX(
	I, S,
	O
	);

input I;
input [2:0]S;
output [7:0]O;

wire [7:0]O;

assign O[0] = (S == 3'b000)?I:1'b0;
assign O[1] = (S == 3'b001)?I:1'b0;
assign O[2] = (S == 3'b010)?I:1'b0;
assign O[3] = (S == 3'b011)?I:1'b0;
assign O[4] = (S == 3'b100)?I:1'b0;
assign O[5] = (S == 3'b101)?I:1'b0;
assign O[6] = (S == 3'b110)?I:1'b0;
assign O[7] = (S == 3'b111)?I:1'b0;


endmodule

