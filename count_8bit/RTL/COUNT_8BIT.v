//COUNT_8BIT.V

module COUNT_8BIT(
	RESETN, CLK,
	COUNT_OUT
);

input RESETN;
input CLK;
output [7:0]COUNT_OUT;

reg [7:0] COUNT_OUT;

always @(posedge CLK)
begin
	if(~RESETN)
		COUNT_OUT<=8'B00000000;
	else
		COUNT_OUT<=COUNT_OUT+1;
end

endmodule