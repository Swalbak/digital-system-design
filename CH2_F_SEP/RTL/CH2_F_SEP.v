//CH2_F_SEP.V

module CH2_F_SEP(
	CLK,
	Q
);

input CLK;
output[3:0]Q;

reg [3:0]Q;

always @(posedge CLK)
begin
	if(Q[0]==1'b0)Q[0]=1'b1;
	else Q[0]=1'b0;
end

always @(negedge Q[0])
begin
	if(Q[1]==1'b0)Q[1]=1'b1;
	else Q[1]=1'b0;
end

always @(negedge Q[1])
begin
	if(Q[2]==1'b0)Q[2]=1'b1;
	else Q[2]=1'b0;
end

always @(negedge Q[2])
begin
	if(Q[3]==1'b0)Q[3]=1'b1;
	else Q[3]=1'b0;
end

endmodule
