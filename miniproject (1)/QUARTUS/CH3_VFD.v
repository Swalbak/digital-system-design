//CH3_VFD.v

module CH3_VFD(
	RESETN, CLK,
	KEY,
	LCD_E, LCD_RS, LCD_RW,
	LCD_DATA,
	PIEZO
);

input RESETN, CLK;
input [7:0]KEY;
output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;
output PIEZO;

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

// flag(time set, alarm set
reg [2:0] flag;
reg alarm_set;
reg melody_set;

// time set
wire [3:0]H10_SET, H1_SET, M10_SET, M1_SET, S10_SET, S1_SET;
reg [6:0]HOUR_BUF, MIN_BUF, SEC_BUF;
integer TIME_SET_CURSOR;
integer KEY_TIMER;

//alarm set
reg [6:0]ALRM_HOUR, ALRM_MIN, ALRM_SEC; 
reg [7:0] ALRM_SET1, ALRM_SET2, ALRM_SET3, ALRM_SET4, ALRM_BUF;
integer ALRM_SET_CNT;

//piezo clock
reg P_CLK;
wire PIEZO;
integer LIMIT;
integer CNT_SOUND;
integer P_CNT;
integer OFF_CNT;
reg [7:0] P_SCAN;

//piezo set
always @(posedge CLK)
begin
	if(~RESETN)
		begin
			P_CLK = 1'b0;
			CNT_SOUND = 0;
		end
	else
		begin
			if(CNT_SOUND >= LIMIT)
				begin
					CNT_SOUND = 0;
					P_CLK = ~P_CLK;
				end
			else
				CNT_SOUND = CNT_SOUND + 1;
		end
end

assign PIEZO = P_CLK;

always @(posedge CLK)
begin
	if(~RESETN)
		begin
			LIMIT = 0;
			P_CNT = 0;
			P_SCAN = 8'h00;
			ALRM_BUF = 8'h00;
		end
	else
		begin
			if(alarm_set == 1'b1 && flag == 3'b111)
				begin
					if(CNT_T >= 99999)
						P_CNT = P_CNT + 1;
					
					if(P_CNT < 2)
						begin
							if(melody_set == 1'b0)
								ALRM_BUF = 8'b00001000;
							else
								ALRM_BUF = ALRM_SET1;
						end
					else if(P_CNT < 4)
						begin
							if(melody_set == 1'b0)
								ALRM_BUF = 8'b00000100;
							else
								ALRM_BUF = ALRM_SET2;
						end
					else if(P_CNT < 6)
						begin
							if(melody_set == 1'b0)
								ALRM_BUF = 8'b00000010;
							else
								ALRM_BUF = ALRM_SET3;
						end
					else if(P_CNT < 8)
						begin
							if(melody_set == 1'b0)
								ALRM_BUF = 8'b00000001;
							else
								ALRM_BUF = ALRM_SET4;
						end
					else
						P_CNT = 0;
					
					case(ALRM_BUF)
						8'b00001000: LIMIT = 190;
						8'b00000100: LIMIT = 169;
						8'b00000010: LIMIT = 151;
						8'b00000001: LIMIT = 142;
					endcase
					
					P_SCAN = ALRM_BUF;
				end
			else
				begin
					P_CNT = 0;
					LIMIT = 0;
				end
		end
end

// flag set
always @(posedge CLK)
begin
	if(~RESETN)
		begin
			flag = 3'b000;
			TIME_SET_CURSOR = 0;
			SEC_BUF = 0;
			MIN_BUF = 0;
			HOUR_BUF = 0;
			KEY_TIMER = 0;
			
			ALRM_HOUR = 0;
			ALRM_MIN = 0;
			ALRM_SEC = 0;
			
			alarm_set = 1'b0;
			OFF_CNT = 0;
			ALRM_SET_CNT = 0;
			
			ALRM_SET1 = 8'h00;
			ALRM_SET2 = 8'h00;
			ALRM_SET3 = 8'h00;
			ALRM_SET4 = 8'h00;
			melody_set = 1'b0;
		end
	else
		begin
			if(alarm_set == 1'b1 && HOUR == ALRM_HOUR && MIN == ALRM_MIN && SEC == ALRM_SEC)
				flag = 3'b111;
				
			if(KEY_TIMER <= 99999)
				KEY_TIMER = KEY_TIMER + 1;
			else
				begin
					KEY_TIMER = 0;
					
					//flag set
					if(flag == 3'b000)
						begin
							if(KEY == 8'b10000000)	//timeset flag
								begin
									flag = 3'b001;
									HOUR_BUF = HOUR;
									MIN_BUF = MIN;
									SEC_BUF = SEC;
								end
							else if(KEY == 8'b01000000)
								begin
									flag = 3'b010;
									HOUR_BUF = HOUR;
									MIN_BUF = MIN;
									SEC_BUF = SEC;
								end
							else if(KEY == 8'b00100000)
								begin
									flag = 3'b011;
									HOUR_BUF = HOUR;
									MIN_BUF = MIN;
									SEC_BUF = SEC;
								end
							else if(KEY == 8'b00010000)
								begin
									flag = 3'b100;
									melody_set = 1'b1;
									ALRM_SET_CNT = 0;
								end
							else
								flag = flag;
						end
						
					// time set
					if(flag == 3'b001 || flag == 3'b010)
						begin
							if(KEY == 8'b00000010)
								begin
									if(flag == 3'b010)
										begin
											ALRM_HOUR = HOUR_BUF;
											ALRM_MIN = MIN_BUF;
											ALRM_SEC = SEC_BUF;
											alarm_set = 1'b1;
										end
									flag = 3'b000;
									TIME_SET_CURSOR = 0;
								end
							else if(KEY == 8'b00000100)	//shift cursor(t10, t1, m10, ...)
								begin
									TIME_SET_CURSOR = TIME_SET_CURSOR + 1;
									if(TIME_SET_CURSOR >= 6)
										TIME_SET_CURSOR = 0;
								end
							else if(KEY == 8'b00001000)
								begin
									begin
										case(TIME_SET_CURSOR)
											0:
												begin
													HOUR_BUF = HOUR_BUF + 10;
												end
											1:
												begin
													HOUR_BUF = HOUR_BUF + 1;
												end
											2:
												begin
													MIN_BUF = MIN_BUF + 10;
												end
											3:
												begin
													MIN_BUF = MIN_BUF + 1;
												end
											4:
												begin
													SEC_BUF = SEC_BUF + 10;
												end
											5:
												begin
													SEC_BUF = SEC_BUF + 1;
												end
										endcase
									end
								end
							else
								begin
								end
						end
						
					//show alarm
					if(flag == 3'b011)
						begin
							if(KEY == 8'b00000010)
								flag = 3'b000;
								
							if(alarm_set == 1'b1)
								begin
									SEC_BUF = ALRM_SEC;
									MIN_BUF = ALRM_MIN;
									HOUR_BUF = ALRM_HOUR;
								end
							else
								flag = 3'b010;
							
						end
					
					// alarm melody setting
					if(flag == 3'b100)
						begin
							if(KEY == 8'b00001000 || KEY == 8'b00000100 || KEY == 8'b00000010 || KEY == 8'b00000001)
								begin
									case(ALRM_SET_CNT)
										0:
											ALRM_SET1 = KEY;
										1:
											ALRM_SET2 = KEY;
										2:
											ALRM_SET3 = KEY;
										3:
											ALRM_SET4 = KEY;
										default:
											ALRM_SET_CNT = ALRM_SET_CNT;
									endcase
									
									if(ALRM_SET_CNT >= 3)
										begin
											flag = 3'b000;
											ALRM_SET_CNT = 0;
										end
									else
										ALRM_SET_CNT = ALRM_SET_CNT + 1;
									
								end
						end
					// alarm
					if(flag == 3'b111)
						begin
							if(OFF_CNT >= 4)
								begin
									OFF_CNT = 0;
									flag = 3'b000;
								end
								
							if(KEY == P_SCAN)
								OFF_CNT = OFF_CNT + 1;
						end
						
					if(SEC_BUF > 59)
						SEC_BUF = 0;
						
					if(MIN_BUF > 59)
						MIN_BUF = 0;
						
					if(HOUR_BUF > 23)
						HOUR_BUF = 0;
						
				end
		end
end

				
// character lcd clock
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

// time clock
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

// sec, secbuf setting
always @(posedge CLK)
begin
	if(~RESETN)
		begin
			SEC=0;
			MIN=0;
			HOUR=0;
		end
	else
		begin
			if(flag == 3'b001)
				begin
					HOUR = HOUR_BUF;
					MIN = MIN_BUF;
					SEC = SEC_BUF;
				end
			else
				begin
					if((CNT_T==99999)&&(SEC==59)&&(MIN==59))
						begin
							if(HOUR>=23)
								HOUR=0;
							else
								HOUR=HOUR+1;
						end
						
					if((CNT_T == 99999)&&(SEC == 59))
						begin
							if(MIN>=59)
								MIN = 0;
							else
								MIN = MIN+1;
						end
						
					if(CNT_T==99999)
						begin
							if(SEC>=59)
								SEC=0;
							else
								SEC=SEC+1;
						end	
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
							if(flag == 3'b001 || flag == 3'b010 || flag == 3'b011)
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
												NUM = H10_SET;
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
												NUM = H1_SET;
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
												if(CNT_T < 50000)
													LCD_DATA = 8'h3A;//i
												else
													LCD_DATA = 8'h20;
											end
										5:
											begin
												LCD_RS = 1'b1;
												NUM = M10_SET;
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
												NUM = M1_SET;
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
												if(CNT_T < 50000)
													LCD_DATA = 8'h3A;//i
												else
													LCD_DATA = 8'h20;
											end
										8:
											begin
												LCD_RS = 1'b1;
												NUM = S10_SET;
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
												NUM = S1_SET;
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
										11:
											begin
												LCD_RS = 1'b1;
												if(flag == 3'b010 || flag == 3'b011)
													LCD_DATA = 8'h41;	// A
												else if(flag == 3'b001)
													LCD_DATA = 8'h54;	//T
												else
													LCD_DATA = 8'h4D;	//M
											end
										12:
											begin
												LCD_RS = 1'b1;
												if(flag == 3'b010 || flag == 3'b011)
													LCD_DATA = 8'h4C;	//L
												else if(flag == 3'b001)
													LCD_DATA = 8'h49;	//I
												else
													LCD_DATA = 8'h65;	//e
											end
										13:
											begin
												LCD_RS = 1'b1;
												if(flag == 3'b010 || flag == 3'b011)
													LCD_DATA = 8'h41;	//A
												else if(flag == 3'b001)
													LCD_DATA = 8'h4D;	//M
												else
													LCD_DATA = 8'h6C;	//l
											end
										14:
											begin
												LCD_RS = 1'b1;
												if(flag == 3'b010 || flag == 3'b011)
													LCD_DATA = 8'h52;	//R
												else if(flag == 3'b001)
													LCD_DATA = 8'h45;	//E
												else
													LCD_DATA = 8'h6F;	//o
											end
										15:
											begin
												LCD_RS = 1'b1;
												if(flag == 3'b010 || flag == 3'b011)
													LCD_DATA = 8'h4D;	//M
												else if(flag == 3'b001)
													LCD_DATA = 8'h20;
												else
													LCD_DATA = 8'h64;	//d
											end
										16:
											begin
												LCD_RS = 1'b1;
												if(flag == 3'b100)
													LCD_DATA = 8'h64;	//y
												else
													LCD_DATA = 8'h20;
											end
											
										default:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'b00100000;
											end
										endcase
									end
									
							else	//flag == 0
								begin
									LCD_RW = 1'b0;
									case (CNT)
										0:
											begin
												LCD_RS = 1'b0;
												LCD_DATA = 8'b10000000;
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
												if(CNT_T < 50000)
													LCD_DATA = 8'h3A;//i
												else
													LCD_DATA = 8'h20;
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
												if(CNT_T < 50000)
													LCD_DATA = 8'h3A;//i
												else
													LCD_DATA = 8'h20;
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
										11:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h43;	//C
											end
										12:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h4C;	//L
											end
										13:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h4F;	//O
											end
										14:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h43;	//C
											end
										15:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h4B;	//K
											end
											
										default :
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h20;
											end
										endcase
									end
								end
					LINE2:
						begin
							
							LCD_RW = 1'b0;
							if(flag == 3'b001 || flag == 3'b010)
								begin
									case (CNT)
										0:
											begin
												LCD_RS = 1'b0;
												LCD_DATA = 8'b11000000;
											end
										2:
											begin
												LCD_RS = 1'b1;
												if(TIME_SET_CURSOR == 0)
													LCD_DATA = 8'h18;
												else
													LCD_DATA = 8'b00100000;//
											end
										3:
											begin
												LCD_RS = 1'b1;
												if(TIME_SET_CURSOR == 1)
													LCD_DATA = 8'h18;	//direct
												else
													LCD_DATA = 8'h20;//' '
											end
										5:
											begin
												LCD_RS = 1'b1;
												if(TIME_SET_CURSOR == 2)
													LCD_DATA = 8'h18;
												else
													LCD_DATA = 8'h20;//' '
											end
										6:
											begin
												LCD_RS = 1'b1;
												if(TIME_SET_CURSOR == 3)
													LCD_DATA = 8'h18;
												else
													LCD_DATA = 8'h20;
											end
										8:
											begin
												LCD_RS = 1'b1;
												if(TIME_SET_CURSOR == 4)
													LCD_DATA = 8'h18;
												else
													LCD_DATA = 8'h20;
											end
										9:
											begin
												LCD_RS = 1'b1;
												if(TIME_SET_CURSOR == 5)
													LCD_DATA = 8'h18;
												else
													LCD_DATA = 8'h20;
											end
										12:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h53;
											end
										13:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h45;
											end
										14:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h54;
											end
											
										default :
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h20;
											end
										endcase
									end
							else if(flag == 3'b011)
								begin
									case(CNT)
										0:
											begin
												LCD_RS = 1'b0;
												LCD_DATA = 8'b11000000;
											end
										10:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h53;	//S
											end
										11:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h65;	//e
											end
										12:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h74;	//t
											end
										13:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h74;	//t
											end
										14:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h65;	//e
											end
										15:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h64;	//d
											end
										default :
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h20;
											end
											
										endcase
									end
							else if(flag == 3'b100)
								begin
									case(CNT)
										0:
											begin
												LCD_RS = 1'b0;
												LCD_DATA = 8'b11000000;
											end
										2:
											begin
												LCD_RS = 1'b1;
												case(ALRM_SET_CNT)
													0: LCD_DATA = 8'h30;
													1:	LCD_DATA = 8'h31;
													2: LCD_DATA = 8'h32;
													3: LCD_DATA = 8'h33;
												endcase
											end
										3:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h2F;	// '/'
											end
										4:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h34;	//4
											end
										6:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h53;	//S
											end
										7:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h65;	//e
											end
										8:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h74;	//t
											end
											
										default :
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h20;
											end
											
										endcase
								end
							else if(flag == 3'b111)
								begin
									case(CNT)
										0:
											begin
												LCD_RS = 1'b0;
												LCD_DATA = 8'b11000000;
											end
										2:
											begin
												LCD_RS = 1'b1;
												case(OFF_CNT)
													0: LCD_DATA = 8'h30;
													1:	LCD_DATA = 8'h31;
													2: LCD_DATA = 8'h32;
													3: LCD_DATA = 8'h33;
													4: LCD_DATA = 8'h34;
												endcase
											end
										3:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h2F;	// '/'
											end
										4:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h34;	//4
											end
										6:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h53;	//S
											end
										7:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h65;	//e
											end
										8:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h74;	//t
											end
											
										default :
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h20;
											end
									endcase
								end
							else
								begin
									case (CNT)
										0:
											begin
												LCD_RS = 1'b0;
												LCD_DATA = 8'b11000000;
											end
										2:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h31;	// 1
											end
										3:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h2C;	//,
											end
										4:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h32;	//2
											end
										5:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h2C;	//,
											end
										6:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h33;	//3
											end
										7:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h2C;	//,
											end
										8:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h34;	//4
											end
										9:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h3A;	//:
											end
										11:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h4D;	//M
											end
										12:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h45;	//E
											end
										13:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h4E;	//N
											end
										14:
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h55;	//U
											end
										default :
											begin
												LCD_RS = 1'b1;
												LCD_DATA = 8'h20;
											end
										endcase
									end
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

CH3_WT_SEP S_BUF_SEP(SEC_BUF, S10_SET, S1_SET);
CH3_WT_SEP M_BUF_SEP(MIN_BUF, M10_SET, M1_SET);
CH3_WT_SEP H_BUF_SEP(HOUR_BUF, H10_SET, H1_SET);

assign LCD_E = ~signal;

endmodule
	