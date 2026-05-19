module LOCK(
input clk,
input enter,
input back,
input [3:0]in_pass,
input reset_pass,
output [6:0]show_number0,
output [6:0]show_number1,
output [6:0]show_number2,
output [6:0]show_number3,
output LED_SET,
output LED_VERIFY,
output LED_FREEZE,
output lock/*,
output [2:0]point_tin,
output [2:0]state_tin*/,
output button_anti);
/*assign point_tin=point;
assign state_tin=state;*/
assign button_anti=anti_button;
reg [3:0]save[3:0];
reg [3:0]pass_com[3:0];
reg [2:0]try;
reg [2:0]point;
reg [2:0]state;
reg anti_button;
//reg anti_next;
localparam [2:0] SET = 3'b000;
localparam [2:0] VERIFY = 3'b001;
localparam [2:0] FREEZE = 3'b010;
localparam [2:0] UNLOCKED = 3'b011;
always @(posedge clk) begin
	//anti_button=anti_next;
	if (~anti_button) begin
		if (~reset_pass) begin
			pass_com[0] = 4'b1111;
			pass_com[1] = 4'b1111;
			pass_com[2] = 4'b1111;
			pass_com[3] = 4'b1111;
			save[0] = 4'bz;
			save[1] = 4'bz;
			save[2] = 4'bz;
			save[3] = 4'bz;
			state = SET;
			try <= 3'b0;
			point <= 3'b100;
			anti_button=1;
		end
		else if (~enter || ~back) begin
			anti_button=1;
			case (state)
				SET: begin //che do SET -> so nhap vao luu thanh mat khau
					if (point == 3'b111) begin
						save[0] = pass_com[0];
						save[1] = pass_com[1];
						save[2] = pass_com[2];
						save[3] = pass_com[3];
						point <= 3'b100;
						state = VERIFY;
						try <= try;
						pass_com[0] = 4'b1111;
						pass_com[1] = 4'b1111;
						pass_com[2] = 4'b1111;
						pass_com[3] = 4'b1111;
					end else begin
						point <= point-3'b001;
						pass_com[point] = in_pass;
					end
				end
				VERIFY: begin
					if (point != 3'b111) begin
						point <= point-3'b001;
						pass_com[point] = in_pass;
						//state = VERIFY;
					end
					if (back) begin
						if (point == 3'b111) begin
							if (pass_com[0] == save[0] && pass_com[1] == save[1]
							&& pass_com[2] == save[2] && pass_com[3] == save[3]) begin //mat khau dung -> mo khoa
								state = UNLOCKED;
								pass_com[0] = 4'b1111;
								pass_com[1] = 4'b1111;
								pass_com[2] = 4'b1111;
								pass_com[3] = 4'b1111;
							end else begin //mat khau sai
								pass_com[0] = 4'b1111;
								pass_com[1] = 4'b1111;
								pass_com[2] = 4'b1111;
								pass_com[3] = 4'b1111;
								try <= try+3'b001;
								if (try == 3'b011) state = FREEZE; //sai nhieu qua (4 lan) -> FREEZE
								else state = state;
							end
							point <= 3'b100;
						end
					end else begin //backspace
						if (point != 3'b100) begin
							point <= point+3'b001;
							pass_com[point] <= 4'b1111;
						end
					end
				end
				FREEZE: begin
					if (~reset_pass) state <= SET;
					else begin
						pass_com[0] = 4'b1111;
						pass_com[1] = 4'b1111;
						pass_com[2] = 4'b1111;
						pass_com[3] = 4'b1111;
					end
				end
				UNLOCKED: begin //enter hoac back se lock lai cua
					save[0] = save[0];
					save[1] = save[1];
					save[2] = save[2];
					save[3] = save[3];
					try <= 3'b000;
					if (~reset_pass) state = SET;
					else if (~back | ~enter) state = VERIFY;
					else begin
						pass_com[0] = 4'b1111;
						pass_com[1] = 4'b1111;
						pass_com[2] = 4'b1111;
						pass_com[3] = 4'b1111;
						point <= 3'b100;
					end
				end
				default: begin
					pass_com[0] = 4'b1111;
					pass_com[1] = 4'b1111;
					pass_com[2] = 4'b1111;
					pass_com[3] = 4'b1111;
					save[0] = 4'bz;
					save[1] = 4'bz;
					save[2] = 4'bz;
					save[3] = 4'bz;
					state = SET;
					try <= 3'b0;
					point <= 3'b100;
				end
			endcase
		end
	end else if (reset_pass && enter && back) anti_button=0;
	//end else anti_button=0;
end
assign lock=(state==UNLOCKED)?1:0;
assign LED_SET=(state==SET)?1:0;
assign LED_VERIFY=(state==VERIFY)?1:0;
assign LED_FREEZE=(state==FREEZE)?1:0;
DECODER_7segment_Binary_to_Decimal cyoa0(pass_com[0], show_number0);
DECODER_7segment_Binary_to_Decimal cyoa1(pass_com[1], show_number1);
DECODER_7segment_Binary_to_Decimal cyoa2(pass_com[2], show_number2);
DECODER_7segment_Binary_to_Decimal cyoa3(pass_com[3], show_number3);
endmodule