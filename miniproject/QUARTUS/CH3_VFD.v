//CH3_VFD.v

module CH3_VFD(
	RESETN, CLK,
	KEY,
	LCD_E, LCD_RS, LCD_RW,
	LCD_DATA
);

input RESETN, CLK;
input [4:0]KEY;
output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;

wire LCD_E;
reg LCD_RS, LCD_RW;
reg [7:0] LCD_DATA;

reg [7:0] STATE;
parameter DELAY = 3'b000,
		FUNCTION_SET = 3'b001,
		ENTRY_MODE = 3'b010,
		DISP_ONOFF = 3'b011,
		LINE1 = 3'b100,
		LINE2 = 3'b101,
		DELAY_T = 3'b110,
		CLEAR_DISP = 3'b111;
		
integer CNT;


reg [6:0]HOUR, MIN, SEC;
wire [3:0]H10, H1, M10, M1, S10, S1;
reg [3:0]NUM;

integer CNT_T;
integer C_SIGNAL;
reg signal;

always @(posedge CLK)
begin
	if(~RESETN)
		begin
			C_SIGNAL = 0;
			signal = 1'b0;
		end
	else
		begin
			if(C_SIGNAL >= 40)
				begin
					signal = ~signal;
					C_SIGNAL = 0;
				end
			else
				C_SIGNAL = C_SIGNAL + 1;
		end
end

always @(posedge CLK)
begin
	if(~RESETN)
		CNT_T=0;
	else
		begin
			if(CNT_T>=99999)
				CNT_T=0;
			else
				CNT_T = CNT_T+1;
		end
end

always @(posedge CLK)
begin
	if(~RESETN)
		SEC=0;
	else
		begin
			if(CNT_T==99999)
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
			if((CNT_T == 99999)&&(SEC == 59))
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
			if((CNT_T==99999)&&(SEC==59)&&(MIN==59))
				begin
					if(HOUR>=23)
						HOUR=0;
					else
						HOUR=HOUR+1;
				end
		end
end


always @(posedge signal)
begin
	if(RESETN == 1'b0)
		STATE = DELAY;
	else
		begin
			case(STATE)
				DELAY:
					if(CNT == 70) STATE = FUNCTION_SET;
				FUNCTION_SET:
					if(CNT == 30) STATE = DISP_ONOFF;
				DISP_ONOFF:
					if(CNT == 30) STATE = ENTRY_MODE;
				ENTRY_MODE:
					if(CNT == 30) STATE = LINE1;
				LINE1:
					if(CNT == 20) STATE = LINE2;
				LINE2:
					if(CNT == 20) STATE = LINE1;
				DELAY_T:
					if(CNT == 0) STATE = CLEAR_DISP;
				CLEAR_DISP:
					if(CNT == 0) STATE = LINE1;
				default:STATE = DELAY;
			endcase
		end
end

always @(posedge signal)
begin
	if(RESETN == 1'b0)
		CNT = 0;
	else
		begin
			case(STATE)
				DELAY:
					if(CNT >= 70) CNT = 0;
					else CNT = CNT + 1;
				FUNCTION_SET:
					if(CNT >= 30) CNT = 0;
					else CNT = CNT + 1;
				DISP_ONOFF:
					if(CNT >= 30) CNT = 0;
					else CNT = CNT + 1;
				ENTRY_MODE:
					if(CNT >= 30) CNT = 0;
					else CNT = CNT + 1;
				LINE1:
					if(CNT >= 20) CNT = 0;
					else CNT = CNT + 1;
				LINE2:
					if(CNT >= 20) CNT = 0;
					else CNT = CNT + 1;
				DELAY_T:
					if(CNT >= 0)CNT = 0;
					else CNT = CNT;
				CLEAR_DISP:
					if(CNT >= 0)CNT = 0;
					else CNT = CNT;
				default: CNT = 0;
			endcase
	end
end


always @(posedge signal)
begin 
	if(RESETN == 1'b0)
		begin
			LCD_RS = 1'b1;
			LCD_RW = 1'b1;
			LCD_DATA = 8'b00000000;
			NUM = 0;
		end
	else
		begin
				case (STATE)
					FUNCTION_SET:
						begin
							LCD_RS = 1'b0;
							LCD_RW = 1'b0;
							LCD_DATA = 8'b00111100;
						end
					
					DISP_ONOFF:
						begin
							LCD_RS = 1'b0;
							LCD_RW = 1'b0;
							LCD_DATA = 8'b00001100;
						end
					
					ENTRY_MODE:
						begin
							LCD_RS = 1'b0;
							LCD_RW = 1'b0;
							LCD_DATA = 8'b00000110;
						end
					
					LINE1:
						begin
							
							LCD_RW = 1'b0;
							
							case (CNT)
								0:
									begin
										LCD_RS = 1'b0;
										LCD_DATA = 8'b10000000;
									end
								1:
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'b00100000;//
									end
								2:
									begin
										LCD_RS = 1'b1;
										NUM = H10;
										case(NUM)
											4'b0000:LCD_DATA=8'h30;	//0
											4'b0001:LCD_DATA=8'h31;	//1
											4'b0010:LCD_DATA=8'h32;	//2
											4'b0011:LCD_DATA=8'h33;	//3
											4'b0100:LCD_DATA=8'h34;	//4
											4'b0101:LCD_DATA=8'h35;	//5
											4'b0110:LCD_DATA=8'h36;	//6
											4'b0111:LCD_DATA=8'h37;	//7
											4'b1000:LCD_DATA=8'h38;	//8
											4'b1001:LCD_DATA=8'h39;	//9
											default:LCD_DATA=8'h00;	//NULL
										endcase
									end
								3:
									begin
										LCD_RS = 1'b1;
										NUM = H1;
										case(NUM)
											4'b0000:LCD_DATA=8'h30;	//0
											4'b0001:LCD_DATA=8'h31;	//1
											4'b0010:LCD_DATA=8'h32;	//2
											4'b0011:LCD_DATA=8'h33;	//3
											4'b0100:LCD_DATA=8'h34;	//4
											4'b0101:LCD_DATA=8'h35;	//5
											4'b0110:LCD_DATA=8'h36;	//6
											4'b0111:LCD_DATA=8'h37;	//7
											4'b1000:LCD_DATA=8'h38;	//8
											4'b1001:LCD_DATA=8'h39;	//9
											default:LCD_DATA=8'h00;	//NULL
										endcase
									end
								4:
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'h20;//i
									end
								5:
									begin
										LCD_RS = 1'b1;
										NUM = M10;
										case(NUM)
											4'b0000:LCD_DATA=8'h30;	//0
											4'b0001:LCD_DATA=8'h31;	//1
											4'b0010:LCD_DATA=8'h32;	//2
											4'b0011:LCD_DATA=8'h33;	//3
											4'b0100:LCD_DATA=8'h34;	//4
											4'b0101:LCD_DATA=8'h35;	//5
											4'b0110:LCD_DATA=8'h36;	//6
											4'b0111:LCD_DATA=8'h37;	//7
											4'b1000:LCD_DATA=8'h38;	//8
											4'b1001:LCD_DATA=8'h39;	//9
											default:LCD_DATA=8'h00;	//NULL
										endcase
									end
								6:	
									begin
										LCD_RS = 1'b1;
										NUM = M1;
										case(NUM)
											4'b0000:LCD_DATA=8'h30;	//0
											4'b0001:LCD_DATA=8'h31;	//1
											4'b0010:LCD_DATA=8'h32;	//2
											4'b0011:LCD_DATA=8'h33;	//3
											4'b0100:LCD_DATA=8'h34;	//4
											4'b0101:LCD_DATA=8'h35;	//5
											4'b0110:LCD_DATA=8'h36;	//6
											4'b0111:LCD_DATA=8'h37;	//7
											4'b1000:LCD_DATA=8'h38;	//8
											4'b1001:LCD_DATA=8'h39;	//9
											default:LCD_DATA=8'h00;	//NULL
										endcase
									end
								7:
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'h20;//i
									end
								8:
									begin
										LCD_RS = 1'b1;
										NUM = S10;
										case(NUM)
											4'b0000:LCD_DATA=8'h30;	//0
											4'b0001:LCD_DATA=8'h31;	//1
											4'b0010:LCD_DATA=8'h32;	//2
											4'b0011:LCD_DATA=8'h33;	//3
											4'b0100:LCD_DATA=8'h34;	//4
											4'b0101:LCD_DATA=8'h35;	//5
											4'b0110:LCD_DATA=8'h36;	//6
											4'b0111:LCD_DATA=8'h37;	//7
											4'b1000:LCD_DATA=8'h38;	//8
											4'b1001:LCD_DATA=8'h39;	//9
											default:LCD_DATA=8'h00;	//NULL
										endcase
									end
								9:
									begin
										LCD_RS = 1'b1;
										NUM = S1;
										case(NUM)
											4'b0000:LCD_DATA=8'h30;	//0
											4'b0001:LCD_DATA=8'h31;	//1
											4'b0010:LCD_DATA=8'h32;	//2
											4'b0011:LCD_DATA=8'h33;	//3
											4'b0100:LCD_DATA=8'h34;	//4
											4'b0101:LCD_DATA=8'h35;	//5
											4'b0110:LCD_DATA=8'h36;	//6
											4'b0111:LCD_DATA=8'h37;	//7
											4'b1000:LCD_DATA=8'h38;	//8
											4'b1001:LCD_DATA=8'h39;	//9
											default:LCD_DATA=8'h00;	//NULL
										endcase
									end	
								default :
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'b00100000;
									end
								endcase
							end
							
					LINE2:
						begin
							
							LCD_RW = 1'b0;
							
							case (CNT)
								0:
									begin
										LCD_RS = 1'b0;
										LCD_DATA = 8'b11000000;
									end
								1:
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'b00100000;//
									end
								2:
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'h39;//T
									end
								
								default :
									begin
										LCD_RS = 1'b1;
										LCD_DATA = 8'h39;
									end
								endcase
							end
					
					DELAY_T:
						begin
							LCD_RS = 1'b0;
							LCD_RW = 1'b0;
							LCD_DATA = 8'b00000010;
						end
					
					CLEAR_DISP:
						begin
							LCD_RS = 1'b0;
							LCD_RW = 1'b0;
							LCD_DATA = 8'b00000001;
						end
					default :
						begin
							LCD_RS = 1'b1;
							LCD_RW = 1'b1;
							LCD_DATA = 8'b00000000;
						end
				endcase

			end
end

CH3_WT_SEP S_SEP(SEC, S10, S1);
CH3_WT_SEP M_SEP(MIN, M10, M1);
CH3_WT_SEP H_SEP(HOUR, H10, H1);

assign LCD_E = ~signal;

endmodule
	