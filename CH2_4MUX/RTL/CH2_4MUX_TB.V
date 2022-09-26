//CH2_4MUX_TB.V

`timescale 10ns/1ps

module CH2_4MUX_TB;

//input
reg[3:0]I;
reg[1:0]S;

//output
wire Z;

//Instantiate the U1
CH2_4MUX U1(
	I, S,
	Z
);

//Specify input stimulus
initial begin
	S <= 2'b00;
	#25 S <= 2'b01;
	#25 S <= 2'b10;
	#25 S <= 2'b11;
end

always begin
	I[0] = 0;
	#1 I[0] = 1;
	#1;
end

always begin
	I[1] = 1;
	#3 I[1] = 0;
	#3;
end

always begin
	I[2] = 0;
	#5 I[2] = 1;
	#5;
end

always begin
	I[3] = 1;
	#9 I[3] = 0;
	#9;
end

endmodule