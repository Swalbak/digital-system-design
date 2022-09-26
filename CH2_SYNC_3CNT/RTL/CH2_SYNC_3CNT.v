//CH2_SYNC_3CNT

module CH2_SYNC_3CNT(
	CLK
	Q
);

input CLK;
output[2:0]Q;

reg [2:0]Q;

always @(negedge CLK)
begin
	if(Q[0]==1'b0) Q[0]=1'b1;
	else Q[0]=1'b0;
end

always @(negedge CLK)
begin
	if(Q[0]==1'b1)
	begin
		if(Q[1]==1'b0)
			Q[1]=1'b1;
		else Q[1]=1'b0;
	end
end

always @(negedge CLK)
begin
	if(Q[1:0]==2'b11)
	begin
		if(Q[2]==1'b0)
			Q[2]=1'b1;
		else Q[2]=1'b0;
	end
end

endmodule
