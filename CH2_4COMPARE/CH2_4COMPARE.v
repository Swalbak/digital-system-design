//CH2_4COMPARE.V

module CH2_4COMPARE(
	A, B,
	O
	);

input [3:0]A, B;
output [2:0]O;

wire [2:0]O;

assign O[2] = (A>B)?1'b1 : 1'b0;
assign O[1] = (A==B)?1'b1 : 1'b0;
assign O[0] = (A<B)?1'b1 : 1'b0;

endmodule
