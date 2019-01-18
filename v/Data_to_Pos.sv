module DATA_TO_POS(
// Control signal
input				iCLK,
input				iRST,
input				iDraw,
output			oFinish,
// Flash side
input				iWrite_Done,
output			oDATA_REQUEST,
input		[15:0]	iDATA_FROM_FLASH,
input				iDATA_READY,
input				iFlash_FIN,
output	[19:0] o_addr,
// Other side
input				iPOS_REQUEST,
output	[8:0]	oX,
output	[8:0]	oY,
output			oDone,
output			oDown,

output	[16:0] oTest
);

logic		[8:0] X_cnt, Y_cnt, last_X, last_Y;
logic		[4:0] B_cnt, L_cnt;
logic		[15:0] data_tmp;
logic				pos_ready, pos_sent, pos_waiting, wait_data, even, Down;
logic		[16:0] P_cnt;
logic			i;

// Test
assign oTest = P_cnt;
/*
always_ff @(posedge iCLK or negedge iRST) begin
	if(!iRST) oTest <= 0;
	else oTest <= B_cnt;
end
*/

// Control
always_ff @(posedge iCLK or negedge iRST) begin
	if(!iRST) oFinish <= 0;
	else if (iFlash_FIN) oFinish <= 1;
	else oFinish <= 0;
end

// Flash side
always_ff @(posedge iCLK or negedge iRST) begin
	if(!iRST) begin
		oDATA_REQUEST <= 0;
		X_cnt <= 0;
		Y_cnt <= 0;
		last_X <= 0;
		last_Y <= 0;
		B_cnt <= 16;
		L_cnt <= 0;
		pos_ready <= 0;
		//oTest <= 0;
		wait_data <= 0;
		even <= 0;
		o_addr <= 0;
		Down <= 0;
		P_cnt <= 0;
	end else if(iDATA_READY && wait_data) begin
		//oTest <= 1;
		data_tmp <= iDATA_FROM_FLASH;
		B_cnt <= 0;
		L_cnt <= (L_cnt < 24)? L_cnt + 1 : 1;
		oDATA_REQUEST <= 0;
		// X_cnt <= (X_cnt <= 368)? X_cnt : 0;
		Y_cnt <= (L_cnt < 24)? Y_cnt : Y_cnt + 1;
		last_Y <= Y_cnt;
		even <= (L_cnt < 24)? even : ~even;
		wait_data <= 0;
		
	end else if(iDraw && iWrite_Done && !wait_data) begin
		if (B_cnt == 16) begin
			//oTest <= 2;
			oDATA_REQUEST <= 1;
			o_addr <= (L_cnt < 24)? (even? o_addr-1 : o_addr+1) : o_addr + 24;
			wait_data <= 1;
			B_cnt <= 0;
			X_cnt <= (L_cnt < 24)? X_cnt: (even? X_cnt + 1: X_cnt -1);
			last_X <= X_cnt;
		end else if(!even && !pos_ready && (data_tmp[15]==Down || pos_sent || (X_cnt <= 50 || X_cnt >= 330 || Y_cnt <= 15 || Y_cnt >= 270)) && oDATA_REQUEST == 0) begin
			B_cnt <= B_cnt + 1;
			X_cnt <= X_cnt + 1;
			last_X <= X_cnt;
			data_tmp <= (data_tmp << 1);
			P_cnt <= P_cnt + data_tmp[15];
			pos_ready <= 0;
			oDATA_REQUEST <= 0;
		end else if(even && !pos_ready && (data_tmp[0]==Down || pos_sent || (X_cnt <= 50 || X_cnt >= 330 || Y_cnt <= 15 || Y_cnt >= 270)) && oDATA_REQUEST == 0) begin
			B_cnt <= B_cnt + 1;
			X_cnt <= X_cnt - 1;
			last_X <= X_cnt;
			data_tmp <= (data_tmp >> 1);
			P_cnt <= P_cnt + data_tmp[0];
			pos_ready <= 0;
			oDATA_REQUEST <= 0;
		end else if((iPOS_REQUEST || pos_waiting) && pos_ready) begin
			pos_ready <= 0;
			Down <= ~Down;
		end else if (oDATA_REQUEST == 0) begin
			//oTest <= 4;	
			pos_ready <= 1;
			oDATA_REQUEST <= 0;
		end else oDATA_REQUEST <= 0;
	end else oDATA_REQUEST <= 0;
end

// Other side
always_ff @(posedge iCLK or negedge iRST) begin
	if(!iRST) begin
		oDone <= 0;
		oX <= 0;
		oY <= 0;
		pos_sent <= 0;
		pos_waiting <= 0;
		oDown <= 0;
	end else if(iPOS_REQUEST || pos_waiting) begin
		if (!iDraw || iFlash_FIN) begin // finish
			oX <= 511;
			oY <= 511;
			oDone <= 1;
			oDown <= 0;
			pos_waiting <= 0;
		end else if (!pos_ready) begin
			pos_waiting <= 1;
			oDone <= 0;
			pos_sent <= 0;
		end else begin
			// oX <= Down? X_cnt-50 : last_X-50;
			// oY <= Down? Y_cnt-15 : last_Y-15;
			// oX <= X_cnt-50;
			// oY <= Y_cnt-15;
			oX <= Down?(even? X_cnt-49 : X_cnt-51): X_cnt-50;
			oY <= Y_cnt-15;
			oDone <= 1;
			oDown <= ~Down;
			pos_waiting <= 0;
			pos_sent <= 1;
		end
	end else begin 
		oDone <= 0;
		pos_sent <= 0;
	end
end

endmodule
