//COUNT_8BIT_TB.V

`timescale 1ns/1ps

module COUNT_8BIT_TB;

//input
reg RESETN, CLK;

//output
wire[7:0]COUNT_OUT;

//Instantiate the U1
COUNT_8BIT U1(
	RESETN,
	CLK,
	COUNT_OUT
	);
	
//Specify input stimulus
	
initial begin
	CLK = 0;
		
	RESETN = 0;
		
	#100 RESETN = 1;
		
end

//colck generation
always begin
	CLK = 0;
	#25;
	CLK = 1;
	#25;

end

endmodule