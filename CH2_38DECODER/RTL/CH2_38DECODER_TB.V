//CH2_38DECODER_TB.V

`timescale 10ns/1ps

module TestBench;

//input
reg[2:0]SEL;

//output
wire[7:0]O;

//Instantiate the U1
CH2_38DECODER U1(
SEL,
O
);

//Specify input stimulus
initial begin
	SEL <= 3'b000;
	
	#10
	SEL <= 3'b001;
	
	#10
	SEL <= 3'b010;
	
	#10
	SEL <= 3'b011;
	
	#10
	SEL <= 3'b100;
	
	#10
	SEL <= 3'b101;
	
	#10
	SEL <= 3'b110;
	
	#10
	SEL <= 3'b111;

end

endmodule