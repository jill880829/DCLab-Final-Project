module SevenHexDecoder(
	input [11:0] i_coord,
	output logic [6:0] o_seven_3,
	output logic [6:0] o_seven_2,
	output logic [6:0] o_seven_1
	
);
	/* The layout of seven segment display, 1: dark
	 *    00
	 *   5  1
	 *    66
	 *   4  2
	 *    33
	 */
	parameter D0 = 7'b1000000;
	parameter D1 = 7'b1111001;
	parameter D2 = 7'b0100100;
	parameter D3 = 7'b0110000;
	parameter D4 = 7'b0011001;
	parameter D5 = 7'b0010010;
	parameter D6 = 7'b0000010;
	parameter D7 = 7'b1011000;
	parameter D8 = 7'b0000000;
	parameter D9 = 7'b0010000;
	parameter DA = 7'b0001000;
	parameter DB = 7'b0000011;
	parameter DC = 7'b1000110;
	parameter DD = 7'b0100001;
	parameter DE = 7'b0000110;
	parameter DF = 7'b0001110;

	always_comb begin
		case(i_coord[3:0])
			4'h0: begin o_seven_1 = D0; end
			4'h1: begin o_seven_1 = D1; end
			4'h2: begin o_seven_1 = D2; end
			4'h3: begin o_seven_1 = D3; end
			4'h4: begin o_seven_1 = D4; end
			4'h5: begin o_seven_1 = D5; end
			4'h6: begin o_seven_1 = D6; end
			4'h7: begin o_seven_1 = D7; end
			4'h8: begin o_seven_1 = D8; end
			4'h9: begin o_seven_1 = D9; end
			4'ha: begin o_seven_1 = DA; end
			4'hb: begin o_seven_1 = DB; end
			4'hc: begin o_seven_1 = DC; end
			4'hd: begin o_seven_1 = DD; end
			4'he: begin o_seven_1 = DE; end
			4'hf: begin o_seven_1 = DF; end
		endcase

		case(i_coord[7:4])
			4'h0: begin o_seven_2 = D0; end
			4'h1: begin o_seven_2 = D1; end
			4'h2: begin o_seven_2 = D2; end
			4'h3: begin o_seven_2 = D3; end
			4'h4: begin o_seven_2 = D4; end
			4'h5: begin o_seven_2 = D5; end
			4'h6: begin o_seven_2 = D6; end
			4'h7: begin o_seven_2 = D7; end
			4'h8: begin o_seven_2 = D8; end
			4'h9: begin o_seven_2 = D9; end
			4'ha: begin o_seven_2 = DA; end
			4'hb: begin o_seven_2 = DB; end
			4'hc: begin o_seven_2 = DC; end
			4'hd: begin o_seven_2 = DD; end
			4'he: begin o_seven_2 = DE; end
			4'hf: begin o_seven_2 = DF; end
		endcase
		
		case(i_coord[11:8])
			4'h0: begin o_seven_3 = D0; end
			4'h1: begin o_seven_3 = D1; end
			4'h2: begin o_seven_3 = D2; end
			4'h3: begin o_seven_3 = D3; end
			4'h4: begin o_seven_3 = D4; end
			4'h5: begin o_seven_3 = D5; end
			4'h6: begin o_seven_3 = D6; end
			4'h7: begin o_seven_3 = D7; end
			4'h8: begin o_seven_3 = D8; end
			4'h9: begin o_seven_3 = D9; end
			4'ha: begin o_seven_3 = DA; end
			4'hb: begin o_seven_3 = DB; end
			4'hc: begin o_seven_3 = DC; end
			4'hd: begin o_seven_3 = DD; end
			4'he: begin o_seven_3 = DE; end
			4'hf: begin o_seven_3 = DF; end
		endcase
		
	end
endmodule
