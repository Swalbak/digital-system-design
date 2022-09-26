//CH2_SYNC_3CNT2_TB.V

`timescale 10ns/1ps

module CH2_SYNC_3CNT2_TB;

//input
reg RESETN, CLK;

//output
wire [2:0]Q;
wire [6:0]SEG;

//Instantiate the U1
CH2_SYNC_3CNT2 U1(
	RESETN, CLK,
	Q, SEG
);

//Specify input stimulus
initial begin
	RESETN=0; CLK=0;
	#10 RESETN=1;
end

always begin
	CLK=0;
	#1;
	CLK=1;
	#1;
end

endmodule
