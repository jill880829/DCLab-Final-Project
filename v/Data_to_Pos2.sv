module DATA_TO_POS2(
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
// Other side
input				iPOS_REQUEST,
output	[8:0]	oX,
output	[8:0]	oY,
output			oDone,
output			oDown,

output	[14:0] oTest
);

logic		[8:0] X_cnt, Y_cnt;
logic		[4:0] B_cnt;
logic		[15:0] data_tmp;
logic				pos_ready, pos_sent, pos_waiting;
logic		[14:0] CNT;
logic				last, head, tail;

// Test
assign oTest = CNT;
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
		B_cnt <= 16;
		pos_ready <= 0;
		last <= 0;
		head <= 0;
		tail <= 0;
		//oTest <= 0;
		CNT <= 0;
	end else if(iDATA_READY) begin
		//oTest <= 1;
		data_tmp <= iDATA_FROM_FLASH;
		B_cnt <= 0;
		oDATA_REQUEST <= 0;
		X_cnt <= (X_cnt < 400)? X_cnt : 0;
		Y_cnt <= (X_cnt < 400)? Y_cnt : Y_cnt + 1;
		last <= (X_cnt < 400)? last : 0;
		
	end else if(iDraw && iWrite_Done) begin
		if (B_cnt == 16) begin
			CNT <= CNT + 1;
			//oTest <= 2;
			oDATA_REQUEST <= 1;
			B_cnt <= 0;
		end else if(oDATA_REQUEST == 0 && X_cnt == 0 && Y_cnt != 0) begin
			pos_ready <= 1;
			head <= 1;
		end else if(oDATA_REQUEST == 0 && (X_cnt == 395 || X_cnt == 399)) begin
			pos_ready <= 1;
			tail <= 1;
		end else if((data_tmp[15]==last || pos_sent || (X_cnt <= 5 || X_cnt >= 395 || Y_cnt <= 5 || Y_cnt >= 295)) && oDATA_REQUEST == 0) begin
			//oTest <= 3;
			B_cnt <= B_cnt + 1;
			X_cnt <= X_cnt + 1;
			data_tmp <= (data_tmp << 1);
			pos_ready <= 0;
			oDATA_REQUEST <= 0;
			head <= 0;
			tail <= 0;
			if (X_cnt > 5 && X_cnt < 395 && Y_cnt > 5 && Y_cnt < 295) last <= data_tmp[15];
		end else if (oDATA_REQUEST == 0) begin
			//oTest <= 4;
			pos_ready <= 1;
			oDATA_REQUEST <= 0;
		end else oDATA_REQUEST <= 0;
	end //else oTest <= 5;
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
			pos_waiting <= 0;
		end else if (!pos_ready) begin
			pos_waiting <= 1;
			oDone <= 0;
			pos_sent <= 0;
		end else begin
			oY <= Y_cnt;
			oDone <= 1;
			pos_waiting <= 0;
			pos_sent <= 1;
			if (head) begin
				oDown <= 0;
				oX <= 0;
			end else if (tail) begin
				oDown <= 0;
				oX <= (X_cnt == 395)? X_cnt+25 : 449;
			end else begin
				oDown <= data_tmp[15];
				oX <= X_cnt+25;
			end
		end
	end else begin 
		oDone <= 0;
		pos_sent <= 0;
	end
end

endmodule
