module apbMaster
	#(parameter ADDWIDTH = 8, DATAWIDTH = 32)(
	//************** Input from top to Master **************
	input PCLK,
	input PRESETn,
	input PWRITEin,
	input transfer,
	input [ADDWIDTH:0]PADDRin,
	input [DATAWIDTH-1:0]PWDATAin,
	input [(DATAWIDTH/8)-1:0]PSTRBin,
	
	//************** Input from Slave to Master **************
	input PREADY,
	input [DATAWIDTH-1:0]PRDATAin,
	
	//************** Output from Master to top **************
	output [DATAWIDTH-1:0]PRDATAout,
	
	//************** Output from Master to Slave **************
	
	output reg PSEL1,PSEL2,
	output reg PENABLE,
	output PWRITEout,
	output [DATAWIDTH-1:0]PWDATAout,
	output [(DATAWIDTH/8)-1:0]PSTRBout,
	output [ADDWIDTH-1:0]PADDRout
	);
	
	localparam IDLE = 'd0, SETUP = 'd1, ACCESS = 'd2;
	
	reg [1:0] currentState, nextState;
	
	always@(posedge PCLK)begin
		if(!PRESETn)
			currentState <= IDLE;
		else 
			currentState <= nextState;
	end
	
	always@(*)begin
		case(currentState)
			IDLE:begin
					if(transfer)
						nextState <= SETUP;
					else 
						nextState <= currentState;
				end
			SETUP: nextState <= ACCESS;
			ACCESS:begin
					if(PREADY == 1'b0)
						nextState <= currentState;
					else if(PREADY == 1'b1 && transfer == 1'b1)
						nextState <= SETUP;
					else 
						nextState <= IDLE;
				end
		endcase
	end
	
	always@(*)begin
		case(currentState)
			IDLE:begin
					{PSEL1,PSEL2} = 2'b00;
					PENABLE = 1'b0;
				end
			SETUP:begin
					{PSEL1,PSEL2} = PADDRin[ADDWIDTH]? 2'b01 : 2'b10 ;
					PENABLE = 1'b0;
				end
			ACCESS:begin
					{PSEL1,PSEL2} = PADDRin[ADDWIDTH]? 2'b01 : 2'b10 ;
					PENABLE = 1'b1;
				end
		endcase
	end
	
	assign PRDATAout = PRDATAin;
	
	assign PWRITEout = PWRITEin;
	assign PWDATAout = PWDATAin;
	assign PSTRBout = PSTRBin;
	assign PADDRout = PADDRin[ADDWIDTH-1:0];
	
endmodule