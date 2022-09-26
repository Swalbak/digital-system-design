//CH2_SEG_DECODER.V

module CH2_SEG_DECODER(
	a, b, c, d, e, f, g
);

output a, b, c, d, e, f, g;

reg [6:0] decode = 7'b1111010;

assign {a, b, c, d, e, f, g} = decode;	//7

endmodule
