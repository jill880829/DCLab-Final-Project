module STATE_Controller(
input			iCLK,
input			iRST,
input			iSwitch,
input			iButton,
input			iFinish,
output		oDraw
);

	always_ff @(posedge iCLK or negedge iRST) begin
		if(!iRST) oDraw <= 0;
		else if(iFinish) oDraw <= 0;
		else if(iSwitch && !iButton) oDraw <= 1;
	end

endmodule
					