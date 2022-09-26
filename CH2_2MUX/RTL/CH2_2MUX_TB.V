//CH2_2MUX_TB.V

`timescale 10ns/1ps

module CH2_2MUX_TB;

//input
reg I0, I1, S;

//output
wire Z;

//instantiate the U1
CH2_2MUX U1(
	I0, I1, S, 
	Z
);

//Specify input stimulus
initial begin
	S <= 0;
	#50 S<=1;
end

always begin
	I0 = 0;
	#2;
	I0 = 1;
	#2;
end

always begin
	I1 = 0;
	#5;
	I1 = 1;
	#5;
end

endmodule