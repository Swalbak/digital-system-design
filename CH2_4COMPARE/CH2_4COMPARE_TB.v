//CH2_4COMPARE_TB.V

`timescale 10ns/1ps

module CH2_4COMPARE_TB;

//input
reg [3:0]A, B;

//output
wire[2:0]O;

//instantiate the U1
CH2_4COMPARE U1(
	A, B,
	O
);

//Specify input stimulus
initial begin
	A <= 4'b0000; B <= 4'b0000;
	
	#20 A <= 4'b1100; B<=4'b0111;
	
	#20 A <= 4'b1001; B<=4'b1001;

	#20 A <= 4'b0010; B<=4'b1010;
end

endmodule
