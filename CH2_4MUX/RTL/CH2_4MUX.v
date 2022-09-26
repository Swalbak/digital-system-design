//CH2_4MUX.V

module CH2_4MUX(
	I, S,
	Z
	);
	
input[3:0]I;
input[1:0]S;
output Z;

reg Z;

always @(I, S)
begin
	case(S)
		2'b00: Z <= I[3];
		2'b01: Z <= I[2];
		2'b10: Z <= I[1];
		2'b11: Z <= I[0];
		default: Z <= 0;
	endcase
end

endmodule
	