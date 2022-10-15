//CH2_4PISO.V

module CH2_4PISO(
	CLK, SH_LDN,
	D, Q
);

input CLK, SH_LDN;
input [3:0]D;
output Q;

reg [3:0]BUFF;
wire Q;


always @(posedge CLK)
begin
	if(~SH_LDN)
		BUFF=D;
	else
		begin
			BUFF[3:1]=BUFF[2:0];
			BUFF[0]=1'b0;
		end
end

assign Q=BUFF[3];

endmodule
