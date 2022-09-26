//CH2_83ENCODER.V

module CH2_83ENCODER(
	A,
	O
);

input[7:0]A;
output[2:0]O;

reg[2:0]O;

always @(A)
begin
	case(A)
		8'b00000001:O <= 3'b000;
		8'b00000010:O <= 3'b001;
		8'b00000100:O <= 3'b010;
		8'b00001000:O <= 3'b011;
		8'b00010000:O <= 3'b100;
		8'b00100000:O <= 3'b101;
		8'b01000000:O <= 3'b110;
		8'b10000000:O <= 3'b111;
		default:O <= 3'b000;
	endcase
end

endmodule