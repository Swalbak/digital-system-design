//CH2_SYNC_3CNT2.V

module CH2_SYNC_3CNT2(
	RESETN, CLK,
	Q, SEG
);

input RESETN, CLK;
output [2:0]Q;
output [6:0]SEG;

reg [2:0]Q;
reg [6:0]SEG;

always @(negedge CLK)
begin
	if(~RESETN)Q=3'b000;
	else if(Q>=3'b111)Q=3'b000;
	else Q=Q+1;
end

always @(RESETN, Q)
begin
	if(~RESETN)SEG=7'b0000000;
	else
		begin
			case(Q)
				3'b000:SEG=7'b1111110;	//0
				3'b001:SEG=7'b0110000;	//1
				3'b010:SEG=7'b1101101;	//2
				3'b011:SEG=7'b1111011;	//3
				3'b100:SEG=7'b0110011;	//4
				3'b101:SEG=7'b1011011;	//5
				3'b110:SEG=7'b1011111;	//6
				3'b111:SEG=7'b1110000;	//7
				default:SEG=7'b0000000;	//null
			endcase
		end
end

endmodule
