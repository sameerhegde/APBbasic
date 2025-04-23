module slave2
	#(parameter ADDWIDTH = 8, DATAWIDTH = 32)(
	input PCLK,
	input PRESETn,
	input PSEL,
	input PWRITE,
	input PENABLE,
	input [ADDWIDTH-1:0]PADDR,
	input [(DATAWIDTH/8)-1:0]PSTRB,
	input [DATAWIDTH-1:0]PWDATA,
	output reg PREADY,
	output reg[DATAWIDTH-1:0]PRDATA
	);
	
	reg [DATAWIDTH-1:0]mem[0:(2**ADDWIDTH)-1];
	
	reg temp1_PREADY,temp2_PREADY,temp3_PREADY;
	
	/********** Write operation to memory **********/
	always@(posedge PCLK)begin
		if(PRESETn && PSEL && PENABLE && PWRITE) begin
			PRDATA <= 'b0;
			if(PSTRB[0]) mem[PADDR][7:0] <= PWDATA[7:0];
			if(PSTRB[1]) mem[PADDR][15:8] <= PWDATA[15:8];
			if(PSTRB[2]) mem[PADDR][23:16] <= PWDATA[23:16];
			if(PSTRB[3]) mem[PADDR][31:24] <= PWDATA[31:24];
					
			/* for(integer i = 0; i < (DATAWIDTH/8); i = i +1)begin
				if(PSTRB[i]) mem[PADDR][(i*8)+:8] <= PWDATA[(i*8)+:8];
			end */
		end
	end
	
	/********** Read operation from memory **********/
	always@(posedge PCLK)begin
		if(!PRESETn)begin
			PRDATA <= 'b0;
		end
		else begin
			if(!PWRITE)
				PRDATA <= mem[PADDR];
			else
				PRDATA <= 'b0;
		end
	end
		
	always@(posedge PCLK)begin
		if(PSEL && PENABLE)begin
			temp1_PREADY <= 1'b1;
			temp2_PREADY <= temp1_PREADY;
			temp3_PREADY <= temp2_PREADY;
			PREADY <= temp3_PREADY;
		end
		else begin
			temp1_PREADY <= 1'b0;
			temp2_PREADY <= 1'b0;
			temp3_PREADY <= 1'b0;
			PREADY <= 1'b0;
		end
	end
	
endmodule