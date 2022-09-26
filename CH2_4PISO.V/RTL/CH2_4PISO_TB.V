//CH2_4PISO_TB.V

`timescale 10ns/1ps

module CH2_4PISO_TB;

//input
reg CLK, SH_LDN;
reg [3:0]D;

//output
wire Q;

//Instantiate the U1
CH2_4PISO U1(
	CLK, SH_LDN, D,
	Q
);

//Specify input stimulus
initial begin
	SH_LDN=1'b0; CLK=1'b0; D=4'b000;
	
	#5 SH_LDN=1'b1;
	#20 D=4'b1101; SH_LDN=1'b0;
	#5 SH_LDN=1'b1;
	#20 D=4'b0010; SH_LDN=1'b0;
	#5 SH_LDN=1'b1;
end

always begin
	CLK=0;
	#1;
	CLK=1;
	#1;
end

endmodule
