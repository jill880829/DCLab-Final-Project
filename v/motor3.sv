module motor_control3(
	input i_clock, //40M
	input i_rst,
	input i_start,
	input [8:0]i_coord_x,
	input [8:0]i_coord_y,
	input i_done,
	input i_down,
	output o_request_coord,
	output o_en_x_y,
	output o_step_x,
	output o_dir_x,
	output o_step_y,
	output o_dir_y,
	output o_z,
	output [1:0]o_state, //test
	output [8:0]o_coord_x, //test
	output [8:0]o_coord_y, //test
	output [19:0] test
);
logic [7:0]cnt_x,cnt_y;
logic [20:0]cnt_z;
logic [24:0]num_cnt;
logic [24:0]step_clk;
logic up_and_down;
logic [1:0]state; //0:wait 1:start 2:stop 3:over
logic dir_x,dir_y,en_x_y;
logic [8:0]pre_x,pre_y,cur_x,cur_y;
logic wait_nxt_coord,get_data;
logic coord_z;
logic [7:0]touch_times;
logic en_step_x,en_step_y;
logic [20:0] wait_move;
logic aclrt,dclrt;
logic [16:0] cycle;
logic down;

parameter UP = 70000;
parameter DOWN = 80000;
//logic [2:0]cnt_one_step;

assign o_step_x = en_step_x ? up_and_down : 1'bz;
assign o_step_y = en_step_y ? up_and_down : 1'bz;
assign o_dir_x = dir_x;
assign o_dir_y = dir_y;
assign o_en_x_y = en_x_y;
assign o_request_coord = wait_nxt_coord;
assign o_z = coord_z;
assign o_state = state;
assign o_coord_x = num_cnt[15:7];
assign o_coord_y = num_cnt[24:16];
assign test = num_cnt[19:0];

always_ff @(posedge i_clock or negedge i_rst) begin 
	if(!i_rst) begin
		 cnt_x <= 0;
		 cnt_y <= 0;
		 step_clk <= 0;
		 up_and_down <= 0;
		 state <= 0;
		 dir_x <= 0;
		 dir_y <= 0;
		 en_x_y <= 1;
		 en_step_x <= 0;
		 en_step_y <= 0;
		 wait_nxt_coord <= 0;
		 pre_x <= 0;
		 pre_y <= 0;
		 cur_x <= 0;
		 cur_y <= 0;
		 cnt_z <= 0;
		 coord_z <= 0;
		 touch_times <= 0;
		 get_data <= 0;
		 wait_move <= 0;
		 aclrt <= 0;
		 dclrt <= 0;
		 num_cnt <= 1020000;
		 cycle <= UP;
		 down <= 0;
		 //cnt_one_step <= 0;
	end 
	else begin
	 	 up_and_down <= (step_clk+1 == num_cnt) ? (!up_and_down) : up_and_down;
	 	 cnt_z <= (cnt_z+1 == 800000) ? 0 : cnt_z+1;
		 if(state == 0 && i_start) begin
				state <= 1;
				dir_x <= 0;
				dir_y <= 0;
				cnt_x <= 0;
				cnt_y <= 0;
				en_x_y <= 0;
				en_step_x <= 0;
				en_step_y <= 0;
				wait_nxt_coord <= 1;
				pre_x <= 0;
				pre_y <= 0;
				cur_x <= 0;
				cur_y <= 0;
				touch_times <= 0;
				get_data <= 0;
				wait_move <= 0;
				coord_z <= (cnt_z < cycle) ? 1 : 0;
				aclrt <= 0;
				dclrt <= 0;
				num_cnt <= 1020000;
				//cnt_one_step <= 0;
				down <= 0;
		 end
		 else begin
		 	if(state == 1) begin
				coord_z <= (cnt_z < cycle) ? 1 : 0;
	 			if(wait_nxt_coord) begin
	 				wait_nxt_coord <= 0;
	 			end else begin
	 				if(i_done) begin
	 					cur_x <=  i_coord_x;
						//pre_x <= ((i_coord_x < pre_x)&&(pre_x-i_coord_x>5))? pre_x-1 :pre_x;
	 					cur_y <= i_coord_y;
	 					get_data <= 1;
						step_clk <= 0;
						aclrt <= 1;
						cnt_x <= 0;
						cnt_y <= 0;
						down <= i_down;
	 					if(i_coord_x == 511 && i_coord_y == 511) begin
	 						state <= 3;
	 					end
	 				end
	 				else if(get_data) begin
						step_clk <= (step_clk+1 == num_cnt) ? 0 : step_clk+1;
	 					if(cur_x == pre_x && cur_y == pre_y) begin
	 						en_step_x <= 0;
	 						en_step_y <= 0;
							if(cnt_z == 0) begin
								if(touch_times == 5) begin
									touch_times <= 0;
									wait_nxt_coord <= 1;
									get_data <= 0;
								end else begin
									touch_times <= touch_times+1;
								end
							end
							
							// if(touch_times < 5) cycle <= UP; 
							// else 
							cycle <= down? DOWN : UP;
							
	 					end else begin
							if(wait_move != 0)begin 
								en_step_x <= 0;
								en_step_y <= 0;
								wait_move <= ((wait_move+1 == 400000)?0:wait_move+1);
								aclrt <= ((wait_move+1 == 400000)?1:0);
								step_clk <= 0;
							end
							else if(step_clk == 0 && up_and_down) begin
								if(aclrt) begin
									if(num_cnt == 1020000) num_cnt <= 1000000;
									else if(num_cnt == 1000000) num_cnt <= 250000;
									else if(num_cnt == 250000) num_cnt <= 110000;
									else if(num_cnt == 110000) num_cnt <= 62400;
									else if(num_cnt == 62400) num_cnt <= 40000;
									else if(num_cnt == 40000) num_cnt <= 28000;
									else if(num_cnt == 28000) num_cnt <= 24000;
									else if(num_cnt == 24000) num_cnt <= 21600;
									else if(num_cnt == 21600) num_cnt <= 20400;
									else if(num_cnt == 20400) begin 
										num_cnt <= 20000;
										aclrt <= 0;
									end
								end
								else if(dclrt && (cnt_x >= 11 || cnt_y >= 11)) begin
									if(num_cnt == 20000) num_cnt <= 20400;
									if(num_cnt == 20400) num_cnt <= 21600;
									else if(num_cnt == 21600) num_cnt <= 24000;
									else if(num_cnt == 24000) num_cnt <= 28000;
									else if(num_cnt == 28000) num_cnt <= 40000;
									else if(num_cnt == 40000) num_cnt <= 62400;
									else if(num_cnt == 62400) num_cnt <= 110000;
									else if(num_cnt == 110000) num_cnt <= 250000;
									else if(num_cnt == 250000) num_cnt <= 1000000;
									else if(num_cnt == 1000000) begin
										num_cnt <= 1020000;
										dclrt <= 0;
									end
								end
								if(cur_x < pre_x) begin
									en_step_x <= 1;
									en_step_y <= 1;
									dir_x <= 1;
									dir_y <= 1;
									if(cnt_x+1 == 21) begin
										pre_x <= pre_x-1;
										if(cur_x == pre_x-1) wait_move <= 1;
										cnt_x <= 0;
									end else begin
										if(cur_x == pre_x-1 && cnt_x == 10) begin
											dclrt <= 1;
											cycle <= UP;
										end
										cnt_x <= cnt_x+1;
									end
								end else if(cur_x > pre_x) begin
									en_step_x <= 1;
									en_step_y <= 1;
									dir_x <= 0;
									dir_y <= 0;
									if(cnt_x+1 == 21) begin
										pre_x <= pre_x+1;
										if(cur_x == pre_x+1) wait_move <= 1;
										cnt_x <= 0;
									end else begin
										if(cur_x == pre_x+1 && cnt_x == 10) begin
											dclrt <= 1;
											cycle <= UP;
										end
										cnt_x <= cnt_x+1;
									end
								end else if(cur_y < pre_y) begin
									en_step_x <= 1;
									en_step_y <= 1;
									dir_x <= 0;
									dir_y <= 1;
									if(cnt_y+1 == 21) begin
										pre_y <= pre_y-1;
										if(cur_y == pre_y-1) wait_move <= 1;
										cnt_y <= 0;
									end else begin
										if(cur_y == pre_y-1 && cnt_y == 10) begin
											dclrt <= 1;
											cycle <= UP;
										end
										cnt_y <= cnt_y +1;
									end
								end else if(cur_y > pre_y) begin
									en_step_x <= 1;
									en_step_y <= 1;
									dir_x <= 1;
									dir_y <= 0;
									if(cnt_y+1 == 21) begin
										pre_y <= pre_y+1;
										if(cur_y == pre_y+1) wait_move <= 1;
										cnt_y <= 0;
									end else begin
										if(cur_y == pre_y+1 && cnt_y == 10) begin
											dclrt <= 1;
											cycle <= UP;
										end
										cnt_y <= cnt_y +1;
									end
								end
							end
		 				end
		 			end
					else begin 
						step_clk <= (step_clk+1 == num_cnt) ? 0 : step_clk+1;
					end
	 			end
			end
		 end
	end
end
endmodule // motor_control