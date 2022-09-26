//CH2_38DECODER.V

module CH2_38DECODER(
	SEL,
	O
);

input[2:0]SEL;
output[7:0]O;

reg[7:0]O;

always @(SEL)
begin
	case(SEL)
		3'B000:O = 8'B00000001;
		3'B001:O = 8'B00000010;
		3'B010:O = 8'B00000100;
		3'B011:O = 8'B00001000;
		3'B100:O = 8'B00010000;
		3'B101:O = 8'B00100000;
		3'B110:O = 8'B01000000;
		default:O = 8'B10000000;
	endcase
end

endmodule