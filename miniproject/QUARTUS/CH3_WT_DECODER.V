//CH3_WT_DECODER.V

module CH3_WT_DECODER(
	BCD,
	BUFF
);

input [3:0]BCD;
output[7:0]BUFF;


reg [7:0]BUFF;

always @(BCD)
begin
	case(BCD)
		4'b0000:BUFF=8'h30;	//0
		4'b0001:BUFF=8'h31;	//1
		4'b0010:BUFF=8'h32;	//2
		4'b0011:BUFF=8'h33;	//3
		4'b0100:BUFF=8'h34;	//4
		4'b0101:BUFF=8'h35;	//5
		4'b0110:BUFF=8'h36;	//6
		4'b0111:BUFF=8'h37;	//7
		4'b1000:BUFF=8'h38;	//8
		4'b1001:BUFF=8'h39;	//9
		default:BUFF=8'h00;	//NULL
	endcase
end


endmodule
