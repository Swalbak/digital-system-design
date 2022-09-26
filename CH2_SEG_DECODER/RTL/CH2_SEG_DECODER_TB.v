//CH2_SEG_DECODER_TB.V

`timescale 10ns/1ps

module CH2_SEG_DECODER_TB;

//input
reg [3:0] BCD;

//output
wire a, b, c, d, e, f, g;

//Instantiate the U1
CH2_SEG_DECODER_U1(
	BCD,
	a, b, c, d, e, f, g
);

//Specify input stimulus
initial begin
	BCD <= 4'b0000;
	
	#10 BCD <= 4'b0001;
	
	#10 BCD <= 4'b0010;

	#10 BCD <= 4'b0011;

	#10 BCD <= 4'b0100;

	#10 BCD <= 4'b0101;

	#10 BCD <= 4'b0110;

	#10 BCD <= 4'b0111;

	#10 BCD <= 4'b1000;

	#10 BCD <= 4'b1001;

end

endmodule
