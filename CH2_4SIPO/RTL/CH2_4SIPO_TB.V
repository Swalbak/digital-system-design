//CH2_4SIPO_TB.V

`timescale 10ns/1ps

module CH2_4SIPO_TB;

//input
reg CLK, RESETN, DATA_IN;

//output
wire [3:0]Q;

//Instantiate the U1
CH2_4SIPO U1(
	CLK, RESETN, DATA_IN,
	Q
);

//Specify input stimulus
initial begin
	RESETN=1'b0; CLK=1'b0; DATA_IN=1'b0;
	
	#10 RESETN=1'b1;
	#10 DATA_IN=1'b1;
	#20 DATA_IN=1'b0;
	#10 DATA_IN=1'b1;
	#30 DATA_IN=1'b0;
end

always begin
	CLK=0;
	#5;
	CLK=1;
	#5;
end

endmodule
