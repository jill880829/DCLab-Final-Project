module LCD_wrapper(
	output [7:0] CHARACTER,
	output [7:0] ADDRESS,

	output START,
	output CLEAR,
	input BUSY,

	input i_clk,
	input i_rst,
	input button2,
	input i_draw,
	input [8:0] x,
	input [8:0] y,
	input [16:0] ROW_LENGTH,
	input [16:0] row,
	output [4:0] test 
);

enum{
	INITIAL,
	PRE_DRAW,
	DRAWING,
	FINISHED
}states;


logic [4:0] state;

logic [63:0] clock_counter;
logic [63:0] last_clock;

logic [7:0] address;
logic [8:0] x_r, y_r;

assign test = state;




always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state <= INITIAL;
		address <= 8'b0;
		clock_counter <= 64'b0;
		last_clock <= 64'b0;
	end
	else begin
		clock_counter <= clock_counter + 1;
		if (state == INITIAL) begin
			if(button2 == 0) begin
				state <= PRE_DRAW;
				address <= 8'h0;
			end
			if (clock_counter > last_clock + 10) begin
				last_clock <= clock_counter;
				case (address)
					8'h00 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h00;
									CHARACTER <= 8'h50; // P
									address <= 8'h01;
								end
								else begin
									START <= 0;
								end
							end
					8'h01 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h01;
									CHARACTER <= 8'h72; // r
									address <= 8'h02;
								end
								else begin
									START <= 0;
								end
							end
					8'h02 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h02;
									CHARACTER <= 8'h65; // e
									address <= 8'h03;
								end
								else begin
									START <= 0;
								end
							end
					8'h03 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h03;
									CHARACTER <= 8'h73; // s
									address <= 8'h04;
								end
								else begin
									START <= 0;
								end
							end
					8'h04 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h04;
									CHARACTER <= 8'h73; // s
									address <= 8'h05;
								end
								else begin
									START <= 0;
								end
							end
					8'h05 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h05;
									CHARACTER <= 8'h20; // _
									address <= 8'h06;
								end
								else begin
									START <= 0;
								end
							end				
					8'h06 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h06;
									CHARACTER <= 8'h4B; // K
									address <= 8'h07;
								end
								else begin
									START <= 0;
								end
							end
					8'h07 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h07;
									CHARACTER <= 8'h45; // E
									address <= 8'h08;
								end
								else begin
									START <= 0;
								end
							end
					8'h08 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h08;
									CHARACTER <= 8'h59; // Y
									address <= 8'h09;
								end
								else begin
									START <= 0;
								end
							end
					8'h09 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h09;
									CHARACTER <= 8'h32; // 2
									address <= 8'h0A;
								end
								else begin
									START <= 0;
								end
							end
					8'h0A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0A;
									CHARACTER <= 8'h20; // -
									address <= 8'h0B;
								end
								else begin
									START <= 0;
								end
							end
					8'h0B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0B;
									CHARACTER <= 8'h20; // -
									address <= 8'h0C;
								end
								else begin
									START <= 0;
								end
							end
					8'h0C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0C;
									CHARACTER <= 8'h20; // _
									address <= 8'h0D;
								end
								else begin
									START <= 0;
								end
							end
					8'h0D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0D;
									CHARACTER <= 8'h20; // _
									address <= 8'h0E;
								end
								else begin
									START <= 0;
								end
							end
					8'h0E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0E;
									CHARACTER <= 8'h20; // _
									address <= 8'h0F;
								end
								else begin
									START <= 0;
								end
							end
					8'h0F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0F;
									CHARACTER <= 8'h20; // _
									address <= 8'h40;
								end
								else begin
									START <= 0;
								end
							end
					8'h40 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h40;
									CHARACTER <= 8'h20; // _
									address <= 8'h41;
								end
								else begin
									START <= 0;
								end
							end
					8'h41 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h41;
									CHARACTER <= 8'h20; // _
									address <= 8'h42;
								end
								else begin
									START <= 0;
								end
							end
					8'h42 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h42;
									CHARACTER <= 8'h20; // _
									address <= 8'h43;
								end
								else begin
									START <= 0;
								end
							end
					8'h43 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h43;
									CHARACTER <= 8'h20; // _
									address <= 8'h44;
								end
								else begin
									START <= 0;
								end
							end
					8'h44 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h44;
									CHARACTER <= 8'h20; // _
									address <= 8'h45;
								end
								else begin
									START <= 0;
								end
							end
					8'h45 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h45;
									CHARACTER <= 8'h20; // _
									address <= 8'h47;
								end
								else begin
									START <= 0;
								end
							end				
					8'h47 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h47;
									CHARACTER <= 8'h20; // _
									address <= 8'h48;
								end
								else begin
									START <= 0;
								end
							end
					8'h48 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h48;
									CHARACTER <= 8'h20; // _
									address <= 8'h49;
								end
								else begin
									START <= 0;
								end
							end
					8'h49 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h49;
									CHARACTER <= 8'h20; // _
									address <= 8'h4A;
								end
								else begin
									START <= 0;
								end
							end
					8'h4A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4A;
									CHARACTER <= 8'h20; // _
									address <= 8'h4B;
								end
								else begin
									START <= 0;
								end
							end
					8'h4B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4B;
									CHARACTER <= 8'h20; // _
									address <= 8'h4C;
								end
								else begin
									START <= 0;
								end
							end
					8'h4C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4C;
									CHARACTER <= 8'h20; // _
									address <= 8'h4D;
								end
								else begin
									START <= 0;
								end
							end
					8'h4D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4D;
									CHARACTER <= 8'h20; // _
									address <= 8'h4E;
								end
								else begin
									START <= 0;
								end
							end
					8'h4E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4E;
									CHARACTER <= 8'h20; // _
									address <= 8'h4F;
								end
								else begin
									START <= 0;
								end
							end
					8'h4F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4F;
									CHARACTER <= 8'h20; // _
									address <= 8'h00;
								end
								else begin
									START <= 0;
								end
							end
					default : state <= INITIAL;
				endcase
			end
		end else if (state == PRE_DRAW) begin
			if(i_draw == 1) begin
				state <= DRAWING;
				address <= 8'h00;
			end
			if (clock_counter > last_clock + 10) begin
				last_clock <= clock_counter;
				case (address)
					8'h00 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h00;
									CHARACTER <= 8'h54; // T
									address <= 8'h01;
								end
								else begin
									START <= 0;
								end
							end
					8'h01 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h01;
									CHARACTER <= 8'h75; // u
									address <= 8'h02;
								end
								else begin
									START <= 0;
								end
							end
					8'h02 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h02;
									CHARACTER <= 8'h72; // r
									address <= 8'h03;
								end
								else begin
									START <= 0;
								end
							end
					8'h03 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h03;
									CHARACTER <= 8'h6E; // n
									address <= 8'h04;
								end
								else begin
									START <= 0;
								end
							end
					8'h04 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h04;
									CHARACTER <= 8'h20; // -
									address <= 8'h05;
								end
								else begin
									START <= 0;
								end
							end
					8'h05 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h05;
									CHARACTER <= 8'h6F; // o
									address <= 8'h06;
								end
								else begin
									START <= 0;
								end
							end				
					8'h06 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h06;
									CHARACTER <= 8'h6E; // n
									address <= 8'h07;
								end
								else begin
									START <= 0;
								end
							end
					8'h07 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h07;
									CHARACTER <= 8'h20; // -
									address <= 8'h08;
								end
								else begin
									START <= 0;
								end
							end
					8'h08 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h08;
									CHARACTER <= 8'h53; // S
									address <= 8'h09;
								end
								else begin
									START <= 0;
								end
							end
					8'h09 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h09;
									CHARACTER <= 8'h57; // W
									address <= 8'h0A;
								end
								else begin
									START <= 0;
								end
							end
					8'h0A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0A;
									CHARACTER <= 8'h31; // 1
									address <= 8'h0B;
								end
								else begin
									START <= 0;
								end
							end
					8'h0B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0B;
									CHARACTER <= 8'h35; // 5
									address <= 8'h0C;
								end
								else begin
									START <= 0;
								end
							end
					8'h0C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0C;
									CHARACTER <= 8'h20; // _
									address <= 8'h0D;
								end
								else begin
									START <= 0;
								end
							end
					8'h0D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0D;
									CHARACTER <= 8'h61; // a
									address <= 8'h0E;
								end
								else begin
									START <= 0;
								end
							end
					8'h0E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0E;
									CHARACTER <= 8'h6E; // n
									address <= 8'h0F;
								end
								else begin
									START <= 0;
								end
							end
					8'h0F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0F;
									CHARACTER <= 8'h64; // d
									address <= 8'h40;
								end
								else begin
									START <= 0;
								end
							end
					8'h40 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h40;
									CHARACTER <= 8'h50; // p
									address <= 8'h41;
								end
								else begin
									START <= 0;
								end
							end
					8'h41 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h41;
									CHARACTER <= 8'h72; // r
									address <= 8'h42;
								end
								else begin
									START <= 0;
								end
							end
					8'h42 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h42;
									CHARACTER <= 8'h65; // e
									address <= 8'h43;
								end
								else begin
									START <= 0;
								end
							end
					8'h43 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h43;
									CHARACTER <= 8'h73; // s
									address <= 8'h44;
								end
								else begin
									START <= 0;
								end
							end
					8'h44 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h44;
									CHARACTER <= 8'h73; // s
									address <= 8'h45;
								end
								else begin
									START <= 0;
								end
							end
					8'h45 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h45;
									CHARACTER <= 8'h20; // _
									address <= 8'h46;
								end
								else begin
									START <= 0;
								end
							end		
					8'h46 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h46;
									CHARACTER <= 8'h4B; // K
									address <= 8'h47;
								end
								else begin
									START <= 0;
								end
							end				
					8'h47 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h47;
									CHARACTER <= 8'h45; // E
									address <= 8'h48;
								end
								else begin
									START <= 0;
								end
							end
					8'h48 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h48;
									CHARACTER <= 8'h59; // Y
									address <= 8'h49;
								end
								else begin
									START <= 0;
								end
							end
					8'h49 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h49;
									CHARACTER <= 8'h31; // 1
									address <= 8'h4A;
								end
								else begin
									START <= 0;
								end
							end
					8'h4A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4A;
									CHARACTER <= 8'h20; // _
									address <= 8'h4B;
								end
								else begin
									START <= 0;
								end
							end
					8'h4B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4B;
									CHARACTER <= 8'h20; // _
									address <= 8'h4C;
								end
								else begin
									START <= 0;
								end
							end
					8'h4C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4C;
									CHARACTER <= 8'h20; // _
									address <= 8'h4D;
								end
								else begin
									START <= 0;
								end
							end
					8'h4D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4D;
									CHARACTER <= 8'h20; // _
									address <= 8'h4E;
								end
								else begin
									START <= 0;
								end
							end
					8'h4E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4E;
									CHARACTER <= 8'h20; // _
									address <= 8'h4F;
								end
								else begin
									START <= 0;
								end
							end
					8'h4F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4F;
									CHARACTER <= 8'h20; // _
									address <= 8'h00;
								end
								else begin
									START <= 0;
								end
							end
					default : state <= INITIAL;
				endcase
			end
		end else if (state == DRAWING) begin
			if(x==511 && y==511) begin
				state <= FINISHED;
				address <= 8'h00;
			end
			if (clock_counter > last_clock + 10) begin
				last_clock <= clock_counter;
				case (address)
					8'h00 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h00;
									CHARACTER <= 8'h58; // X
									address <= 8'h01;
								end
								else begin
									START <= 0;
								end
							end
					8'h01 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h01;
									CHARACTER <= 8'h3A; // :
									address <= 8'h02;
									x_r <= x;
									y_r <= y;
								end
								else begin
									START <= 0;
								end
							end
					8'h02 : begin                          //x hundredth 
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h02;
									if(x >= 300) begin
										CHARACTER <= 8'h33; // 3
										x_r <= x_r - 300;
									end else if (x >= 200) begin
										CHARACTER <= 8'h32; //2
										x_r <= x_r - 200;
									end else if (x >= 100) begin
										CHARACTER <= 8'h31; //1
										x_r <= x_r - 100;
									end else begin
										CHARACTER <= 8'h20; //-
									end
									address <= 8'h03;
								end
								else begin
									START <= 0;
								end
							end
					8'h03 : begin                          //x tenth 
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h03;
									if(x_r >= 90) begin
										CHARACTER <= 8'h39; // 9
										x_r <= x_r - 90;
									end else if(x_r >= 80) begin
										CHARACTER <= 8'h38; // 8
										x_r <= x_r - 80;
									end else if (x_r >= 70) begin
										CHARACTER <= 8'h37; //7
										x_r <= x_r - 70;
									end else if (x_r >= 60) begin
										CHARACTER <= 8'h36; //6
										x_r <= x_r - 60;
									end else if (x_r >= 50) begin 
										CHARACTER <= 8'h35; //5
										x_r <= x_r - 50;
									end else if(x_r >= 40) begin
										CHARACTER <= 8'h34; // 4
										x_r <= x_r - 40;
									end else if(x_r >= 30) begin
										CHARACTER <= 8'h33; // 3
										x_r <= x_r - 30;
									end else if (x_r >= 20) begin
										CHARACTER <= 8'h32; //2
										x_r <= x_r - 20;
									end else if (x_r >= 10) begin
										CHARACTER <= 8'h31; //1
										x_r <= x_r - 10;
									end else begin
										CHARACTER <= 8'h30; //0
									end
									address <= 8'h04;
								end
								else begin
									START <= 0;
								end
							end
					8'h04 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h04;
									if(x_r == 9) begin
										CHARACTER <= 8'h39; // 9
									end else if(x_r == 8) begin
										CHARACTER <= 8'h38; // 8
									end else if (x_r == 7) begin
										CHARACTER <= 8'h37; //7
									end else if (x_r == 6) begin
										CHARACTER <= 8'h36; //6
									end else if (x_r == 5) begin 
										CHARACTER <= 8'h35; //5
									end else if(x_r == 4) begin
										CHARACTER <= 8'h34; // 4
									end else if(x_r == 3) begin
										CHARACTER <= 8'h33; // 3
									end else if (x_r == 2) begin
										CHARACTER <= 8'h32; //2
									end else if (x_r == 1) begin
										CHARACTER <= 8'h31; //1
									end else begin
										CHARACTER <= 8'h30; //0
									end
									address <= 8'h05;
								end
								else begin
									START <= 0;
								end
							end
					8'h05 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h05;
									CHARACTER <= 8'h20; // -
									address <= 8'h06;
								end
								else begin
									START <= 0;
								end
							end				
					8'h06 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h06;
									CHARACTER <= 8'h20; // -
									address <= 8'h07;
								end
								else begin
									START <= 0;
								end
							end
					8'h07 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h07;
									CHARACTER <= 8'h20; // -
									address <= 8'h08;
								end
								else begin
									START <= 0;
								end
							end
					8'h08 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h08;
									CHARACTER <= 8'h20; // -
									address <= 8'h09;
								end
								else begin
									START <= 0;
								end
							end
					8'h09 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h09;
									CHARACTER <= 8'h44; // D
									address <= 8'h0A;
								end
								else begin
									START <= 0;
								end
							end
					8'h0A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0A;
									CHARACTER <= 8'h72; // r
									address <= 8'h0B;
								end
								else begin
									START <= 0;
								end
							end
					8'h0B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0B;
									CHARACTER <= 8'h61; // a
									address <= 8'h0C;
								end
								else begin
									START <= 0;
								end
							end
					8'h0C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0C;
									CHARACTER <= 8'h77; // w
									address <= 8'h0D;
								end
								else begin
									START <= 0;
								end
							end
					8'h0D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0D;
									CHARACTER <= 8'h69; // i
									address <= 8'h0E;
								end
								else begin
									START <= 0;
								end
							end
					8'h0E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0E;
									CHARACTER <= 8'h6E; // n
									address <= 8'h0F;
								end
								else begin
									START <= 0;
								end
							end
					8'h0F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0F;
									CHARACTER <= 8'h67; // g
									address <= 8'h40;
								end
								else begin
									START <= 0;
								end
							end
					8'h40 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h40;
									CHARACTER <= 8'h59; // Y
									address <= 8'h41;
								end
								else begin
									START <= 0;
								end
							end
					8'h41 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h41;
									CHARACTER <= 8'h3A; // :
									address <= 8'h42;
									x_r <= x;
									y_r <= y;
								end
								else begin
									START <= 0;
								end
							end
					8'h42 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h42;
									if(y >= 300) begin
										CHARACTER <= 8'h33; // 3
										y_r <= y_r - 300;
									end else if (y >= 200) begin
										CHARACTER <= 8'h32; //2
										y_r <= y_r - 200;
									end else if (y >= 100) begin
										CHARACTER <= 8'h31; //1
										y_r <= y_r - 100;
									end else begin
										CHARACTER <= 8'h20; //-
									end
									address <= 8'h43;
								end
								else begin
									START <= 0;
								end
							end
					8'h43 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h43;
									if(y_r >= 90) begin
										CHARACTER <= 8'h39; // 9
										y_r <= y_r - 90;
									end else if(y_r >= 80) begin
										CHARACTER <= 8'h38; // 8
										y_r <= y_r - 80;
									end else if (y_r >= 70) begin
										CHARACTER <= 8'h37; //7
										y_r <= y_r - 70;
									end else if (y_r >= 60) begin
										CHARACTER <= 8'h36; //6
										y_r <= y_r - 60;
									end else if (y_r >= 50) begin 
										CHARACTER <= 8'h35; //5
										y_r <= y_r - 50;
									end else if(y_r >= 40) begin
										CHARACTER <= 8'h34; // 4
										y_r <= y_r - 40;
									end else if(y_r >= 30) begin
										CHARACTER <= 8'h33; // 3
										y_r <= y_r - 30;
									end else if (y_r >= 20) begin
										CHARACTER <= 8'h32; //2
										y_r <= y_r - 20;
									end else if (y_r >= 10) begin
										CHARACTER <= 8'h31; //1
										y_r <= y_r - 10;
									end else begin
										CHARACTER <= 8'h30; //0
									end
									address <= 8'h44;
								end
								else begin
									START <= 0;
								end
							end
					8'h44 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h44;
									if(y_r == 9) begin
										CHARACTER <= 8'h39; // 9
									end else if(y_r == 8) begin
										CHARACTER <= 8'h38; // 8
									end else if (y_r == 7) begin
										CHARACTER <= 8'h37; //7
									end else if (y_r == 6) begin
										CHARACTER <= 8'h36; //6
									end else if (y_r == 5) begin 
										CHARACTER <= 8'h35; //5
									end else if(y_r == 4) begin
										CHARACTER <= 8'h34; // 4
									end else if(y_r == 3) begin
										CHARACTER <= 8'h33; // 3
									end else if (y_r == 2) begin
										CHARACTER <= 8'h32; //2
									end else if (y_r == 1) begin
										CHARACTER <= 8'h31; //1
									end else begin
										CHARACTER <= 8'h30; //0
									end
									address <= 8'h45;
								end
								else begin
									START <= 0;
								end
							end
					8'h45 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h45;
									CHARACTER <= 8'h20; // _
									address <= 8'h46;
								end
								else begin
									START <= 0;
								end
							end		
					8'h46 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h46;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 1)?8'hFF:8'h20; // cube
									address <= 8'h47;
								end
								else begin
									START <= 0;
								end
							end				
					8'h47 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h47;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 2)?8'hFF:8'h20; // cube
									address <= 8'h48;
								end
								else begin
									START <= 0;
								end
							end
					8'h48 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h48;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 3)?8'hFF:8'h20; // cube
									address <= 8'h49;
								end
								else begin
									START <= 0;
								end
							end
					8'h49 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h49;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 4)?8'hFF:8'h20; // cube
									address <= 8'h4A;
								end
								else begin
									START <= 0;
								end
							end
					8'h4A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4A;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 5)?8'hFF:8'h20; // cube
									address <= 8'h4B;
								end
								else begin
									START <= 0;
								end
							end
					8'h4B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4B;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 6)?8'hFF:8'h20; // cube
									address <= 8'h4C;
								end
								else begin
									START <= 0;
								end
							end
					8'h4C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4C;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 7)?8'hFF:8'h20; // cube
									address <= 8'h4D;
								end
								else begin
									START <= 0;
								end
							end
					8'h4D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4D;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 8)?8'hFF:8'h20; // cube
									address <= 8'h4E;
								end
								else begin
									START <= 0;
								end
							end
					8'h4E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4E;
									CHARACTER <= (row >= ROW_LENGTH / 10 * 9)?8'hFF:8'h20; // cube
									address <= 8'h4F;
								end
								else begin
									START <= 0;
								end
							end
					8'h4F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4F;
									CHARACTER <= (row >= ROW_LENGTH)?8'hFF:8'h20; // cube
									address <= 8'h00;
								end
								else begin
									START <= 0;
								end
							end
					default : state <= INITIAL;
				endcase
			end
		end  else if (state == FINISHED) begin
			if (clock_counter > last_clock + 10) begin
				last_clock <= clock_counter;
				case (address)
					8'h00 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h00;
									CHARACTER <= 8'h44; // D
									address <= 8'h01;
								end
								else begin
									START <= 0;
								end
							end
					8'h01 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h01;
									CHARACTER <= 8'h6F; // o
									address <= 8'h02;
								end
								else begin
									START <= 0;
								end
							end
					8'h02 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h02;
									CHARACTER <= 8'h6E; // n
									address <= 8'h03;
								end
								else begin
									START <= 0;
								end
							end
					8'h03 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h03;
									CHARACTER <= 8'h65; // e
									address <= 8'h04;
								end
								else begin
									START <= 0;
								end
							end
					8'h04 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h04;
									CHARACTER <= 8'h20; // -
									address <= 8'h05;
								end
								else begin
									START <= 0;
								end
							end
					8'h05 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h05;
									CHARACTER <= 8'h20; // -
									address <= 8'h06;
								end
								else begin
									START <= 0;
								end
							end				
					8'h06 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h06;
									CHARACTER <= 8'h20; // -
									address <= 8'h07;
								end
								else begin
									START <= 0;
								end
							end
					8'h07 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h07;
									CHARACTER <= 8'h20; // -
									address <= 8'h08;
								end
								else begin
									START <= 0;
								end
							end
					8'h08 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h08;
									CHARACTER <= 8'h20; // -
									address <= 8'h09;
								end
								else begin
									START <= 0;
								end
							end
					8'h09 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h09;
									CHARACTER <= 8'h20; // -
									address <= 8'h0A;
								end
								else begin
									START <= 0;
								end
							end
					8'h0A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0A;
									CHARACTER <= 8'h20; // -
									address <= 8'h0B;
								end
								else begin
									START <= 0;
								end
							end
					8'h0B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0B;
									CHARACTER <= 8'h20; // -
									address <= 8'h0C;
								end
								else begin
									START <= 0;
								end
							end
					8'h0C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0C;
									CHARACTER <= 8'h20; // _
									address <= 8'h0D;
								end
								else begin
									START <= 0;
								end
							end
					8'h0D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0D;
									CHARACTER <= 8'h20; // -
									address <= 8'h0E;
								end
								else begin
									START <= 0;
								end
							end
					8'h0E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0E;
									CHARACTER <= 8'h20; // -
									address <= 8'h0F;
								end
								else begin
									START <= 0;
								end
							end
					8'h0F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h0F;
									CHARACTER <= 8'h20; // -
									address <= 8'h40;
								end
								else begin
									START <= 0;
								end
							end
					8'h40 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h40;
									CHARACTER <= 8'h50; // p
									address <= 8'h41;
								end
								else begin
									START <= 0;
								end
							end
					8'h41 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h41;
									CHARACTER <= 8'h72; // r
									address <= 8'h42;
								end
								else begin
									START <= 0;
								end
							end
					8'h42 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h42;
									CHARACTER <= 8'h65; // e
									address <= 8'h43;
								end
								else begin
									START <= 0;
								end
							end
					8'h43 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h43;
									CHARACTER <= 8'h73; // s
									address <= 8'h44;
								end
								else begin
									START <= 0;
								end
							end
					8'h44 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h44;
									CHARACTER <= 8'h73; // s
									address <= 8'h45;
								end
								else begin
									START <= 0;
								end
							end
					8'h45 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h45;
									CHARACTER <= 8'h20; // _
									address <= 8'h46;
								end
								else begin
									START <= 0;
								end
							end		
					8'h46 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h46;
									CHARACTER <= 8'h4B; // K
									address <= 8'h47;
								end
								else begin
									START <= 0;
								end
							end				
					8'h47 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h47;
									CHARACTER <= 8'h45; // E
									address <= 8'h48;
								end
								else begin
									START <= 0;
								end
							end
					8'h48 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h48;
									CHARACTER <= 8'h59; // Y
									address <= 8'h49;
								end
								else begin
									START <= 0;
								end
							end
					8'h49 : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h49;
									CHARACTER <= 8'h30; // 1
									address <= 8'h4A;
								end
								else begin
									START <= 0;
								end
							end
					8'h4A : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4A;
									CHARACTER <= 8'h20; // _
									address <= 8'h4B;
								end
								else begin
									START <= 0;
								end
							end
					8'h4B : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4B;
									CHARACTER <= 8'h20; // _
									address <= 8'h4C;
								end
								else begin
									START <= 0;
								end
							end
					8'h4C : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4C;
									CHARACTER <= 8'h20; // _
									address <= 8'h4D;
								end
								else begin
									START <= 0;
								end
							end
					8'h4D : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4D;
									CHARACTER <= 8'h20; // _
									address <= 8'h4E;
								end
								else begin
									START <= 0;
								end
							end
					8'h4E : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4E;
									CHARACTER <= 8'h20; // _
									address <= 8'h4F;
								end
								else begin
									START <= 0;
								end
							end
					8'h4F : begin
								if (!BUSY) begin
									START <= 1;
									ADDRESS <= 8'h4F;
									CHARACTER <= 8'h20; // _
									address <= 8'h00;
								end
								else begin
									START <= 0;
								end
							end
					default : state <= INITIAL;
				endcase
			end
		end 
	end
end

endmodule