// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	VGA_Controller
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN Peli Li:| 22/07/2010:| Initial Revision
// --------------------------------------------------------------------

module	VGA_Controller(	
						//	Host Side
						iRed,
						iGreen,
						iBlue,
						oRequest,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_H_SYNC,
						oVGA_V_SYNC,
						oVGA_SYNC,
						oVGA_BLANK,

						//	Control Signal
						iCLK,
						iRST_N,
						iZOOM_MODE_SW,
						// Connect to Flash
						oDATA_TO_FLASH,
						oSTART_WRITE,
						oDATA_COUNT,
						pixel_counter,
						
						// User Control
						iDraw,
						i_key_up,
						i_key_down,
						i_sobel,
						// Test
						o_vga_test
							);
`include "VGA_Param.h"

`ifdef VGA_640x480p60
//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	48;
parameter	H_SYNC_ACT	=	640;	
parameter	H_SYNC_FRONT=	16;
parameter	H_SYNC_TOTAL=	800;

//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	33;
parameter	V_SYNC_ACT	=	480;	
parameter	V_SYNC_FRONT=	10;
parameter	V_SYNC_TOTAL=	525; 

`else
 // SVGA_800x600p60
////	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	128;         //Peli
parameter	H_SYNC_BACK	=	88;
parameter	H_SYNC_ACT	=	800;	
parameter	H_SYNC_FRONT=	40;
parameter	H_SYNC_TOTAL=	1056;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	4;
parameter	V_SYNC_BACK	=	23;
parameter	V_SYNC_ACT	=	600;	
parameter	V_SYNC_FRONT=	1;
parameter	V_SYNC_TOTAL=	628;

`endif
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;
//	Host Side
input		[9:0]	iRed;
input		[9:0]	iGreen;
input		[9:0]	iBlue;
output	reg			oRequest;
//	VGA Side
output	reg	[9:0]	oVGA_R;
output	reg	[9:0]	oVGA_G;
output	reg	[9:0]	oVGA_B;
output	reg			oVGA_H_SYNC;
output	reg			oVGA_V_SYNC;
output	reg			oVGA_SYNC;
output	reg			oVGA_BLANK;

wire		[9:0]	mVGA_R;
wire		[9:0]	mVGA_G;
wire		[9:0]	mVGA_B;
reg				mVGA_H_SYNC;
reg				mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;

//	Control Signal
input				iCLK;
input				iRST_N;
input 			iZOOM_MODE_SW;

// Connect to Flash
output	reg	[15:0]		oDATA_TO_FLASH;
output	reg				oSTART_WRITE;
output	reg	[12:0] 	oDATA_COUNT;
						
// User Control
input							iDraw;
input							i_key_down;
input							i_key_up;
reg				[9:0]		std;
input							i_sobel;

// Test
output	reg	[11:0]	o_vga_test;

//	Internal Registers and Wires
reg		[12:0]		H_Cont;
reg		[12:0]		V_Cont;

wire	[12:0]		v_mask;

assign v_mask = 13'd0 ;//iZOOM_MODE_SW ? 13'd0 : 13'd26;

// Image Processing
reg 		[11:0]			Line_1 [0:H_SYNC_ACT];
reg 		[11:0]			Line_2 [0:H_SYNC_ACT];
reg 		[11:0]			Line_3 [0:H_SYNC_ACT];
reg 		[9:0]			Result;
integer 					i;
reg						Line_sobel1 [0:H_SYNC_ACT];
reg						Line_sobel2 [0:H_SYNC_ACT];
reg						Line_sobel3 [0:H_SYNC_ACT];
reg		[9:0]			Last_Pixel;
reg		[15:0]			Ave;
reg		[4:0]			P_Cont;
reg						draw;
output	reg	[16:0]	pixel_counter;

////////////////////////////////////////////////////////

assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;

assign	mVGA_R	=	((H_Cont == X_START+100 || H_Cont == X_START+660 || V_Cont == Y_START+v_mask+50 || V_Cont == Y_START+v_mask+520)&&(H_Cont>=X_START+100 	&& H_Cont<=X_START+660 &&
						V_Cont>=Y_START+v_mask+50 	&& V_Cont<=Y_START+v_mask+520)) ? 1023 :((	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						? (i_sobel? Result : iRed)	:	0);
						
assign	mVGA_G	=	((H_Cont == X_START+100 || H_Cont == X_START+660 || V_Cont == Y_START+v_mask+50 || V_Cont == Y_START+v_mask+520)&&(H_Cont>=X_START+100 	&& H_Cont<=X_START+660 &&
						V_Cont>=Y_START+v_mask+50 	&& V_Cont<=Y_START+v_mask+530)) ? 0 :((	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	(i_sobel? Result : iGreen)	:	0);
						
assign	mVGA_B	=	((H_Cont == X_START+100 || H_Cont == X_START+660 || V_Cont == Y_START+v_mask+50 || V_Cont == Y_START+v_mask+520)&&(H_Cont>=X_START+100 	&& H_Cont<=X_START+660 &&
						V_Cont>=Y_START+v_mask+50 	&& V_Cont<=Y_START+v_mask+520)) ? 0 :((	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	(i_sobel? Result : iBlue)	:	0);


// assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT && V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT ) ?	Result	:	0;

//Test
/*					
always@(posedge iCLK or negedge iRST_N) begin
	if (!iRST_N) o_vga_test <= 0;
	else o_vga_test <= draw;
end
*/
						
always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			begin
				oVGA_R <= 0;
				oVGA_G <= 0;
            oVGA_B <= 0;
				oVGA_BLANK <= 0;
				oVGA_SYNC <= 0;
				oVGA_H_SYNC <= 0;
				oVGA_V_SYNC <= 0; 
			end
		else
			begin
				oVGA_R <= mVGA_R;
				oVGA_G <= mVGA_G;
            oVGA_B <= mVGA_B;
				oVGA_BLANK <= mVGA_BLANK;
				oVGA_SYNC <= mVGA_SYNC;
				oVGA_H_SYNC <= mVGA_H_SYNC;
				oVGA_V_SYNC <= mVGA_V_SYNC;				
			end               
	end

//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
		oRequest	<=	0;
	else begin
		if(	H_Cont>=X_START-2 && H_Cont<X_START+H_SYNC_ACT-2 &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		oRequest	<=	1;
		else
		oRequest	<=	0;
	end
end

//	H_Sync Generator, Ref. 40 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		mVGA_H_SYNC	<=	0;
		else
		mVGA_H_SYNC	<=	1;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL + 2)
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC + 2)
			mVGA_V_SYNC	<=	0;
			else
			mVGA_V_SYNC	<=	1;
		end
	end
end

// Image Processing

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N) std <= 300;
	else if(i_key_up) std <= (std <= 1000)? std + 20 : std;
	else if(i_key_down) std <= (std >= 20)? std - 20 : std;
end

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N) draw <= 0;
	else if(oDATA_COUNT >= 7500) draw <= 0;
	else if(H_Cont==0 && (V_Cont == 0) && iDraw) draw <= 1;
end

function [9:0] abs;
	input [9:0] data_in;
	if (data_in[9]) abs = 1 + (~data_in[9:0]);
	else abs = data_in;
endfunction

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N) begin
		Result	<= 0;
		Last_Pixel <= 0;
		P_Cont <= 0;
		oDATA_TO_FLASH <= 0;
		oDATA_COUNT <= 0;
		oSTART_WRITE <= 0;
		o_vga_test <= 0;
		pixel_counter <= 0;
		for(i = 0; i < H_SYNC_ACT; i = i+1) begin
			Line_1[i] <= 0;
			Line_2[i] <= 0;
			Line_3[i] <= 0;
			Line_sobel1[i] <= 0;
			Line_sobel2[i] <= 0;
			Line_sobel3[i] <= 0;
		end
	end else begin
		if(H_Cont>=X_START && H_Cont<X_START+H_SYNC_ACT &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT) begin

			for(i = 1; i < H_SYNC_ACT; i = i+1) begin
				Line_1[i] <= Line_1[i-1];
				Line_2[i] <= Line_2[i-1];
				Line_3[i] <= Line_3[i-1];
				Line_sobel1[i] <= Line_sobel1[i-1];
				Line_sobel2[i] <= Line_sobel2[i-1];
				Line_sobel3[i] <= Line_sobel3[i-1];
			end
			Line_1[0] <= (V_Cont<Y_START+V_SYNC_ACT)? iGreen : 0;
			Line_2[0] <= Line_1[H_SYNC_ACT-1];
			Line_3[0] <= Line_2[H_SYNC_ACT-1];
			Line_sobel1[0] <= (abs(Line_1[H_SYNC_ACT-3] + 2*Line_1[H_SYNC_ACT-2] + Line_1[H_SYNC_ACT-1] - Line_3[H_SYNC_ACT-3] - 2*Line_3[H_SYNC_ACT-2] - Line_3[H_SYNC_ACT-1]) + abs(Line_1[H_SYNC_ACT-1] + 2*Line_2[H_SYNC_ACT-1] + Line_3[H_SYNC_ACT-1] - Line_1[H_SYNC_ACT-3] - 2*Line_2[H_SYNC_ACT-3] - Line_3[H_SYNC_ACT-3]) > std) ? 1 : 0;
			Line_sobel2[0] <= Line_sobel1[H_SYNC_ACT-1];
			Line_sobel3[0] <= Line_sobel2[H_SYNC_ACT-1];
			
			if((H_Cont&1) && (V_Cont&1)) Result <= (Line_sobel3[H_SYNC_ACT-1]||Line_sobel3[H_SYNC_ACT-2]||Line_sobel2[H_SYNC_ACT-1]||Line_sobel2[H_SYNC_ACT-2]) ? 1023:0;
			else if(!(H_Cont&1) && (V_Cont&1)) Result <= (Line_sobel3[H_SYNC_ACT-2]||Line_sobel3[H_SYNC_ACT-3]||Line_sobel2[H_SYNC_ACT-2]||Line_sobel2[H_SYNC_ACT-3]) ? 1023:0;
			else if(!(H_Cont&1) && !(V_Cont&1)) Result <= (Line_sobel2[H_SYNC_ACT-2]||Line_sobel2[H_SYNC_ACT-3]||Line_sobel1[H_SYNC_ACT-2]||Line_sobel1[H_SYNC_ACT-3]) ? 1023:0;
			else Result <= (Line_sobel2[H_SYNC_ACT-1]||Line_sobel2[H_SYNC_ACT-2]||Line_sobel1[H_SYNC_ACT-1]||Line_sobel1[H_SYNC_ACT-2]) ? 1023:0;
			
			if(draw && (H_Cont&1) && (V_Cont&1)) begin
				Ave <= Ave*2 + (((Line_sobel3[H_SYNC_ACT-1]||Line_sobel3[H_SYNC_ACT-2]||Line_sobel2[H_SYNC_ACT-1]||Line_sobel2[H_SYNC_ACT-2]) && (H_Cont>X_START+100 	&& H_Cont<X_START+660 &&
						V_Cont>Y_START+v_mask+50 	&& V_Cont<Y_START+v_mask+520))? 1 : 0);
				if ((Line_sobel3[H_SYNC_ACT-1]||Line_sobel3[H_SYNC_ACT-2]||Line_sobel2[H_SYNC_ACT-1]||Line_sobel2[H_SYNC_ACT-2])&& (H_Cont>=X_START+100 && H_Cont<=X_START+700 && V_Cont>=Y_START+v_mask+50 && V_Cont<=Y_START+v_mask+550)) pixel_counter <= pixel_counter+1;
				
				if(P_Cont >= 16) begin
					P_Cont <= 1;
					oDATA_TO_FLASH <= Ave;
					oSTART_WRITE <= 1;
					oDATA_COUNT <= oDATA_COUNT + 1;
				end else begin
					P_Cont <= P_Cont + 1;
					oSTART_WRITE <= 0;
				end
			end else begin
				oSTART_WRITE <= 0;
			end
		end else begin
			P_Cont <= 0;
			oSTART_WRITE <= 0;
		end
	end
end
endmodule