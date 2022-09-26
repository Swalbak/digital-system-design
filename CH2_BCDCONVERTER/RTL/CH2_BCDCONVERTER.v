//CH2_BCDCONVERTER.V

module CH2_BCDCONVERTER(
	ONE, TEN,
	BIN
	);

input [3:0]ONE, TEN;
output [6:0]BIN;

wire [6:0] REG1, REG2, REG3, REG4, REG5, REG6, REG7, REG8;
wire [6:0] BIN;

assign REG1 = (ONE[0])? 7'b0000001: 7'b0000000;
assign REG2 = (ONE[1])? 7'b0000010: 7'b0000000;
assign REG3 = (ONE[2])? 7'b0000100: 7'b0000000;
assign REG4 = (ONE[3])? 7'b0001000: 7'b0000000;
assign REG5 = (ONE[0])? 7'b0001010: 7'b0000000;
assign REG6 = (ONE[1])? 7'b0010100: 7'b0000000;
assign REG7 = (ONE[2])? 7'b0101000: 7'b0000000;
assign REG8 = (ONE[3])? 7'b1010000: 7'b0000000;

assign BIN = REG1 + REG2 + REG3 + REG4 + REG5 + REG6 + REG7 + REG8;

endmodule
