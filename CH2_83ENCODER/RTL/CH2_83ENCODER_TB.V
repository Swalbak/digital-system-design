//CH2_83ENCODER_TB.V

`timescale 10ns/1ps

module CH2_83ENCODER_TB;

//input
reg[7:0]A;

//output
wire[2:0]O;

//instantiate the U1
CH2_83ENCODER U1(
	A,
	O
);

//Specify input stimulus
initial begin
	A = 8'b00000000;
	
	#10 A = 8'b00000001;
	
	#10 A = 8'b00000010;
	
	#10 A = 8'b00000100;
	
	#10 A = 8'b00001000;
	
	#10 A = 8'b00010000;
	
	#10 A = 8'b00100000;
	
	#10 A = 8'b01000000;
	
	#10 A = 8'b10000000;
	
end

endmodule