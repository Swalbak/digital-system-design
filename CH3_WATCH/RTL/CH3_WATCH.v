//CH3_WATCH.V

module CH3_WATCH(
	RESETN, CLK,
	SEG_COM, SEG_DATA
);

input RESETN, CLK;
output [7:0]SEG_COM, SEG_DATA;

reg [7:0]SEG_COM;
wire [7:0]SEG_DATA;

integer CNT;
integer CNT_SCAN;

reg [6:0]HOUR, MIN, SEC;

wire [3:0]H10, H1, M10, M1, S10, S1;
reg [3:0]NUM;

reg SEG_DOT;

always @(posedge CLK)
begin
	if(~RESETN)
		CNT=0;
	else
		begin
			if(CNT>=999)
				CNT=0;
			else
				CNT = CNT+1;
		end
end

always @(posedge CLK)
begin
	if(~RESETN)
		SEC=0;
	else
		begin
			if(CNT==999)
				begin
					if(SEC>=59)
						SEC=0;
					else
						SEC=SEC+1;
				end
		end
end

always @(posedge CLK)
begin
	if(~RESETN)
		MIN=0;
	else
		begin
			if((CNT == 999)&&(SEC == 59))
				begin
					if(MIN>=59)
						MIN = 0;
					else
						MIN = MIN+1;
				end
		end
end

always @(posedge CLK)
begin
	if(~RESETN)
		HOUR=0;
	else
		begin
			if((CNT==999)&&(SEC==59)&&(MIN==59))
				begin
					if(HOUR>=23)
						HOUR=0;
					else
						HOUR=HOUR+1;
				end
		end
end

always @(posedge CLK)
begin
	if(~RESETN)
		begin
			SEG_DOT=1'b0;
			SEG_COM=8'b00000000;
			NUM=0;
			CNT_SCAN=0;
		end
	else
		begin
			if(CNT_SCAN>=5)
				CNT_SCAN=0;
			else
				CNT_SCAN=CNT_SCAN+1;
				
			case(CNT_SCAN)
				0:
					begin
						NUM=H10;
						SEG_DOT=1'b0;
						SEG_COM=8'b01111111;
					end
				1:
					begin
						NUM=H1;
						SEG_DOT=1'b1;
						SEG_COM=8'b10111111;
					end
				2:
					begin
						NUM=M10;
						SEG_DOT=1'b0;
						SEG_COM=8'b11011111;
					end
				3:
					begin
						NUM=M1;
						SEG_DOT=1'b1;
						SEG_COM=8'b11101111;
					end
				4:
					begin
						NUM=S10;
						SEG_DOT=1'b0;
						SEG_COM=8'b11110111;
					end
				5:
					begin
						NUM=S1;
						SEG_DOT=1'b1;
						SEG_COM=8'b11111011;
					end
				default:
					begin
						NUM=0;
						SEG_DOT=1'b0;
						SEG_COM=8'b11111111;
					end
				endcase
		end
end

CH3_WT_SEP S_SEP(SEC, S10, S1);
CH3_WT_SEP M_SEP(MIN, M10, M1);
CH3_WT_SEP H_SEP(HOUR, H10, H1);

CH3_WT_DECODER S_DECODE(NUM, SEG_DOT, SEG_DATA);

endmodule
