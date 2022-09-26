//CH2_4SIPO.V

module CH2_4SIPO(
	CLK, RESETN,
	DATA_IN,
	Q
);

input CLK, RESETN;
input DATA_IN;
output [3:0]Q;

reg [3:0]Q;

always @(posedge CLK)
begin
	if(~RESETN)
		Q=4'b0000;
	else
		begin
			Q[2:0]=Q[3:1];
			Q[3]=DATA_IN;
		end
end

endmodule
